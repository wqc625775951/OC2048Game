//
//  ViewController.m
//  OC2048Game
//
//  Created by dhzy on 2023/2/3.
//

#import "BackViewController.h"
#import "Masonry.h"
#import "BackGroundView.h"
#import "DeleteView.h"
#import "CardData.h"
#import "CardData+GetRandomCard.h"

@interface BackViewController ()
@property (nonatomic, strong, readwrite) BackGroundView *backGroundView;
@property (nonatomic, strong, readwrite) DeleteView *deleteView;
@property (nonatomic, strong, readwrite) UILabel *historySoreTitle;
@property (nonatomic, strong, readwrite) UILabel *historyScore;
@property (nonatomic, strong, readwrite) UILabel *currentScoreTitle;
@property (nonatomic, strong, readwrite) UILabel *currentScore;
@property (nonatomic, strong, readwrite) UIButton *reButton;
@property (nonatomic, strong, readwrite) CardData *cardData;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *tapGesture;
@property (nonatomic, strong, readwrite) NSMutableArray *isExistCardArray;
@property (nonatomic, strong, readwrite) UIView *transparencyBackGround;
@property (nonatomic, readwrite) CameraMoveDirection direction;
/// 卡片字典： Key: CardId, Value: SingleCardView
@property (nonatomic, strong) NSMutableDictionary *cardViews;
@property (nonatomic, assign) CGFloat gestureMinimumTranslation;
@property (nonatomic, assign) BOOL isCardProduceOnce;
@end

@implementation BackViewController

// - MARK:
#pragma mark - Life Cycle

/// 加载UI和数据
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

/// Review: VC声明周期可以深入了解
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutCards];
}

#pragma mark - Public

#pragma mark - Private

/// Review: UI布局等 VC初次加载的动作，需要分块， 方法的职责单一原则
- (void)setupUI {
    [self.view addSubview:self.reButton];
    [self.reButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.equalTo(@60);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
    
    [self.view addSubview:self.historySoreTitle];
    [self.historySoreTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
    }];
    
    [self.view addSubview:self.historyScore];
    [self.historyScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.historySoreTitle);
        make.top.equalTo(self.historySoreTitle.mas_bottom).offset(5);
    }];
     
    [self.view addSubview:self.currentScore];
    [self.currentScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.historyScore.mas_bottom).offset(50);
    }];
    
    [self.view addSubview:self.currentScoreTitle];
    [self.currentScoreTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.historyScore.mas_top).offset(30);
    }];
    
    [self.view addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.historyScore.mas_bottom).offset(100);
        make.bottom.equalTo(self.reButton.mas_top).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.view addSubview:self.transparencyBackGround];
    [self.transparencyBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backGroundView);
    }];
    
    self.cardData = [[CardData alloc] init];
    self.cardViews = [[NSMutableDictionary alloc] init];
    _tapGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.transparencyBackGround addGestureRecognizer:_tapGesture];
}

/// 加载必要数据
- (void)loadData {
    self.gestureMinimumTranslation = 15.0;
    self.isCardProduceOnce = true;
    NSInteger historyScoreFromUserDefaults = [[NSUserDefaults standardUserDefaults] integerForKey:@"historyMaxScore"];
    if(historyScoreFromUserDefaults != 0){
        self.historyScore.text = [NSString stringWithFormat:@"%ld", historyScoreFromUserDefaults];
    }
}

/// 初始化两张卡片
- (void)layoutCards {
    for(SingleCardData *generalSingleCardData in self.cardData.cardsDataArray){
        [self setCardWithSingleCardData:generalSingleCardData];
    }
}

#pragma mark Helper

#pragma mark Action

/// 获得随机的坐标
// Review: 大括号与方法名之间要空格
- (CGPoint)getCardRandOriPos {
    // Review: 运算符之间要空格
    CGFloat x1 = [CardData randomPoint];
    CGFloat y1 = [CardData randomPoint];
    return CGPointMake(x1, y1);
}

