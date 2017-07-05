//
//  ZYAlbumTableCell.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/5.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYAlbumTableCell.h"
#import "ZYAlbumInfoModel.h"
@interface ZYAlbumTableCell()

@property(nonatomic,strong) UIImageView *albumImgV;

@property(nonatomic,strong) UILabel *albumName;

@property(nonatomic,strong) UILabel *numberLabel;


@end

@implementation ZYAlbumTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _albumImgV = [[UIImageView alloc] init];
        _albumImgV.contentMode = UIViewContentModeScaleAspectFill;
        _albumImgV.layer.masksToBounds = YES;
        _albumImgV.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_albumImgV];
        
        _albumName = [[UILabel alloc] init];
        _albumName.font = [UIFont boldSystemFontOfSize:15];
        _albumName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_albumName];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_numberLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imageW = 60;
    CGFloat space = 10;
    CGFloat nameSpace = 15;
    _albumImgV.frame = CGRectMake(space, space, imageW, imageW);
    [_albumName sizeToFit];
    _albumName.frame = CGRectMake(CGRectGetMaxX(_albumImgV.frame) + nameSpace, 0, CGRectGetWidth(_albumName.frame), CGRectGetHeight(self.frame));
    [_numberLabel sizeToFit];
    _numberLabel.frame = CGRectMake(CGRectGetMaxX(_albumName.frame) + nameSpace, 0, CGRectGetWidth(_numberLabel.frame), CGRectGetHeight(self.frame));
}

- (void)setModel:(ZYAlbumInfoModel *)model{
    _model = model;
    _albumImgV.image = model.postImage;
    _albumName.text = model.albumName;
    _numberLabel.text = [NSString stringWithFormat:@"(%ld)",model.assetNumber];
}

@end
