//
//  ZYPhotoPickController.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/4.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoCollectionController.h"
#import "ZYPhotoTool.h"
#import "ZYPhotoCollectionCell.h"
#import "ZYPhotoAlbumController.h"
#import "ZYPhotoPickerController.h"
#import "ZYPhotoPickToolView.h"
#import "ZYPhotoBrowser.h"
@interface ZYPhotoCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZYPhotoBrowserDelegate,PHPhotoLibraryChangeObserver>{
    CGRect _previousRect;
    CGSize _thumbnailSize;
    NSIndexPath *_lastSelectIndexPath;
}

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) PHCachingImageManager *imageManager;

@property(nonatomic,weak) ZYPhotoPickerController *picker;

@property(nonatomic,strong) ZYPhotoPickToolView *pickToolView;


@end

static NSString *const cellId = @"photoCellId";

@implementation ZYPhotoCollectionController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.picker = (ZYPhotoPickerController *)self.navigationController;
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self setUpUI];
    
     [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}



- (void)setFetchResult:(PHFetchResult *)fetchResult{
    _fetchResult = fetchResult;
    [self resetCache];
    [self.collectionView reloadData];
    [self updateCachedAssets];
}

#pragma mark - UI
- (void)setUpUI{
    
    self.navigationItem.title = NSLocalizedString(@"Photos", nil);
    NSString *title = NSLocalizedString(@"取消", nil);
    if (!self.picker.showToolView) {
        title = NSLocalizedString(@"完成", nil);
    }
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 44)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat itemWidth = (CGRectGetWidth(self.view.frame) - 12)/4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0 ,0);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 0;
    _thumbnailSize = CGSizeMake(itemWidth * scale, itemWidth * scale);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[ZYPhotoCollectionCell class] forCellWithReuseIdentifier:cellId];
    
    if (!self.picker.showToolView) return;
    
    _pickToolView = [[ZYPhotoPickToolView alloc] init];
    __weak typeof(self) wself = self;
    _pickToolView.toolViewBlock = ^(ZYPhotoPickBtnType btnType) {
        if (btnType == ZYPhotoPickBtnTypePrevious) {
            [wself previousSelectImage];
        }else{
            [wself doneButtonAction];
        }
    };
    _pickToolView.count = self.picker.selectedAssets.count;
    [self.view addSubview:_pickToolView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat toolViewHeight = 44;
    _collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    if (self.picker.showToolView) {
        self.pickToolView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - toolViewHeight, CGRectGetWidth(self.view.frame), toolViewHeight);
        CGRect bounds = _collectionView.bounds;
        bounds.size.height = CGRectGetHeight(self.view.frame) - toolViewHeight - 44;
        _collectionView.bounds = bounds;
    }
}


#pragma mark - Event
- (void)cancelBtnAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)previousSelectImage{
    NSInteger index = [self.fetchResult indexOfObject:self.picker.selectedAssets[0]];
    ZYPhotoCollectionCell *cell = (ZYPhotoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [ZYPhotoBrowser photoBroswerShowWithIndex:0 startView:cell.photoImgV presentVc:self photoBrowserDelegate:self];
}

- (void)doneButtonAction{
    if (self.picker.pickDelegate && [self.picker.pickDelegate respondsToSelector:@selector(photoPickerFinishSelectedImages:)]) {
        [self.picker.pickDelegate photoPickerFinishSelectedImages:[self.picker.selectedAssets copy]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelBtnAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消", nil)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self doneButtonAction];
    }
    
}

#pragma mark - PhotoBrowser Delegate
- (NSInteger)countOfImages{
    return self.picker.selectedAssets.count;
}

- (NSArray *)photoBrowserAssets{
    return self.picker.selectedAssets;
}

- (NSArray *)photoBrowserImages{
    
    return @[];
    
}

- (NSArray *)photoBrowserImageUrls{
    
    return @[];
    
}

- (UIView *)getStartViewWithIndex:(NSInteger)index{
    NSInteger collectionIndex = [self.fetchResult indexOfObject:self.picker.selectedAssets[index]];
    ZYPhotoCollectionCell *cell = (ZYPhotoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:collectionIndex inSection:0]];
    return cell.photoImgV;
}

#pragma mark - collectionView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateCachedAssets];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    PHAsset *asset = self.fetchResult[indexPath.row];
    [self.imageManager requestImageForAsset:asset targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.thumnailImg = result;
    }];
    if ([self.picker.selectedAssets containsObject:asset]) {
        [cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.picker.selectedAssets.count >= self.picker.maximumNumberOfSelection) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_lastSelectIndexPath && (!self.picker.allowsMultipleSelection || self.picker.maximumNumberOfSelection == 1) && self.picker.selectedAssets.count > 0) {
        [self.picker.selectedAssets removeObjectAtIndex:0];
        [collectionView deselectItemAtIndexPath:_lastSelectIndexPath animated:YES];
    }
    
    PHAsset *asset = self.fetchResult[indexPath.row];
    [self.picker.selectedAssets addObject:asset];
    self.pickToolView.count = self.picker.selectedAssets.count;
    _lastSelectIndexPath = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.fetchResult[indexPath.row];
    [self.picker.selectedAssets removeObject:asset];
    self.pickToolView.count = self.picker.selectedAssets.count;
}

