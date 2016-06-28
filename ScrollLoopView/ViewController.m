//
//  ViewController.m
//  ScrollLoopView
//
//  Created by bianyixuan on 16/6/28.
//  Copyright © 2016年 com-brandon. All rights reserved.
//

#import "ViewController.h"
#import "ScrollLoopView.h"
@interface ViewController ()<ScrollLoopViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat SCREENWIDTH = [UIScreen mainScreen].bounds.size.width;
    
    ScrollLoopView *loop = [[ScrollLoopView alloc ]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 200)];
    loop.delegate = self;
    loop.arrayImages = @[
                         @"http://web.img.chuanke.com/fragment/9d595bc8fb5bf049ce3db527ede08abc.jpg",
                         @"http://web.img.chuanke.com/fragment/d662adfaebdc9aa3dac4b04299aa48e1.jpg",
                         @"http://web.img.chuanke.com/fragment/8003092be7e6cc3222c760c89e74a20d.jpg",
                         ];
    [self.view addSubview:loop];
    
    
}






@end
