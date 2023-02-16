//
//  CardData+CardMergeFunction.h
//  OC2048Game
//
//  Created by dhzy on 2023/2/8.
//

#import "CardData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardData (CardMergeFunction)

- (void)mergeCard:(CameraMoveDirection)dir;
@end

NS_ASSUME_NONNULL_END
