//
//  ZYPhotoPickerController.h
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/5.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPhotoPicker.h"

@protocol ZYPhotoPickerDelegate<NSObject>

//拿到assets 可以用PhotoTool 获取原图
- (void)photoPickerFinishSelectedImages:(NSArray *)aseets;

@end

@interface ZYPhotoPickerController : UINavigationController


@property(nonatomic,assign) id<ZYPhotoPickerDelegate> pickDelegate;


/**
   获取资源类型
   default is ZYPhotoPickMediaTypeDefault
 */
@property(nonatomic,assign) ZYPhotoPickMediaType mediaType;
/**
 是否多选
 */
@property(nonatomic,assign) BOOL allowsMultipleSelection;
/**
 最大选择图片数量
 */
@property(nonatomic,assign) NSInteger maximumNumberOfSelection;

/**
 是否显示底部的tool
 */
@property(nonatomic,assign) BOOL showToolView;

/**
 选择的资源
 */
@property(nonatomic,strong) NSMutableArray *selectedAssets;


@end
