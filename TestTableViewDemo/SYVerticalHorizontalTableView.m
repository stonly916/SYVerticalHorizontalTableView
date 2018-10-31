//
//  SYVerticalHorizontalTableView.m
//  TestTableViewDemo
//
//  Created by wanghuiguang on 2018/10/23.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

#import "SYVerticalHorizontalTableView.h"

#define Default_LeftContentWidth_Multiplied (1/3.f)
#define Default_RightContentWidth_Multiplied (1.f)

@interface UIScrollView(SYSerDraggin)
@property (nonatomic, assign) BOOL syDragging;
@end
@implementation UIScrollView(SYSerDraggin)
@dynamic syDragging;

-(void)setSyDragging:(BOOL)syDragging
{
    objc_setAssociatedObject(self, _cmd, @(syDragging), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)syDragging
{
    return [objc_getAssociatedObject(self, @selector(setSyDragging:)) boolValue];
}

@end

@interface SYVerticalHorizontalTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableLeft;
@property (nonatomic, strong) UIScrollView *scrollRight;
@property (nonatomic, strong) UITableView *tableRight;

@end

@implementation SYVerticalHorizontalTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (instancetype)initWithLeftContentWidth:(CGFloat)leftWidth rightContentWidth:(CGFloat)rightWidth
{
    if (self = [super init]) {
        _leftContentWidth = leftWidth;
        _rightContentWidth = rightWidth;
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    self.alwaysBounceVertical = YES;
    self.alwaysBounceHorizontal = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    //设置代理为自身
    [super setDelegate:self];
    //默认同时触发左右cell点击
    self.synClickCell = YES;
    
    [self addSubview:self.tableLeft];
    [self addSubview:self.scrollRight];
    [self.scrollRight addSubview:self.tableRight];
    [self makeViewConstraints];
    
}

#pragma mark - 代替tableView的方法

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [self.tableLeft dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [self.tableRight dequeueReusableCellWithIdentifier:identifier];
    }
    return cell;
}

-(NSInteger)numberOfSections
{
    return self.tableLeft.numberOfSections;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.tableLeft numberOfRowsInSection:section];
}

-(void)reloadData
{
    [self.tableLeft reloadData];
    [self.tableRight reloadData];
}

- (void)selectRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition positon:SYVerticalHorizontalCellNormal];
}

