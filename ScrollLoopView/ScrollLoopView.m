//
//  ScrollLoopView.m
//  ScrollLoopView
//
//  Created by bianyixuan on 16/6/28.
//  Copyright © 2016年 com-brandon. All rights reserved.
//

#import "ScrollLoopView.h"
#import "MyCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#define NSTimeIntervalDefault 2.0

static NSString *identify = @"cellidentiry";

@interface ScrollLoopView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , weak) NSTimer *timer;
@property (nonatomic , assign) NSInteger totalImageCount;
@property (nonatomic , weak) UIPageControl *pageControl;

@end

@implementation ScrollLoopView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self initsConfig];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initsConfig];
    self.autoresizingMask = UIViewAutoresizingNone;
}

-(void)setArrayImages:(NSArray *)arrayImages
{
    _arrayImages = arrayImages;
    _totalImageCount = _arrayImages.count * 10;
    if (arrayImages.count != 1) {
        [self setupTimer];
        _pageControl.numberOfPages = arrayImages.count;
    }
    return [_collectionView reloadData];
}

/**
 *  配置基本框架
 */
-(void)initsConfig
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:identify];
    _collectionView = collectionView;
    [self addSubview:collectionView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    _pageControl = pageControl;
    [self addSubview:pageControl];
    
}

-(void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:NSTimeIntervalDefault target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    _timer = timer;
    //程序之所以能一直运行时因为在一个循环里面，当创建了一个NSTimer的时候，系统有可能不会将这个定时器添加到主循环中，这个时候定时器可能会失效，所以安全起见将定时器添加到主循环中。
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)autoScroll
{
    int currentIndex = [self currentIndex];
    
    int tarIndex = currentIndex + 1;
    if (tarIndex >= _totalImageCount) {
        tarIndex = _totalImageCount * 0.5;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tarIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        return;
    }
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tarIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

-(int)currentIndex
{
    if (_collectionView.frame.size.width ==0) {
        return 0;
    }
    int index = 0;
    index = (_collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    return index;
}

-(void)invalidateTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalImageCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    long index = indexPath.item % self.arrayImages.count;
    if (![self.arrayImages[index] hasPrefix:@"http"]) {
        cell.imageView.image = [UIImage imageNamed:self.arrayImages[index]];
        return cell;
    }
    [cell.imageView sd_setImageWithURL:self.arrayImages[index]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(scrollLoopView:didSelectedItemAtIndex:)]) {
        [self.delegate scrollLoopView:self didSelectedItemAtIndex:(int)indexPath.item % self.arrayImages.count];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = [self currentIndex];
    _pageControl.currentPage = index % self.arrayImages.count;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    _collectionView.frame = self.bounds;
    
    if (_collectionView.contentOffset.x ==0 && _totalImageCount) {
        
        int tarIndex = _totalImageCount * 0.5;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tarIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
    }
    _pageControl.frame = CGRectMake((self.frame.size.width - 100)/2, self.frame.size.height - 30, 100, 20);
}

-(void)dealloc
{
    [self invalidateTimer];
}

@end
