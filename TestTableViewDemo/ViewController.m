//
//  ViewController.m
//  TestTableViewDemo
//
//  Created by wanghuiguang on 2018/10/19.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

#import "ViewController.h"
#import "NewViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UITableView *tableViewLeft;
@property (nonatomic, strong) UICollectionView *collectionViewRight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickToNextController) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击进入双向tableView中" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(@50);
        make.width.equalTo(@230);
    }];
}

- (void)clickToNextController
{
    UIViewController *vc = [NewViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
