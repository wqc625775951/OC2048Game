//
//  CardData+CardMergeFunction.m
//  OC2048Game
//
//  Created by dhzy on 2023/2/8.
//

#import "CardData+CardMergeFunction.h"
#import "CardData+CardMoveFunction.h"

@implementation CardData (CardMergeFunction)

#pragma mark - public
/// 合并两个卡片，合并的条件：值相等，移动后的位置相等，且卡片未删除
- (void)mergeCard:(CameraMoveDirection)dir {
    [self sortCardData:dir];
    
    for (int i = 0; i < self.cardsDataArray.count; i++) {
        SingleCardData *oriCard = [self.cardsDataArray objectAtIndex:i];
        if (oriCard.cardIsDelete == false) {
            CGPoint currPos = CGPointMake(oriCard.cardPosition.x + [self calculateDirNum:dir].x, oriCard.cardPosition.y + [self calculateDirNum:dir].y);
            // 和自己合并的是本身，则重新找
            if (currPos.x == oriCard.cardPosition.x &&  currPos.y == oriCard.cardPosition.y) {
                continue;
            }
            // 找到待合并位置的index
            int mergeIndex = 0;
            for (SingleCardData *mergeCard in self.cardsDataArray) {
                if (mergeCard.cardPosition.x == currPos.x && mergeCard.cardPosition.y == currPos.y && mergeCard.cardIsDelete == false) {
                    break;
                }
                mergeIndex = mergeIndex + 1;
            }

            if (mergeIndex != self.cardsDataArray.count) {
                SingleCardData *mergeCard = [self.cardsDataArray objectAtIndex:mergeIndex];
                if (mergeCard.cardNumber == oriCard.cardNumber) {
                    mergeCard.cardNumber = mergeCard.cardNumber * 2;
                    oriCard.cardIsDelete = true;

                    for (int i = 2; i < 11; i++) {
                        if(mergeCard.cardNumber == pow(2.0, i)){
                            self.currScore = self.currScore + i;
                            break;
                        }
                    }

                    if (self.historyMaxScore < self.currScore) {
                        self.historyMaxScore = self.currScore;
                        // 当点击某个cell，就把他存到缓存中，方便下次读取的时候，显示已经读取
                        [[NSUserDefaults standardUserDefaults] setInteger:self.historyMaxScore forKey:@"historyMaxScore"];
                    }

                }
            }
        }
    }
}

@end