-(void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition positon:(SYVerticalHorizontalCellPosition)position
{
    switch (position) {
        case SYVerticalHorizontalCellNormal:
        {
            [self.tableLeft selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
            [self.tableRight selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
        }
            break;
        case SYVerticalHorizontalCellLeft:
            [self.tableLeft selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
            break;
        case SYVerticalHorizontalCellRight:
            [self.tableRight selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
            break;
        default:
            break;
    }
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [self deselectRowAtIndexPath:indexPath animated:animated positon:SYVerticalHorizontalCellNormal];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated positon:(SYVerticalHorizontalCellPosition)position
{
    switch (position) {
        case SYVerticalHorizontalCellNormal:
        {
            [self.tableLeft deselectRowAtIndexPath:indexPath animated:animated];
            [self.tableRight deselectRowAtIndexPath:indexPath animated:animated];
        }
            break;
        case SYVerticalHorizontalCellLeft:
            [self.tableLeft deselectRowAtIndexPath:indexPath animated:animated];
            break;
        case SYVerticalHorizontalCellRight:
            [self.tableRight deselectRowAtIndexPath:indexPath animated:animated];
            break;
        default:
            break;
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [self.tableLeft scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.syDataSource && [self.syDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.syDataSource numberOfSectionsInTableView:self];
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.syDataSource && [self.syDataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.syDataSource tableView:self numberOfRowsInSection:section];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.syDataSource && [self.syDataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:position:)]) {
        if (tableView == self.tableLeft) {
            cell = [self.syDataSource tableView:self cellForRowAtIndexPath:indexPath position:SYVerticalHorizontalCellLeft];
        } else if (tableView == self.tableRight) {
            cell = [self.syDataSource tableView:self cellForRowAtIndexPath:indexPath position:SYVerticalHorizontalCellRight];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.syDelegate tableView:self heightForRowAtIndexPath:indexPath];
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.syDelegate tableView:self heightForHeaderInSection:section];
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.syDelegate tableView:self heightForFooterInSection:section];
    }
    return 0.001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:position:)]) {
        if (tableView == self.tableLeft) {
            view = [self.syDelegate tableView:self viewForHeaderInSection:section position:SYVerticalHorizontalCellLeft];
        } else if (tableView == self.tableRight) {
            view = [self.syDelegate tableView:self viewForHeaderInSection:section position:SYVerticalHorizontalCellRight];
        }
    }
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:position:)]) {
        if (tableView == self.tableLeft) {
            view = [self.syDelegate tableView:self viewForFooterInSection:section position:SYVerticalHorizontalCellLeft];
        } else if (tableView == self.tableRight) {
            view = [self.syDelegate tableView:self viewForFooterInSection:section position:SYVerticalHorizontalCellRight];
        }
    }
    return view;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *aIndexPath = indexPath;
    if (self.synClickCell) {
        if (tableView == self.tableLeft) {
            [self.tableRight selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else if (tableView == self.tableRight) {
            [self.tableLeft selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:position:)]) {
        if (self.synClickCell) {
            aIndexPath = [self.syDelegate tableView:self willSelectRowAtIndexPath:indexPath position:SYVerticalHorizontalCellNormal];
        } else if (tableView == self.tableLeft) {
            aIndexPath = [self.syDelegate tableView:self willSelectRowAtIndexPath:indexPath position:SYVerticalHorizontalCellLeft];
        } else if (tableView == self.tableRight) {
            aIndexPath = [self.syDelegate tableView:self willSelectRowAtIndexPath:indexPath position:SYVerticalHorizontalCellRight];
        }
    }
    return aIndexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *aIndexPath = indexPath;
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:position:)]) {
        if (self.synClickCell) {
            aIndexPath = [self.syDelegate tableView:self willSelectRowAtIndexPath:indexPath position:SYVerticalHorizontalCellNormal];
        } else if (tableView == self.tableLeft) {
            aIndexPath = [self.syDelegate tableView:self willSelectRowAtIndexPath:indexPath position:SYVerticalHorizontalCellLeft];
        } else if (tableView == self.tableRight) {
            aIndexPath = [self.syDelegate tableView:self willSelectRowAtIndexPath:indexPath position:SYVerticalHorizontalCellRight];
        }
    }
    return aIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYVerticalHorizontalCellPosition position = SYVerticalHorizontalCellNormal;
    if (self.synClickCell) {
        position = SYVerticalHorizontalCellNormal;
    }else if (tableView == self.tableLeft) {
        position = SYVerticalHorizontalCellLeft;
    } else if (tableView == self.tableRight) {
        position = SYVerticalHorizontalCellRight;
    }
    
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:position:)]) {
        [self.syDelegate tableView:self didSelectRowAtIndexPath:indexPath position:position];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYVerticalHorizontalCellPosition position = SYVerticalHorizontalCellNormal;
    if (self.synClickCell) {
        if (tableView == self.tableLeft) {
            [self.tableRight deselectRowAtIndexPath:indexPath animated:YES];
        } else if (tableView == self.tableRight) {
            [self.tableRight deselectRowAtIndexPath:indexPath animated:YES];
        }
    }else if (tableView == self.tableLeft) {
        position = SYVerticalHorizontalCellLeft;
    } else if (tableView == self.tableRight) {
        position = SYVerticalHorizontalCellRight;
    }
    
    if (self.syDelegate && [self.syDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:position:)]) {
        [self.syDelegate tableView:self didDeselectRowAtIndexPath:indexPath position:position];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)sy_scrollViewDidScroll:(UIScrollView *)scrollView
{
    //一次滑动过程中，不能既触发上边界又触发下边界
    CGPoint leftOffset = self.tableLeft.contentOffset;
    if (leftOffset.y == 0) {
        if (self.tableLeft.contentSize.height > self.bounds.size.height && self.contentOffset.y > 0) {
            self.contentOffset = CGPointMake(0, 0);
        }
    } else {
        if (self.tableLeft.contentSize.height > self.bounds.size.height && self.contentOffset.y < 0) {
            self.contentOffset = CGPointMake(0, 0);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self) {   //自身滑动
        [self sy_scrollViewDidScroll:scrollView];
        return;
    }
    
    if (scrollView == self.tableLeft || scrollView == self.tableRight) {
        CGPoint offset =  scrollView.contentOffset;
        //手动触发最外层scrollView的滚动
        if ((offset.y < 0 || self.contentOffset.y < 0) && self.isTracking) {
            scrollView.contentOffset = CGPointMake(offset.x, 0);
            
            CGPoint point = self.contentOffset;
            //模拟正常tableView速度
            CGFloat y = offset.y/pow((fabs(point.y) + 1.0), 9./40) + point.y;
            [self setContentOffset:CGPointMake(point.x, y) animated:NO];
            return;
        } else if ((offset.y+scrollView.bounds.size.height > scrollView.contentSize.height ||  self.contentOffset.y > 0)  && self.isTracking) {
            scrollView.contentOffset = CGPointMake(offset.x, scrollView.contentSize.height - scrollView.bounds.size.height);
            
            CGFloat lagOffset = offset.y + scrollView.bounds.size.height - scrollView.contentSize.height;
            CGPoint point = self.contentOffset;
            //模拟正常tableView速度
            CGFloat y = lagOffset/pow((fabs(point.y) + 1.0), 9./40) + point.y;
            [self setContentOffset:CGPointMake(point.x, y) animated:NO];
            return;
        }
        
        //tableView左右联动
        if (scrollView == self.tableLeft && !self.tableRight.syDragging) {
            scrollView.syDragging = YES;
            self.tableRight.contentOffset = offset;
        } else if (scrollView == self.tableRight && !self.tableLeft.syDragging){
            scrollView.syDragging = YES;
            self.tableLeft.contentOffset = offset;
        }
    } else if (scrollView == self.scrollRight) {
        CGPoint offset =  scrollView.contentOffset;
        if (offset.x < 0) { //右tableView向左滑动
            scrollView.contentOffset = CGPointMake(0, offset.y);
        } else {
            CGFloat offsetWidth = (self.leftContentWidth + self.rightContentWidth) - self.bounds.size.width;
            if (offset.x > offsetWidth) {   //右tableView向右滑动
                scrollView.contentOffset = CGPointMake(offsetWidth, offset.y);
            }
            if (offset.y>0 | offset.y<0) {  //右tableView左右滑动时不能触发上下滑动
                scrollView.contentOffset = CGPointMake(offset.x, 0);
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        //拖动彻底停止，没有减速滑动
        self.tableLeft.syDragging = NO;
        self.tableRight.syDragging = NO;
        self.scrollRight.syDragging = NO;
    }
    //需要手动弹回边界
    if (scrollView == self.tableLeft || scrollView == self.tableRight) {
        CGPoint offset =  self.contentOffset;
        [self animateWithOffset:offset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //减速滑动停止
    self.tableLeft.syDragging = NO;
    self.tableRight.syDragging = NO;
    self.scrollRight.syDragging = NO;
}

#pragma mark - 模拟减速动画
//如果与当前所用刷新不兼容，请在子类重写
- (void)animateWithOffset:(CGPoint)offset
{
    if (offset.y < 0) {
//            [self scrollRectToVisible:CGRectMake(0, self.contentSize.height - 1, 1, 1) animated:YES];
        //某些刷新三方库需要这行来触发
        self.contentOffset = CGPointMake(offset.x, offset.y+0.1);
        [UIView animateWithDuration:0.26 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint offset = self.contentOffset;
            offset.y = -self.contentInset.top;
            self.contentOffset = offset;
        } completion:nil];
    } else if (offset.y > 0) {
//            [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        //某些刷新三方库需要这行来触发
        self.contentOffset = CGPointMake(offset.x, offset.y-0.1);
        [UIView animateWithDuration:0.26 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint offset = self.contentOffset;
            offset.y = self.contentInset.bottom;
            self.contentOffset = offset;
        } completion:nil];
    }
}

#pragma mark - ViewConstraints
- (void)makeViewConstraints
{
    [self.tableLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(Default_LeftContentWidth_Multiplied);
        make.height.equalTo(self);
    }];
    [self.scrollRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.tableLeft.mas_right);
        make.width.equalTo(self.mas_width).multipliedBy(1.-Default_LeftContentWidth_Multiplied);
        make.height.equalTo(self.tableLeft);
    }];

    [self.tableRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollRight);
        make.width.equalTo(self.mas_width).multipliedBy(Default_RightContentWidth_Multiplied);
        make.height.equalTo(self.tableLeft);
    }];
}

