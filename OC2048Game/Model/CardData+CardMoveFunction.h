//
//  CardData+CardDataMoveFunction.h
//  OC2048Game
//
//  Created by dhzy on 2023/2/8.
//

#import "CardData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardData (CardMoveFunction)
- (CGPoint)calculateDirNum:(CameraMoveDirection)Direction;
- (void)moveCard:(CameraMoveDirection)dir;
- (BOOL)isHavePosCardWithArray:(CGPoint)pos;
- (void)sortCardData:(CameraMoveDirection)dir;
@end

NS_ASSUME_NONNULL_END
