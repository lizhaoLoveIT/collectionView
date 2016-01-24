//
//  AMClothesCell.m
//  瀑布流
//
//  Created by 李朝 on 16/1/24.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "AMClothesCell.h"
#import "AMClothesShop.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AMClothesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation AMClothesCell

- (void)awakeFromNib {
    
}

#pragma mark - setter 方法
- (void)setClothesShop:(AMClothesShop *)clothesShop
{
    _clothesShop = clothesShop;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:clothesShop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    self.priceLabel.text = clothesShop.price;
}


@end
