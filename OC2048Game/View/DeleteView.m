//
//  GTDeleteCellView.m
//  SampleApp
//
//  Created by dequanzhu on 2019.
//  Copyright © 2019 dequanzhu. All rights reserved.
//

#import "DeleteView.h"

@interface DeleteView ()

@property (nonatomic, strong, readwrite) UIView *backgroundView;
@property (nonatomic, strong, readwrite) UIButton *deleteButton;
@property (nonatomic, copy, readwrite) dispatch_block_t deleteBlock;
@end

@implementation DeleteView

#pragma mark lift cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
            _backgroundView.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha  = 0.5;
            [_backgroundView addGestureRecognizer:({
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissDeleteView2048)];
                tapGesture;
            })];
            _backgroundView;
        })];

        [self addSubview:({
            _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [_deleteButton addTarget:self action:@selector(_clickButton2048) forControlEvents:UIControlEventTouchUpInside];
            _deleteButton.backgroundColor = [UIColor lightGrayColor];
            [_deleteButton setTitle:@"重新开始" forState:UIControlStateNormal];
            _deleteButton;
        })];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark public

- (void)showDeleteViewFromPoint:(CGPoint)point clickBlock:(dispatch_block_t)clickBlock {
    _deleteButton.frame = CGRectMake(point.x, point.y, 0, 0);
    _deleteBlock = [clickBlock copy];
    [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         self.deleteButton.frame = CGRectMake((self.bounds.size.width - 100) / 2, (self.bounds.size.height - 50) / 2, 100, 50);
     } completion:^(BOOL finished) {
         //动画结束
     }];
}

#pragma mark action

- (void)_dismissDeleteView2048 {
    [self removeFromSuperview];
}

- (void)_clickButton2048 {
    if (_deleteBlock) {
        _deleteBlock();
    }
    [self removeFromSuperview];
}

@end
