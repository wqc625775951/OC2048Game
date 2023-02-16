//
//  CardData+GetRandomCard.m
//  OC2048Game
//
//  Created by dhzy on 2023/2/8.
//

#import "CardData+GetRandomCard.h"
#import "CardData+CardMoveFunction.h"
@implementation CardData (GetRandomCard)

#pragma mark - private

/// 判断当前网格是否有空的格子，就不能再添加任何数字了，直接false即可
- (BOOL)isFull {
    for (int i = 0; i <= 3; i = i + 1){
        for (int j = 0; j <= 3; j = j + 1) {
            if ([self isHavePosCardWithArray:CGPointMake(i, j)]) {
                continue;
            }
            else {
                return true;
            }
        }
    }
    return false;
}

#pragma mark - public

/// 生成随机位置，然后加入到网格中,如果没有空的位置，就返回false，表示生成失败
- (SingleCardData *)produceRandNum {
    if([self isFull]) {
        CGFloat x = [CardData randomPoint];
        CGFloat y = [CardData randomPoint];
        while (true) {
            BOOL xyPosIsSpace = true;
            for (SingleCardData* card in self.cardsDataArray) {
                if (card.cardPosition.x == x && card.cardPosition.y == y && card.cardIsDelete == false) {
                    xyPosIsSpace = false;
                    break;
                }
            }
            
            if (xyPosIsSpace == true) {
                SingleCardData* cardData = [[SingleCardData alloc] init];
                [cardData initData:2 cardPosition:CGPointMake(x, y) cardIsDelete:false cardID:0 firstIntoMainView:true];
                [self addCardData:cardData];
                return cardData;
            }
            else {
                x = [CardData randomPoint];
                y = [CardData randomPoint];
            }
        }
    }
    return nil;
}
@end
