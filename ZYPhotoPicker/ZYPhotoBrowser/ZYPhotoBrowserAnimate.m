//
//  ZYPhotoBrowserAnimate.m
//  ZYPhotoBrowser
//
//  Created by zhuyongqing on 2017/7/2.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoBrowserAnimate.h"

@implementation ZYPhotoBrowserAnimate

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *formVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    
    BOOL isPresent = toVc.presentingViewController == formVc;
    
    if (!isPresent) {
        [containerView addSubview:toVc.view];
    }
    
    CGRect startFrame = [self.startView.superview convertRect:self.startView.frame toView:containerView];
    if (CGRectEqualToRect(startFrame, CGRectZero)) {
        startFrame = CGRectMake(0,0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    }
    UIView *backView = [[UIView alloc] initWithFrame:containerView.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = !isPresent;
    [containerView addSubview:backView];
    
    UIImageView *scaleView = [[UIImageView alloc] initWithFrame:startFrame];
    scaleView.image = self.startView.image;
    scaleView.contentMode = UIViewContentModeScaleAspectFill;
    scaleView.layer.masksToBounds = YES;
    [containerView addSubview:scaleView];
    if (!isPresent) {
        formVc.view.hidden = YES;
    }
    
    CGFloat imageH = scaleView.image.size.height * CGRectGetWidth(containerView.frame)/scaleView.image.size.width;
    
    CGRect endFrame = CGRectMake(0, CGRectGetHeight(containerView.frame)/2 - imageH/2, CGRectGetWidth(containerView.frame), imageH);
    
    if (!isPresent) {
        endFrame = [self.endView.superview convertRect:self.endView.frame toView:containerView];
    }
    
    if (!self.startView.image) {
        endFrame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), startFrame.size.height);
    }
    
    [UIView animateWithDuration:self.duration animations:^{
        scaleView.frame = endFrame;
        if (!isPresent) {
            backView.alpha = 0;
        }else
            backView.alpha = 1;
    } completion:^(BOOL finished) {
        if (isPresent) {
            [containerView addSubview:toVc.view];
        }else{
            [formVc.view removeFromSuperview];
        }
        [scaleView removeFromSuperview];
        [backView removeFromSuperview];
        BOOL isCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!isCancelled];
    }];
    
}

@end