/// 根据坐标获得背景卡片对应的位置
- (CGRect)getPosWithbackGroundCGPoint:(CGPoint) pos{
    UIView* view = [[self.backGroundView.numberArray objectAtIndex:pos.x] objectAtIndex:pos.y];
    return [self.view convertRect:view.frame fromView:view.superview];
}

/// 获得StackView的UI
- (UIView *)backgroundCardWithRow:(NSInteger)row colum:(NSInteger)colum {
    NSArray<NSArray<UIView *> *> *numberArray = self.backGroundView.numberArray;
    if (numberArray.count <= row) {
        return nil;
    }
    NSArray<UIView *> *columViewList = numberArray[row];
    if (columViewList.count <= colum) {
        return nil;
    }
    return columViewList[colum];
}

/// Review: View和Model需要强关联时候的解耦办法，用Map来管理
- (SingleCard *)generateSingleCardWithCardId:(NSInteger)cardId {
    // 理论上有个数据结构， 这里偷懒
    SingleCard *card = self.cardViews[@(cardId)];
    if (!card) {
        card = [[SingleCard alloc] init];
         self.cardViews[@(cardId)] = card;
        [self.view addSubview:card];
        [self.view bringSubviewToFront:self.transparencyBackGround];
    }
    return card;
}

- (void)removeUnExistCard {
    // 1. 遍历 self.cardData.cardsDataArray 无效id，并移除UI
    for (SingleCardData *data in self.cardData.cardsDataArray) {
        if (data.cardIsDelete) {
            UIView *view = self.cardViews[@(data.cardID)];
            [view removeFromSuperview];
            [self.cardViews removeObjectForKey:@(data.cardID)];
        }
    }
    // 2. 清空无效id的carddata
    [self.cardData clearInvaildData];
}

- (void)setCardWithSingleCardData:(SingleCardData *)singleCardData {
    CGPoint pos = singleCardData.cardPosition;
    SingleCard *card = [self generateSingleCardWithCardId:singleCardData.cardID];
    [card refreshWithData:singleCardData];
    UIView *backgroundCard = [self backgroundCardWithRow:pos.x colum:pos.y];
    [card mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundCard);
    }];
}

/// 判断移动的方向，计算出卡片下一跳的位置，然后移动卡片
- (void)handleSwipeFrom:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.direction = kCameraMoveDirectionNone;
    }else if (gesture.state == UIGestureRecognizerStateChanged && self.direction == kCameraMoveDirectionNone) {
        if (self.isCardProduceOnce) {
            self.isCardProduceOnce = false;
            self.direction = [self determineCameraDirectionIfNeeded:translation];
            [self.cardData moveAndMerge:self.direction];
            // 1. 删除所有合并的卡片
            [self removeUnExistCard];
            
            for (SingleCardData *generalSingleCardData in self.cardData.cardsDataArray) {
                // 2. 重新布局SingCard
                [self setCardWithSingleCardData:generalSingleCardData];
            }
            // 3. SingCardData，如果空：游戏结束，非空：有新的Card产生.
            SingleCardData *randomSingleCard = [self.cardData produceRandNum];
            if(randomSingleCard == nil) {
                // 已经满了，说明游戏结束了
                [self _clickButton];
            }else {
                [self setCardWithSingleCardData:randomSingleCard];
            }
            self.currentScore.text = [NSString stringWithFormat:@"%d",self.cardData.currScore];
        }
    }
    if(gesture.state == UIGestureRecognizerStateEnded) {
        self.isCardProduceOnce = true;
        // Test
        // NSLog (@ "Stop gesture" );
    }
}
 
