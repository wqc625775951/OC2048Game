#import "BackGroundView.h"
// 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface BackGroundView ()
@property(nonatomic, strong, readwrite) UIStackView *stackView;
@end

@implementation BackGroundView

#pragma mark life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.numberArray = @[].mutableCopy;
    NSMutableArray * arrayStack = [[NSMutableArray alloc]init];
    for (int i =0 ; i<4; i++) {
        NSMutableArray * array = [[NSMutableArray alloc]init];
        for (int i =0 ; i<4; i++) {
            UIView * view = [[UIView alloc]init];
            view.backgroundColor = [UIColor lightGrayColor];
            view.layer.cornerRadius = 10.0;
            view.layer.masksToBounds = YES;
            [array addObject:view];
        }
        [self.numberArray addObject:array];
        UIStackView * stackView = [[UIStackView alloc]initWithArrangedSubviews:array];
        [self addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.spacing = 10;
        [arrayStack addObject:stackView];
    }
    
    UIStackView * stackView = [[UIStackView alloc]initWithArrangedSubviews:arrayStack];
    [self addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 10;
    return self;
}

@end
