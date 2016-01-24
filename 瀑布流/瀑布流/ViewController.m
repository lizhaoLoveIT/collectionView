//
//  ViewController.m
//  瀑布流
//
//  Created by 李朝 on 16/1/23.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"
#import "AMWaterfallLayout.h"
#import "AMClothesShop.h"
#import "AMClothesCell.h"

#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface ViewController () <UICollectionViewDataSource, AMWaterfallLayoutDelegate>

/** collectionView */
@property (weak, nonatomic) UICollectionView *collectionView;
/** 模型 */
@property (strong, nonatomic) NSMutableArray *clothesShops;

@end

@implementation ViewController

NSString * const AMShopID = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化 collectionView
    [self setupCollectionView];
    
    // 初始化 refresh
    [self setupRefresh];
}

#pragma mark - 初始化
#pragma mark -
- (void)setupCollectionView
{
    AMWaterfallLayout *Layout = [[AMWaterfallLayout alloc] init];
    Layout.delegate = self;
    
    CGRect frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame  collectionViewLayout:Layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMClothesCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:AMShopID];
    
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setupRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewClothesShops)];
    
    // 一进来自动刷新
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreClothesShops)];
}

/**
 * 加载最新的商品
 */
- (void)loadNewClothesShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 字典转模型
        NSArray *clothesShops = [AMClothesShop mj_objectArrayWithFilename:@"1.plist"];
        
        // 加载新的模型时，要删除原来所有的模型
        [self.clothesShops removeAllObjects];
        
        // 加载新的模型
        [self.clothesShops addObjectsFromArray:clothesShops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
    });
}

/**
 * 加载更多商品
 */
- (void)loadMoreClothesShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *clothesShops = [AMClothesShop mj_objectArrayWithFilename:@"1.plist"];
        [self.clothesShops addObjectsFromArray:clothesShops];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    });
}

#pragma mark - UICollectionViewDataSource
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.clothesShops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMClothesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AMShopID forIndexPath:indexPath];
    cell.clothesShop = self.clothesShops[indexPath.item];
    return cell;
}

#pragma mark - AMWaterfallLayoutDelegate
#pragma mark -

- (CGFloat)waterfallLayout:(AMWaterfallLayout *)waterfallLayout heightForItemAtIndex:(NSUInteger)index withItemWidth:(CGFloat)width
{
    // 取出模型
    AMClothesShop *clothesShop = self.clothesShops[index];
    return width / clothesShop.w * clothesShop.h;
}

- (CGFloat)rowMarginInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout
{
    return 10;
}

- (NSUInteger)columnCountInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout
{
    return 3;
}

- (CGFloat)columnMarginInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout
{
    return 10;
}

- (UIEdgeInsets)edgeInsetsInWaterfallLayout:(AMWaterfallLayout *)waterfallLayout
{
    return UIEdgeInsetsMake(0, 10, 10, 20);
}



#pragma mark - 懒加载
#pragma mark -


/**
 * clothesShops
 */
- (NSMutableArray *)clothesShops
{
    if (_clothesShops == nil) {
        _clothesShops = [NSMutableArray array];
    }
    return _clothesShops;
}


@end
