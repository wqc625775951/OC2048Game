//
//  SingleCard.h
//  OC2048Game
//
//  Created by dhzy on 2023/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SingleCardData;
@interface SingleCard : UIView

// Review: 接收CardData
- (void)refreshWithData:(SingleCardData *)cardData;

-(void)setSingleCardPos:(CGRect) pos cardNumber:(int)number;
@end

NS_ASSUME_NONNULL_END
