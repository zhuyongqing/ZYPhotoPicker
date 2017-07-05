//
//  ZYPhotoPickerController.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/5.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoPickerController.h"
#import "ZYPhotoCollectionController.h"
#import "ZYPhotoAlbumController.h"
#import "ZYPhotoTool.h"
@interface ZYPhotoPickerController ()

@property(nonatomic,strong) ZYPhotoCollectionController *photo;


@end

@implementation ZYPhotoPickerController

- (instancetype)init{
    ZYPhotoAlbumController *album = [[ZYPhotoAlbumController alloc] init];
    if (self = [super initWithRootViewController:album]) {
        _photo = [[ZYPhotoCollectionController alloc] init];
        [self pushViewController:_photo animated:NO];
    }
    return self;
}

- (void)setMediaType:(ZYPhotoPickMediaType)mediaType{
    [ZYPhotoTool shareTool].mediaType = mediaType;
    [[ZYPhotoTool shareTool] getAllFetchResults:^(PHFetchResult *fetchResult) {
        _photo.fetchResult = fetchResult;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.barTintColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
