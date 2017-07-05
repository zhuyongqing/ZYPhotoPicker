//
//  ViewController.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/4.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ViewController.h"
#import "ZYPhotoPickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectBtn setTitle:@"photo" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectPhotos) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    [selectBtn sizeToFit];
    [selectBtn setFrame:CGRectMake(0, 0, CGRectGetWidth(selectBtn.frame), CGRectGetHeight(selectBtn.frame))];
    selectBtn.center = CGPointMake(self.view.center.x, CGRectGetHeight(self.view.frame) - 50);
}

- (void)selectPhotos{
    ZYPhotoPickerController *picker = [[ZYPhotoPickerController alloc] init];
    picker.mediaType = ZYPhotoPickMediaTypePhoto;
    picker.allowsMultipleSelection = YES;
    picker.maximumNumberOfSelection = 9;
    picker.showToolView = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