- (void)updateViewWidthConstraints
{
    [self.tableLeft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.leftContentWidth);
    }];
    
    [self.scrollRight mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.bounds.size.width > self.leftContentWidth) {
            make.width.mas_equalTo(self.bounds.size.width - self.leftContentWidth);
        } else {
            make.width.mas_equalTo(0.01);
        }
    }];
    
    [self.tableRight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.rightContentWidth);
    }];
}

-(void)layoutSubviews
{
    if (_leftContentWidth > 0 || _rightContentWidth > 0) {
        [self updateViewWidthConstraints];
    } else {
        _leftContentWidth = self.tableLeft.bounds.size.width;
        _rightContentWidth = self.tableRight.bounds.size.width;
    }
    [super layoutSubviews];
}

#pragma mark - views

- (UITableView *)tableLeft
{
    if (_tableLeft) {
        return _tableLeft;
    }
    
    _tableLeft = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableLeft.delegate = self;
    _tableLeft.dataSource = self;
    _tableLeft.tableFooterView = [UIView new];
    _tableLeft.showsVerticalScrollIndicator = NO;
    _tableLeft.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    return _tableLeft;
}

- (UITableView *)tableRight
{
    if (_tableRight) {
        return _tableRight;
    }
    
    _tableRight = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableRight.delegate = self;
    _tableRight.dataSource = self;
    _tableRight.tableFooterView = [UIView new];
    _tableRight.showsVerticalScrollIndicator = NO;
    _tableRight.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return _tableRight;
}

- (UIScrollView *)scrollRight
{
    if (_scrollRight) {
        return _scrollRight;
    }
    
    _scrollRight = [[UIScrollView alloc] init];
    _scrollRight.directionalLockEnabled = YES;
    _scrollRight.delegate = self;
    _scrollRight.showsHorizontalScrollIndicator = NO;
    _scrollRight.alwaysBounceVertical = YES;
    return _scrollRight;
}

#pragma mark - dragging、tracking、decelerating等

- (BOOL)isDragging
{
    BOOL result = [super isDragging];
    return self.tableLeft.syDragging | self.tableRight.syDragging | self.scrollRight.syDragging | result;
}

- (BOOL)isTracking
{
    BOOL result = [super isTracking];
    return self.tableLeft.isTracking | self.tableRight.isTracking | self.scrollRight.isTracking | result;
}

- (BOOL)isDecelerating
{
    BOOL result = [super isDecelerating];
    return self.tableLeft.isDecelerating | self.tableRight.isDecelerating | self.scrollRight.isDecelerating | result;
}


@end
