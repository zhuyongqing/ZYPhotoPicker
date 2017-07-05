//
//  ZYPhotoTool.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/4.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoTool.h"
#import "ZYAlbumInfoModel.h"

@implementation ZYPhotoTool

+ (instancetype)shareTool{
    static ZYPhotoTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[ZYPhotoTool alloc] init];
    });
    return _tool;
}

- (void)getAllFetchResults:(void(^)(PHFetchResult *))result{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult;
            if (self.mediaType != ZYPhotoPickMediaTypeDefault) {
                PHAssetMediaType collectionType = PHAssetMediaTypeImage;
                if (self.mediaType == ZYPhotoPickMediaTypeVideo) {
                    collectionType = PHAssetMediaTypeVideo;
                }
                fetchResult = [PHAsset fetchAssetsWithMediaType:collectionType options:options];
            }else{
                fetchResult = [PHAsset fetchAssetsWithOptions:options];
            }
            
            result(fetchResult);
        }
    }];
}

- (void)getOriginImageWithLocaIdentifier:(NSString *)identifier withImage:(void(^)(UIImage *,NSURL *))imageBlock{
    
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    
    PHAsset *asset = result.firstObject;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    
    CGSize pixSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    CGSize targetSize = pixSize;
    if (pixSize.width>750 || pixSize.height>1344) {
        CGFloat ratio = MIN(750/pixSize.width, 1344/pixSize.height);
        targetSize.width *= ratio;
        targetSize.height *= ratio;
    }
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            imageBlock(result,info[@"PHImageFileURLKey"]);
        }
    }];
}


- (void)loadOriginImageWithAsset:(PHAsset *)asset image:(void(^)(UIImage *))getImg{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            getImg(result);
        });
    }];
    
}

- (void)getAllCollectionsWithSize:(CGSize)size withAlbumInfo:(void (^)(ZYAlbumInfoModel *))album{
    
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
         if (status == PHAuthorizationStatusAuthorized) {
             PHAssetCollectionType collectionType = PHAssetCollectionTypeSmartAlbum;
             PHAssetCollectionSubtype collectionSubType = PHAssetCollectionSubtypeAny;
             
             PHFetchResult *smatAblum = [PHAssetCollection fetchAssetCollectionsWithType:collectionType subtype:collectionSubType options:nil];
             [self getAlbumInfoWithResult:smatAblum size:size album:album];
             
             PHFetchResult *userAblum = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
             [self getAlbumInfoWithResult:userAblum size:size album:album];
         }
    }];
    
    
}


- (void)getAlbumInfoWithResult:(PHFetchResult *)result
                          size:(CGSize)size
                         album:(void(^)(ZYAlbumInfoModel *))album{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if (self.mediaType == ZYPhotoPickMediaTypePhoto) {
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeImage];
    }else if(self.mediaType == ZYPhotoPickMediaTypeVideo){
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
    }
    for (int i = 0; i<result.count; i++) {
        PHAssetCollection *collect = result[i];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collect options:options];
        if (result.count != 0) {
            
            ZYAlbumInfoModel *albums = [[ZYAlbumInfoModel alloc] init];
            albums.albumName = collect.localizedTitle;
            albums.assetNumber = result.count;
            albums.fetchResult  = result;
            PHAsset *photoAsset = result.firstObject;
            
            [[PHImageManager defaultManager] requestImageForAsset:photoAsset targetSize:size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                albums.postImage = result;
                album(albums);
            }];
        }
    }
}

@end
