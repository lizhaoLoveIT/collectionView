//
//  AMWaterfallLayout.m
//  瀑布流
//
//  Created by 李朝 on 16/1/23.
//  Copyright © 2016年 lizhao. All rights reserved.
//

typedef struct AMMinWaterfallColumn AMMinWaterfallColumn;

#import "AMWaterfallLayout.h"


/**
 * 描述最短的 waterfallColumn
 */
struct AMMinWaterfallColumn {
    // 高度
    CGFloat height;
    // 列数
    NSInteger destinColumn;
    
};

@interface AMWaterfallLayout ()

/** 存储所有的布局 */
@property (strong, nonatomic) NSMutableArray *attributes;

/** 储存所有列的高度 */
@property (strong, nonatomic) NSMutableArray *columnsHeight;

/** contentSize */
@property (assign, nonatomic) CGSize contentSize;
/** 行间距 */
@property (assign, nonatomic, readonly) CGFloat rowMargin;
/** 列间距 */
@property (assign, nonatomic, readonly) CGFloat columnMargin;
/** 列数 */
@property (assign, nonatomic, readonly) NSUInteger columnCount;
/** 内容边距 */
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation AMWaterfallLayout

#pragma mark - 默认配置

// 行与行之间的间隙
static const CGFloat rowMargin = 10;

// 列与列之间的间隙
static const CGFloat columnMargin = 10;
// 列数
static const CGFloat columnCount = 3;
// 边距
static const UIEdgeInsets edgeInsets = {20, 20, 20, 20};

#pragma mark - 重写 get 方法
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterfallLayout:)]) {
        return [self.delegate rowMarginInWaterfallLayout:self];
    } else {
        return rowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterfallLayout:)]) {
        return [self.delegate columnMarginInWaterfallLayout:self];
    } else {
        return columnMargin;
    }
}

- (NSUInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterfallLayout:)]) {
        return [self.delegate columnCountInWaterfallLayout:self];
    } else {
        return columnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterfallLayout:)]) {
        return [self.delegate edgeInsetsInWaterfallLayout:self];
    } else {
        return edgeInsets;
    }
}

#pragma mark - 初始化设置
#pragma mark -

/**
 * 初始化设置所有列的高度
 */
- (void)setupColumnsHeight
{
    // 重新加载先要清除之前的列数
    [self.columnsHeight removeAllObjects];
    
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnsHeight addObject:@(self.edgeInsets.top)];
    }
}

/**
 * 初始化所有 cell 的布局属性
 */
- (void)setupAllCellAttributes
{
    // 清楚之前所有的布局属性
    [self.attributes removeAllObjects];
    
    // 获取商品数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    // 添加布局属性
    for (NSInteger i = 0; i < count; i++) {
        // 获取商品的索引
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 根据索引添加布局
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attributes addObject:attrs];
    }
}

/**
 * 初始化
 */
- (void)prepareLayout
{
    // 初始化设置 contentSize
    self.contentSize = CGSizeZero;
    
    // 初始化设置所有列的高度
    [self setupColumnsHeight];
    
    // 初始化所有 cell 的布局属性
    [self setupAllCellAttributes];
}

#pragma mark - 确定所有 cell 的排布
#pragma mark -


/**
 * 决定 cell 的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributes;
}

/**
 * 返回 indexPath 位置 cell 对应的属性排布
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建 UICollectionViewLayoutAttributes 对象
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    // 计算 cell 宽度
    CGFloat w = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    
    // 找出最短的列的高度和最短的列是哪列
    AMMinWaterfallColumn minWaterfallColumn = [self findMinColumn];
    
    CGFloat h = [self.delegate waterfallLayout:self heightForItemAtIndex:indexPath.item withItemWidth:w];
    // 计算 cell 的 x
    CGFloat x = self.edgeInsets.left + minWaterfallColumn.destinColumn * (w + self.columnMargin);
    // 计算 cell 的 y
    CGFloat y = minWaterfallColumn.height;
    
    // 如果不是第一行，y 值的计算需要加行间距
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    
    attrs.frame = CGRectMake(x, y, w, h);
    // 更新最短列的高度
    self.columnsHeight[minWaterfallColumn.destinColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 确定 contentSize
    CGSize contentSize = self.contentSize;
    if ([self.columnsHeight[minWaterfallColumn.destinColumn] doubleValue]> self.contentSize.height) {
        contentSize.height = CGRectGetMaxY(attrs.frame) + self.edgeInsets.bottom;
    }
    self.contentSize = contentSize;
    
    return attrs;
}

- (AMMinWaterfallColumn)findMinColumn
{
    AMMinWaterfallColumn minWaterfallColumn;
    minWaterfallColumn.destinColumn = 0;
    // 假设最小列的列数等于第一列
    minWaterfallColumn.height = [self.columnsHeight[0] doubleValue];
    
    // 遍历所有的列
    for (NSInteger i = 0; i < self.columnCount; i++) {
        // 取得第 i 列的高度
        CGFloat columnHeight = [self.columnsHeight[i] doubleValue];
        
        if (columnHeight < minWaterfallColumn.height) {
            minWaterfallColumn.height = columnHeight;
            minWaterfallColumn.destinColumn = i;
        }
    }
    
    return minWaterfallColumn;
}

#pragma mark - 返回内容的总大小
#pragma mark -


/**
 * 返回内容的尺寸
 */
- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}



#pragma mark - 懒加载
#pragma mark -


/**
 * attributes
 */
- (NSMutableArray *)attributes
{
    if (_attributes == nil) {
        
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}


/**
 * columnsHeight
 */
- (NSMutableArray *)columnsHeight
{
    if (_columnsHeight == nil) {
        
        _columnsHeight = [NSMutableArray array];
    }
    return _columnsHeight;
}




@end
