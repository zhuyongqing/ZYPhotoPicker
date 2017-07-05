//
//  ZYPhotoBrowserAnimate.h
//  ZYPhotoBrowser
//
//  Created by zhuyongqing on 2017/7/2.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPhotoBrowserAnimate : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic,strong) UIImageView *startView;

@property(nonatomic,strong) UIView *endView;

@property(nonatomic,assign) NSTimeInterval duration;


@end
