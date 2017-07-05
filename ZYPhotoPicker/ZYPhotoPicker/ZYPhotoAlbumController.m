//
//  ZYPhotoAlbumController.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/5.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoAlbumController.h"
#import "ZYPhotoCollectionController.h"
#import "ZYPhotoTool.h"
#import "ZYAlbumInfoModel.h"
#import "ZYAlbumTableCell.h"


@interface ZYPhotoAlbumController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *albums;

@property(nonatomic,strong) NSMutableArray *albumInfos;


@end

static NSString *const cellId  = @"albumCellId";

@implementation ZYPhotoAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpUI];
    
    [self getDataSource];
}

- (void)getDataSource{
    
    [[ZYPhotoTool shareTool] getAllCollectionsWithSize:CGSizeMake(60, 60) withAlbumInfo:^(ZYAlbumInfoModel *infoModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.albumInfos addObject:infoModel];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albumInfos indexOfObject:infoModel] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}

#pragma mark - UI
- (void)setUpUI{
    
    self.navigationItem.title = NSLocalizedString(@"相册", nil);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 44)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ZYAlbumTableCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - Event
- (void)cancelBtnAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView Delegate DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYAlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    ZYAlbumInfoModel *model = self.albumInfos[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYPhotoCollectionController *photoCollection = [[ZYPhotoCollectionController alloc] init];
    ZYAlbumInfoModel *model = self.albumInfos[indexPath.row];
    photoCollection.fetchResult = model.fetchResult;
    [self.navigationController pushViewController:photoCollection animated:YES];
}


- (NSMutableArray *)albumInfos{
    if (!_albumInfos) {
        _albumInfos = [NSMutableArray array];
    }
    return _albumInfos;
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
