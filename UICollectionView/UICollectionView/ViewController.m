//
//  ViewController.m
//  UICollectionView
//
//  Created by 李朝 on 16/1/21.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"
#import "AMLineLayout.h"
#import "AMCircleLayout.h"
#import "AMCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** 图片名数组 */
@property (copy, nonatomic) NSMutableArray *imageNames;
/** collectionView */
@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation ViewController

NSString * const AMCellId = @"AMCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat collectionW = self.view.frame.size.width;
    CGFloat collectionH = 200;
    CGRect frame = CGRectMake(0, 150, collectionW, collectionH);
    
//    AMLineLayout *layout = [[AMLineLayout alloc] init];
    AMCircleLayout *layout = [[AMCircleLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:AMCellId];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if ([self.collectionView.collectionViewLayout isKindOfClass:[AMLineLayout class]]) {
//        [self.collectionView setCollectionViewLayout:[[AMCircleLayout alloc] init] animated:YES];
//    } else {
//        AMLineLayout *layout = [[AMLineLayout alloc] init];
//        layout.itemSize = CGSizeMake(100, 100);
//        [self.collectionView setCollectionViewLayout:layout animated:YES];
//    }
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (indexPath == nil) {
        [self.imageNames addObject:[NSString stringWithFormat:@"1"]];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
        } completion:nil];
    }
    
    
    
}

#pragma mark - UICollectionViewDataSource
#pragma mark -



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AMCellId forIndexPath:indexPath];
    
    cell.imageName = self.imageNames[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.imageNames removeObjectAtIndex:indexPath.item];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        
    }];
}


/**
 * imageNames
 */
- (NSMutableArray *)imageNames
{
    if (_imageNames == nil) {
        
        _imageNames = [NSMutableArray array];
        for (NSInteger i = 0; i < 20; i++) {
            [_imageNames addObject:[NSString stringWithFormat:@"%zd", i]];
        }
    }
    return _imageNames;
}


@end
