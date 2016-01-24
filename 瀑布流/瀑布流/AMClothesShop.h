//
//  AMClothesShop.h
//  瀑布流
//
//  Created by 李朝 on 16/1/23.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMClothesShop : NSObject

/** cellWidth */
@property (assign, nonatomic) CGFloat w;
/** cellHeight */
@property (assign, nonatomic) CGFloat h;
/** image */
@property (copy, nonatomic) NSString *img;
/** price */
@property (copy, nonatomic) NSString *price;


@end
