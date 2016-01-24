//
//  AMLineLayout.m
//  UICollectionView
//
//  Created by 李朝 on 16/1/21.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "AMLineLayout.h"

@implementation AMLineLayout


/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(100, 100);
    // 初始是需要一定的偏移量
    CGFloat inset = self.collectionView.frame.size.width * 0.5 - self.itemSize.width * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 获取 super 计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 遍历属性，在原有的属性上进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 计算每个 cell 距离中心点的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        
        // 根据每个 cell 距离中心点的距离计算他们的 scale
        CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}


/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 * 参数 proposedContentOffset 不受外界干扰的情况下，本来应该滚动的偏移量
 * velocity 表示滚动的速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算出滚动完成后的 collectionView 的中心的 x 值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 计算 cell 的矩形框
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    // 获取 super 计算好的属性值
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 用于记录最小的 delta
    CGFloat minDelta = MAXFLOAT;
    
    // 遍历矩形框内的 cell 的中心值
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    
    // 让最近的 cell 显示在中间
    return CGPointMake(proposedContentOffset.x + minDelta, proposedContentOffset.y);
}

@end
