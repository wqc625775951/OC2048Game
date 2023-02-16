//
//  BackGroundView.h
//  OC2048Game
//
//  Created by dhzy on 2023/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackGroundView : UIView
@property(nonatomic, strong, readwrite) NSMutableArray <NSArray<UIView *> *> *numberArray;
@end

NS_ASSUME_NONNULL_END