/// 确定移动的方向
- (CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation
{
    if (self.direction != kCameraMoveDirectionNone) {
        return self.direction;
    }
    if (fabs(translation.x) > self.gestureMinimumTranslation) {
        BOOL gestureHorizontal = NO;
        if (translation.y == 0.0) gestureHorizontal = YES;
        else gestureHorizontal = (fabs(translation.x / translation.y) > 5.0);
        if(gestureHorizontal) {
            if (translation.x > 0.0) return kCameraMoveDirectionRight;
            else return kCameraMoveDirectionLeft;
        }
    }else if(fabs(translation.y) > self.gestureMinimumTranslation) {
        BOOL gestureVertical = NO;
        if (translation.x == 0.0) gestureVertical = YES;
        else gestureVertical = (fabs(translation.y / translation.x) > 5.0);
        if(gestureVertical) {
            if (translation.y > 0.0) return kCameraMoveDirectionDown;
            else return kCameraMoveDirectionUp;
        }
    }
    return self.direction;
}

/// 点击重新开始或结束游戏后的回调函数
- (void)_clickButton {
    //动画演示
    _deleteView = [[DeleteView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_deleteView];
    CGRect rect = CGRectMake(self.view.bounds.size.width - 70/2.0, self.view.bounds.size.height + 70/2.0, 0, 0);
    
    __weak typeof(self)wself = self;
    [_deleteView showDeleteViewFromPoint:rect.origin clickBlock:^{
         __strong typeof(wself) strongSelf = wself;
        // 1. 将所有卡片删除的标识符置为true
        for(SingleCardData *generalSingleCardData in self.cardData.cardsDataArray){
            generalSingleCardData.cardIsDelete = true;
        }
        // 2. 从map和ui中移除所有的卡片
        [self removeUnExistCard];
        // 3. 初始化各类数据
        [strongSelf.cardData resumeGame];
        [self.cardViews removeAllObjects];
        strongSelf.currentScore.text = @"0";
        // 4. 重新加载两种卡片的UI
        [self layoutCards];
     }];
}

#pragma mark - Property
/// 问题：有必要对每一个属性都进行懒加载吗？会不会代码量太庞大了
// Review: 属性推荐懒加载方式
- (UIButton *)reButton {
    if (!_reButton) {
        _reButton = [[UIButton alloc] init];
        [_reButton setImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateNormal];
        _reButton.imageEdgeInsets = UIEdgeInsetsMake(70, 70, 70, 70);
        [_reButton addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reButton;
}

- (UILabel *)historySoreTitle {
    if (!_historySoreTitle) {
        _historySoreTitle = [[UILabel alloc] init];
        _historySoreTitle.text = @"历史最高分";
        _historySoreTitle.font = [UIFont systemFontOfSize:20];
        _historySoreTitle.textColor = [UIColor redColor];
    }
    return _historySoreTitle;
}

- (UILabel *)historyScore {
    if (!_historyScore) {
        _historyScore = [[UILabel alloc] init];
        _historyScore.text = @"0";
        _historyScore.font = [UIFont systemFontOfSize:20];
        _historyScore.textColor = [UIColor redColor];
    }
    return _historyScore;
}

- (UILabel *)currentScore {
    if (!_currentScore) {
        _currentScore = [[UILabel alloc] init];
        _currentScore.text = @"0";
        _currentScore.font = [UIFont systemFontOfSize:25];
    }
    return _currentScore;
}

- (UILabel *)currentScoreTitle {
    if (!_currentScoreTitle) {
        _currentScoreTitle = [[UILabel alloc] init];
        _currentScoreTitle.text = @"当前得分";
        _currentScoreTitle.font = [UIFont systemFontOfSize:28];
    }
    return _currentScoreTitle;
}

- (BackGroundView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[BackGroundView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    }
    return _backGroundView;
}

- (UIView *)transparencyBackGround {
    if (!_transparencyBackGround) {
        _transparencyBackGround = [[UIView alloc] init];
        _transparencyBackGround.alpha = 0.5;
    }
    return _transparencyBackGround;
}

// 问题：为了减少代码量，可以使用extension把代码给拆开吗？还是优先调整结构

@end
