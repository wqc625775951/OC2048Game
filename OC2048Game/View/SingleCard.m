//
//  SingleCard.m
//  OC2048Game
//
//  Created by dhzy on 2023/2/4.
//

#import "SingleCard.h"
#import "Masonry.h"
#import "SingleCardData.h"

@interface SingleCard()
@property(nonatomic, strong, readwrite) UILabel *num;
@property(nonatomic, strong, readwrite) NSArray *numColorArray;
@end

@implementation SingleCard

- (instancetype)init {
    self = [super init];
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    
    _num = [[UILabel alloc] init];
    [self addSubview:_num];
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    _num.text = @"2";
    _num.font = [UIFont fontWithName:@"Helvetica-Bold" size:40.f];
    _num.textColor = [UIColor whiteColor];
    
    // 颜色数组
    _numColorArray = @[[UIColor whiteColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor]];
    return self;
}

// 改变卡片数字大小和颜色
- (void)refreshWithData:(SingleCardData *)cardData {
    self.num.text = [NSString stringWithFormat:@"%ld", cardData.cardNumber];
    int cardNumColorindex = log2(cardData.cardNumber);
    self.num.textColor = [self.numColorArray objectAtIndex:cardNumColorindex];
}

@end
