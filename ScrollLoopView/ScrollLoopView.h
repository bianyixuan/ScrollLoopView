//
//  ScrollLoopView.h
//  ScrollLoopView
//
//  Created by bianyixuan on 16/6/28.
//  Copyright © 2016年 com-brandon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollLoopView;
@protocol ScrollLoopViewDelegate <NSObject>

@optional

/**
 *  点击ScrollView中的Item
 *
 *  @param scrollLoopView <#scrollLoopView description#>
 *  @param index          <#index description#>
 */
-(void)scrollLoopView:(ScrollLoopView *)scrollLoopView didSelectedItemAtIndex:(int)index;

@end

@interface ScrollLoopView : UIView

/**
 *  图片集合
 */
@property (nonatomic , strong) NSArray *arrayImages;

@property (nonatomic , weak) id<ScrollLoopViewDelegate> delegate;

@end
