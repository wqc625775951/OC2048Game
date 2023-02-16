//
//  CardData.m
//  OC2048Game
//
//  Created by dhzy on 2023/2/4.
//

#import "CardData.h"
#import "CardData+CardMergeFunction.h"
#import "CardData+CardMoveFunction.h"

@interface CardData ()

@end

@implementation CardData

#pragma mark life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cardsDataArray = @[].mutableCopy;
        [self initTwoCard];
    }
    return self;
}

#pragma mark private
/// 添加单张卡片数据到数组中
- (void)addCardData:(SingleCardData *)data {
    SingleCardData* cardData = [[SingleCardData alloc] init];
    [cardData initData:data.cardNumber cardPosition:data.cardPosition cardIsDelete:data.cardIsDelete cardID:(int)self.cardsDataArray.count + rand() % 1000000 + rand() % 2000000 firstIntoMainView:data.firstIntoMainView];
    [self.cardsDataArray addObject:cardData];
}

/// 初始化两张卡片
- (void)initTwoCard {
    CGFloat x1 = [CardData randomPoint];
    CGFloat y1 = [CardData randomPoint];
    SingleCardData* cardData = [[SingleCardData alloc] init];
    [cardData initData:2 cardPosition:CGPointMake(x1, y1) cardIsDelete:false cardID:0 firstIntoMainView:true];
    [self addCardData:cardData];
    while(true){
        CGFloat x2 = [CardData randomPoint];
        CGFloat y2 = [CardData randomPoint];
        if (x1 != x2 && y1 != y2) {
            SingleCardData* cardData = [[SingleCardData alloc] init];
            [cardData initData:2 cardPosition:CGPointMake(x2, y2) cardIsDelete:false cardID:0 firstIntoMainView:true];
            [self addCardData:cardData];
            return;
        }
        else {
            x2 = [CardData randomPoint];
            y2 = [CardData randomPoint];
        }
    }
}

#pragma mark public

/// 重新开始游戏，初始化里面的数据
- (void)resumeGame {
    [self.cardsDataArray removeAllObjects];
    self.cardsDataArray = @[].mutableCopy;
    self.currScore = 0;
    [self initTwoCard];
}

/// 移动卡片以及合并卡片 dir: 移动方向
- (void)moveAndMerge:(CameraMoveDirection)dir {
    [self moveCard:dir];
    [self mergeCard:dir];
    [self moveCard:dir];
}

/// 清楚数组中已经被删除的card数据
- (void)clearInvaildData {
    NSMutableArray *arr = @[].mutableCopy;
    for (SingleCardData *data in self.cardsDataArray) {
        if (!data.cardIsDelete) {
            [arr addObject:data];
        }
    }
    self.cardsDataArray = arr.mutableCopy;
}

#pragma mark static

/// Review: 重复的计算，抽出来
+ (CGFloat)randomPoint {
    return arc4random() % 200 / 50;
}

@end
