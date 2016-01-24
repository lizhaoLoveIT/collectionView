//
//  AMWaterfallLayout.h
//  瀑布流
//
//  Created by 李朝 on 16/1/23.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMWaterfallLayout;

@protocol AMWaterfallLayoutDelegate <NSObject>

@required
/**
 * 外界告诉我瀑布流布局的高度
 */
- (CGFloat)waterfallLayout:(AMWaterfallLayout *)waterfallLayout heightForItemAtIndex:(NSUInteger)index withItemWidth:(CGFloat)width;
@optional

/**
 * 有多少列
 */
- (NSUInteger)columnCountInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout;

/**
 * 行与行之间的间隙
 */
- (CGFloat)rowMarginInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout;

/**
 * 列与列之间的间隙
 */
- (CGFloat)columnMarginInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout;

/**
 * collectionView 的周边间隙
 */
- (UIEdgeInsets)edgeInsetsInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout;


@end

@interface AMWaterfallLayout : UICollectionViewLayout
/** 代理 */
@property (weak, nonatomic) id<AMWaterfallLayoutDelegate> delegate;

@end
