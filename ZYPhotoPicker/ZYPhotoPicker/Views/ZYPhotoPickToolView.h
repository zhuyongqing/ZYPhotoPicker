//
//  ZYPhotoPickToolView.h
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/5.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZYPhotoPickBtnType) {
    ZYPhotoPickBtnTypePrevious,
    ZYPhotoPickBtnTypeDone,
};

typedef void(^ZYPhotoToolViewBlock)(ZYPhotoPickBtnType);

@interface ZYPhotoPickToolView : UIView

@property(nonatomic,assign) NSInteger count;

@property(nonatomic,copy) ZYPhotoToolViewBlock toolViewBlock;


@end