#pragma mark - PHCachingImageManager Cache
- (void)resetCache{
    [self.imageManager stopCachingImagesForAllAssets];
    _previousRect = CGRectZero;
}

- (void)updateCachedAssets{
    CGRect visibleRect = CGRectMake(_collectionView.contentOffset.x, _collectionView.contentOffset.y, CGRectGetWidth(_collectionView.frame), CGRectGetHeight(_collectionView.frame));
    CGRect preheatRect = CGRectInset(visibleRect, 0, -.5*visibleRect.size.height);
    
    CGFloat delta = fabs(CGRectGetMidY(preheatRect) - CGRectGetMidY(_previousRect));
    if (delta < CGRectGetHeight(_collectionView.frame) / 3) {
        return;
    }
    
    [self computeDifferenceBetweenRect:_previousRect andRect:preheatRect removedHandler:^(NSArray *removedRect) {
        
        NSArray *removeAssets = [self indexPathRowWithRects:removedRect];
        
        [self.imageManager stopCachingImagesForAssets:removeAssets targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFill options:nil];
        
    } addedHandler:^(NSArray *addedRect) {
        NSArray *removeAssets = [self indexPathRowWithRects:addedRect];
        [self.imageManager startCachingImagesForAssets:removeAssets targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFill options:nil];
    }];
    
    _previousRect = preheatRect;
}

- (NSArray *)indexPathRowWithRects:(NSArray *)rects{
    
    NSMutableArray *assets = [NSMutableArray array];
    
    [rects enumerateObjectsUsingBlock:^(NSValue *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *indexPaths = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:[obj CGRectValue]];
        [indexPaths enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSInteger index = obj.indexPath.row;
            if (index < self.fetchResult.count) {
                [assets addObject:self.fetchResult[obj.indexPath.row]];
            }
        }];
    }];
    
    return [assets copy];
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(NSArray *removedRect))removedHandler addedHandler:(void (^)(NSArray *addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        NSMutableArray *addRects = [NSMutableArray array];
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            [addRects addObject:[NSValue valueWithCGRect:rectToAdd]];
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            [addRects addObject:[NSValue valueWithCGRect:rectToAdd]];
        }
        
        NSMutableArray *removeRects = [NSMutableArray array];
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            [removeRects addObject:[NSValue valueWithCGRect:rectToRemove]];
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            [removeRects addObject:[NSValue valueWithCGRect:rectToRemove]];
        }
        
        addedHandler(addRects);
        removedHandler(removeRects);
        
    } else {
        addedHandler(@[[NSValue valueWithCGRect:newRect]]);
        removedHandler(@[[NSValue valueWithCGRect:oldRect]]);
    }
}

#pragma mark - 相册改变
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResultChangeDetails *change = [changeInstance changeDetailsForFetchResult:self.fetchResult];
        if (change.fetchResultAfterChanges) {
            self.fetchResult = change.fetchResultAfterChanges;
        }
        if (change.hasIncrementalChanges) {
            
            @try{
                
                [self.collectionView performBatchUpdates:^{
                    NSIndexSet *set = [change insertedIndexes];
                    NSIndexSet *remove = [change removedIndexes];
                    
                    if (set.count) {
                        NSArray *indexs = [self inedxsWithIndexSet:set];
                        
                        [indexs enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        }];
                        
                        [self.collectionView insertItemsAtIndexPaths:indexs];
                    }
                    if (remove.count) {
                        NSArray *removes = [self inedxsWithIndexSet:remove];
                        [removes enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([self.picker.selectedAssets containsObject:self.fetchResult[obj.item]]) {
                                [self.picker.selectedAssets removeObject:self.fetchResult[obj.item]];
                            }
                        }];
                        self.pickToolView.count = self.picker.selectedAssets.count;
                        [self.collectionView deleteItemsAtIndexPaths:removes];
                    }
                } completion:^(BOOL finished) {
                    
                }];
            }
            @catch (NSException *exception) {
                [self.collectionView reloadData];
            }
        }else{
            
        }
        
        [self resetCache];
    });
    
}

- (NSArray *)inedxsWithIndexSet:(NSIndexSet *)set{
    NSMutableArray *indexs = [NSMutableArray arrayWithCapacity:set.count];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx+1 inSection:0];
        [indexs addObject:indexPath];
    }];
    
    return [indexs copy];
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
