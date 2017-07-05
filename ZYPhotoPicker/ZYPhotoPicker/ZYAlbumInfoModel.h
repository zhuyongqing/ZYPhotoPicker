//
//  ZYAlbumInfoModel.h
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/5.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@interface ZYAlbumInfoModel : NSObject

@property(nonatomic,copy) NSString *albumName;

@property(nonatomic,assign) NSInteger assetNumber;

@property(nonatomic,strong) UIImage *postImage;

@property(nonatomic,strong) PHFetchResult *fetchResult;


@end
