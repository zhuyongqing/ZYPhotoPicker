//
//  ZYPhotoTool.h
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/4.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "ZYPhotoPicker.h"
@class ZYAlbumInfoModel;

@interface ZYPhotoTool : NSObject

@property(nonatomic,assign) ZYPhotoPickMediaType mediaType;


+ (instancetype)shareTool;


- (void)getAllFetchResults:(void(^)(PHFetchResult *))result;

- (void)getOriginImageWithLocaIdentifier:(NSString *)identifier withImage:(void(^)(UIImage *,NSURL *))imageBlock;

- (void)getAllCollectionsWithSize:(CGSize)size withAlbumInfo:(void(^)(ZYAlbumInfoModel *))album;

- (void)loadOriginImageWithAsset:(PHAsset *)asset image:(void(^)(UIImage *))getImg;

@end
