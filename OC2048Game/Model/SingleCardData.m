//
//  SingleCardData.m
//  OC2048Game
//
//  Created by dhzy on 2023/2/6.
//

#import "SingleCardData.h"

@implementation SingleCardData
- (void)initData:(NSInteger)cardNumber cardPosition:(CGPoint)cardPosition cardIsDelete:(BOOL)cardIsDelete cardID:(NSInteger)cardID firstIntoMainView:(BOOL) firstIntoMainView {
    self.cardNumber = cardNumber;
    self.cardPosition = cardPosition;
    self.cardIsDelete = cardIsDelete;
    self.cardID = cardID;
    self.firstIntoMainView = firstIntoMainView;
}

#pragma mark - public

/// 当卡片移动后，改变其位置
- (void)setSingleCardPos:(CGRect) pos cardNumber:(NSInteger)number {
    self.firstIntoMainView = false;
}

@end
