//
//  CardData.h
//  OC2048Game
//
//  Created by dhzy on 2023/2/4.
//

#import <UIKit/UIKit.h>
#import "SingleCardData.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection ;
 
@interface CardData : NSObject
@property (nonatomic, strong, readwrite) NSMutableArray *cardsDataArray;
@property (nonatomic, assign) NSInteger currScore;
@property (nonatomic, assign) NSInteger historyMaxScore;

- (void)resumeGame;
- (void)moveAndMerge:(CameraMoveDirection)dir;
- (void)clearInvaildData;
- (void)addCardData:(SingleCardData *)data;

+ (CGFloat)randomPoint;
@end

NS_ASSUME_NONNULL_END
