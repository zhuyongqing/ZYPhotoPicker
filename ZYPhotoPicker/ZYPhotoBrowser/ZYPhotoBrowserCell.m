//
//  ZYPhotoBrowserCell.m
//  ZYPhotoBrowser
//
//  Created by zhuyongqing on 2017/7/2.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoBrowserCell.h"
#import "ZYPhotoBrowserProgress.h"
#import "UIImageView+WebCache.h"
#import "ZYPhotoTool.h"

@interface ZYPhotoBrowserCell()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) ZYPhotoBrowserProgress *progress;



@end

#define KProgressH 40
#define KWinsize [UIScreen mainScreen].bounds.size

@implementation ZYPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _photoImgView = [[UIImageView alloc] init];
        _photoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:_photoImgView];
        
        _progress = [[ZYPhotoBrowserProgress alloc] init];
        
        _progress.frame = CGRectMake(0, 0, KProgressH, KProgressH);
        _progress.hidden = YES;
        _progress.center = CGPointMake(KWinsize.width/2, KWinsize.height/2);
        [self addSubview:_progress];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scalePhotoImageView)];
        doubleTap.numberOfTapsRequired = 2;
        [_photoImgView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    self.photoImgView.image = image;
    [self setImageFrameWithImage:image];
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    self.progress.hidden = NO;
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progress.hidden = YES;
        self.photoImgView.image = image;
        [self setImageFrameWithImage:image];
    }];
}

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    self.progress.hidden = NO;
    [[ZYPhotoTool shareTool] getOriginImageWithLocaIdentifier:asset.localIdentifier withImage:^(UIImage *result, NSURL *url) {
        self.progress.hidden = YES;
        _photoImgView.image = result;
        [self setImageFrameWithImage:result];
    }];
}

- (void)setImageFrameWithImage:(UIImage *)image{
    CGFloat imgH = image.size.height * KWinsize.width/image.size.width;
    self.scrollView.frame = self.bounds;
    self.scrollView.zoomScale = 1.0;
    self.photoImgView.frame = CGRectMake(0, 0, KWinsize.width, imgH);
    self.photoImgView.center = self.progress.center;
}

- (CGPoint)photoImgVCenter{
    CGFloat y = self.scrollView.contentSize.height/2;
    if (self.scrollView.zoomScale == 1. || self.scrollView.contentSize.height < CGRectGetHeight(self.scrollView.bounds)) {
        y = CGRectGetHeight(self.scrollView.bounds)/2;
    }
    return CGPointMake(self.scrollView.contentSize.width/2, y);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.photoImgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    self.photoImgView.center = [self photoImgVCenter];
}

- (void)scalePhotoImageView{
    float scale = self.scrollView.maximumZoomScale;
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
        scale = 1.0;
    }
    [self.scrollView setZoomScale:scale animated:YES];
}

- (void)singleTapAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowserDismiss)]) {
        [self.delegate photoBrowserDismiss];
    }
}

@end
