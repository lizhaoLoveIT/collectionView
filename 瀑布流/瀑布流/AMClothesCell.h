//
//  AMClothesCell.h
//  瀑布流
//
//  Created by 李朝 on 16/1/24.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMClothesShop;

@interface AMClothesCell : UICollectionViewCell

/** clothesShop 模型 */
@property (strong, nonatomic) AMClothesShop *clothesShop;

@end
