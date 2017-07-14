# ZYPhotoPicker
基于Photokit的照片选择器
##使用
把ZYPhotoPicker加到项目中,需要预览ZYPhotoBrowser的也加进去,最好到我的主页下载最新的ZYPhotoBrowser

```obj-c
ZYPhotoPickerController *picker = [[ZYPhotoPickerController alloc] init];
picker.mediaType = ZYPhotoPickMediaTypeDefault;
picker.allowsMultipleSelection = YES;
picker.maximumNumberOfSelection = 9;
picker.showToolView = YES;
picker.pickDelegate = self;
[self presentViewController:picker animated:YES completion:nil];
```
支持多选,最大选择图片数量,还有底部的预览的toolView,可以控制show,返回选择图片的代理

```obj-c
//拿到assets 可以用PhotoTool 获取原图
- (void)photoPickerFinishSelectedImages:(NSArray *)aseets;
```
返回的是一个PHAsset的数组可以通过ZYPhotoTool里的方法获取原图

```obj-c
- (void)getOriginImageWithLocaIdentifier:(NSString *)identifier withImage:(void(^)(UIImage *,NSURL *))imageBlock;

- (void)loadOriginImageWithAsset:(PHAsset *)asset image:(void(^)(UIImage *))getImg;

```
有两个获取原图的方法,第一个是获取和屏幕成比例的图,第二个是获取最大尺寸的图片
