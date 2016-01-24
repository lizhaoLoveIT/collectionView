//
//  AMCollectionViewCell.m
//  UICollectionView
//
//  Created by 李朝 on 16/1/22.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "AMCollectionViewCell.h"

@interface AMCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation AMCollectionViewCell

- (void)awakeFromNib {
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 10;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
