//
//  NewViewController.m
//  TestTableViewDemo
//
//  Created by wanghuiguang on 2018/10/22.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

#import "NewViewController.h"
#import "SYVerticalHorizontalTableView.h"

@interface NewViewController ()<SYVerticalHorizontalTableDataSource, SYVerticalHorizontalTableDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SYVerticalHorizontalTableView *tableView;

@property (nonatomic, assign) NSInteger dataNumbers;
@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataNumbers = 35;
    [self makeConstraints];
    
    [self setRefresh];
}

#pragma mark - UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(SYVerticalHorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataNumbers;
}

- (NSInteger)numberOfSectionsInTableView:(SYVerticalHorizontalTableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(SYVerticalHorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath position:(SYVerticalHorizontalCellPosition)position
{
    if (position == SYVerticalHorizontalCellLeft) {
        UITableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
        if (nil == leftCell) {
            leftCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellId"];
        }
        leftCell.textLabel.text = @"左边";
        return leftCell;
    } else {
        UITableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellRightId"];
        if (nil == rightCell) {
            rightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellId"];
        }
        rightCell.textLabel.text = @"右边可以左右滑动safasfsdfsdf哈啦鱼第三方";
        return rightCell;
    }
}

-(CGFloat)tableView:(SYVerticalHorizontalTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(SYVerticalHorizontalTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath position:(SYVerticalHorizontalCellPosition)position
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES positon:position];
}


#pragma mark -
- (void)makeConstraints
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setRefresh
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header beginRefreshing];
        NSLog(@"头部刷新开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            self.dataNumbers = 35;
            [self.tableView reloadData];
            NSLog(@"头部刷新结束");
        });
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        NSLog(@"尾部刷新开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.dataNumbers < 50) {
                self.dataNumbers = 50;
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            NSLog(@"尾部刷新结束");
        });
    }];
    [footer setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载更多" forState:MJRefreshStateWillRefresh];
    self.tableView.mj_footer = footer;
}

- (SYVerticalHorizontalTableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    _tableView = [[SYVerticalHorizontalTableView alloc] initWithLeftContentWidth:ScreenWidth/3. rightContentWidth:ScreenWidth];
    _tableView.syDelegate = self;
    _tableView.syDataSource = self;
    return _tableView;
}

@end
