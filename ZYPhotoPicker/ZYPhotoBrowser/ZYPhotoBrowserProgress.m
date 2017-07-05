//
//  ZYPhotoBrowserProgress.m
//  Hooked
//
//  Created by zhuyongqing on 2017/7/3.
//  Copyright © 2017年 Ilegendsoft. All rights reserved.
//

#import "ZYPhotoBrowserProgress.h"

#define KProgressH 40

@interface ZYPhotoBrowserProgress()

@property(nonatomic,strong) CAShapeLayer *whiteLayer;

@property(nonatomic,strong) CAShapeLayer *blakLayer;

@property(nonatomic,strong) CABasicAnimation *rotation;


@end

@implementation ZYPhotoBrowserProgress

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _blakLayer = [self createShapePathcolor:[UIColor grayColor]];
        _blakLayer.opacity = .5;
        [self.layer addSublayer:_blakLayer];
        
        _whiteLayer = [self createShapePathcolor:[UIColor whiteColor]];
        _whiteLayer.strokeEnd = .2;
        [self.layer addSublayer:_whiteLayer];
        
        _rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        _rotation.fromValue = @0;
        _rotation.toValue = @(M_PI * 2);
        _rotation.repeatCount = MAXFLOAT;
        _rotation.duration = 1;
    }
    return self;
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (hidden) {
        [_whiteLayer removeAnimationForKey:@"rotation"];
    }else{
        
        [_whiteLayer addAnimation:self.rotation forKey:@"rotation"];
    }
}

- (CAShapeLayer *)createShapePathcolor:(UIColor *)color{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(KProgressH/2, KProgressH/2) radius:KProgressH/2 startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, KProgressH, KProgressH);
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.opaque = YES;
    shapeLayer.path = path.CGPath;
    
    return shapeLayer;
}

@end
