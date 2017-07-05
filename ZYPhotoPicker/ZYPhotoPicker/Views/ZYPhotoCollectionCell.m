//
//  ZYPhotoCollectionCell.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/4.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoCollectionCell.h"

@interface ZYPhotoCollectionCell()



@property(nonatomic,strong) UIImageView *selectedImgV;


@end

@implementation ZYPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _photoImgV = [[UIImageView alloc] init];
        _photoImgV.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgV.layer.masksToBounds = YES;
        [self addSubview:_photoImgV];
        
        _selectedImgV = [[UIImageView alloc] init];
        _selectedImgV.backgroundColor = [UIColor blackColor];
        _selectedImgV.hidden = YES;
        [self addSubview:_selectedImgV];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selectedW = 20;
    CGFloat space = 5;
    self.photoImgV.frame = self.bounds;
    self.selectedImgV.frame = CGRectMake(CGRectGetWidth(self.frame) - selectedW - space, space, selectedW, selectedW);
}

- (void)setThumnailImg:(UIImage *)thumnailImg{
    _photoImgV.image = thumnailImg;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _selectedImgV.hidden = !selected;
}

@end
