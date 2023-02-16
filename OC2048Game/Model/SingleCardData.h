//
//  SingleCardData.h
//  OC2048Game
//
//  Created by dhzy on 2023/2/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SingleCard.h"
NS_ASSUME_NONNULL_BEGIN

@interface SingleCardData : NSObject
@property (nonatomic, assign) BOOL cardIsDelete;
@property (nonatomic, assign) CGPoint cardPosition;
@property (nonatomic, assign) NSInteger cardID;
@property (nonatomic, assign) BOOL firstIntoMainView;
// Review: 成员变量都用属性的方式来声明
@property (nonatomic, assign) NSInteger cardNumber;
- (void)initData:(NSInteger)cardNumber cardPosition:(CGPoint)cardPosition cardIsDelete:(BOOL)cardIsDelete cardID:(NSInteger)cardID firstIntoMainView:(BOOL) firstIntoMainView;

- (void)setSingleCardPos:(CGRect) pos cardNumber:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
