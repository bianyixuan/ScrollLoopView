//
//  MyCollectionViewCell.m
//  ScrollLoopView
//
//  Created by bianyixuan on 16/6/28.
//  Copyright © 2016年 com-brandon. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "Masonry.h"
@implementation MyCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}


//位置布局
-(void)setUp
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.width.mas_equalTo(self.contentView);
    }];
}

@end
