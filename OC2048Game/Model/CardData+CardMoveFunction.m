//
//  CardData+CardDataMoveFunction.m
//  OC2048Game
//
//  Created by dhzy on 2023/2/8.
//

#import "CardData+CardMoveFunction.h"

@implementation CardData (CardMoveFunction)

#pragma mark public

/// 根据方向计算移动的距离
- (CGPoint)calculateDirNum:(CameraMoveDirection)Direction {
    switch (Direction) {
        case kCameraMoveDirectionDown:
            return CGPointMake(1, 0);
        case kCameraMoveDirectionUp:
            return CGPointMake(-1, 0);
        case kCameraMoveDirectionRight:
            return CGPointMake(0, 1);
        case kCameraMoveDirectionLeft:
            return CGPointMake(0, -1);
        default:
            return CGPointMake(0, 0);
    }
}

/// 正式移动，先对待移动的卡片按照移动方向进行排序，然后判断准备移动的卡片，是否能够移动到指定位置，如果能就循环移动直到不能移动为止
- (void)moveCard:(CameraMoveDirection)dir {
    [self sortCardData:dir];
    for (int i = 0;i < self.cardsDataArray.count;i++) {
        SingleCardData *cardInIndex = [self.cardsDataArray objectAtIndex:i];
        if (cardInIndex.cardIsDelete == false) {
            while (![self isMovePosHaveCard:cardInIndex.cardPosition dir:dir]) {
                cardInIndex.cardPosition = CGPointMake(cardInIndex.cardPosition.x + [self calculateDirNum:dir].x, cardInIndex.cardPosition.y + [self calculateDirNum:dir].y);
            }
        }
    }
}

/// 给一个位置，判断数组在该位置是否有卡片
- (BOOL)isHavePosCardWithArray:(CGPoint)pos {
    for (SingleCardData* card in self.cardsDataArray) {
        if (card.cardPosition.x == pos.x && card.cardPosition.y == pos.y && card.cardIsDelete == false) {
            return true;
        }
    }
    return false;
}

/// 移动是有顺序的，比如往右移动，那么最靠右的应该先移动
- (void)sortCardData:(CameraMoveDirection)dir {
    switch (dir) {
    case kCameraMoveDirectionUp:
            [self.cardsDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [@(((SingleCardData *)obj1).cardPosition.x) compare: @(((SingleCardData *)obj2).cardPosition.x)];
            }];
            break;
            
    case kCameraMoveDirectionDown:
            [self.cardsDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return -[@(((SingleCardData *)obj1).cardPosition.x) compare: @(((SingleCardData *)obj2).cardPosition.x)];
            }];
            break;
            
    case kCameraMoveDirectionRight:
            [self.cardsDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return -[@(((SingleCardData *)obj1).cardPosition.y) compare: @(((SingleCardData *)obj2).cardPosition.y)];
            }];
            break;
            
    case kCameraMoveDirectionLeft:
            [self.cardsDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [@(((SingleCardData *)obj1).cardPosition.y) compare: @(((SingleCardData *)obj2).cardPosition.y)];
            }];
            break;
        case  kCameraMoveDirectionNone:
            break;
    }
}

#pragma mark private

/// 给一个位置，判断数组中该位置的下标
- (int)getIndexInArray:(CGPoint)pos {
    int index = -1;
    for (SingleCardData* card in self.cardsDataArray) {
        index = index + 1;
        if (card.cardPosition.x == pos.x && card.cardPosition.y == pos.y && card.cardIsDelete == false) {
            return index;
        }
    }
    return -1;
}

/// 准备移到的位置是否已经有卡片了，如果有了，说明无法移动当前卡片
- (BOOL)isMovePosHaveCard:(CGPoint)pos dir:(CameraMoveDirection)dir {
    // 当前方向移动的位置
    CGPoint currPos = CGPointMake(pos.x + [self calculateDirNum:dir].x, pos.y + [self calculateDirNum:dir].y);
    // 判断是否超出了整体的范围框
    if (currPos.x >= 0 && currPos.x <= 3 && currPos.y >= 0 && currPos.y <= 3) {
        // 是否能找到当前位置的数据
        if (![self isHavePosCardWithArray:currPos]) {
            return false;
        }
    }
    return true;
}

@end

