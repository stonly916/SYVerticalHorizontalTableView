//
//  SYVerticalHorizontalTableView.h
//  TestTableViewDemo
//
//  Created by wanghuiguang on 2018/10/23.
//  Copyright © 2018年 wanghuiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SYVerticalHorizontalCellPosition) {
    SYVerticalHorizontalCellNormal = -1,    //左右两个cell算做一个cell
    SYVerticalHorizontalCellLeft,           //左cell
    SYVerticalHorizontalCellRight,          //右cell
};

@class SYVerticalHorizontalTableView;
@protocol SYVerticalHorizontalTableDataSource <NSObject>
@required
- (NSInteger)tableView:(SYVerticalHorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(SYVerticalHorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath position:(SYVerticalHorizontalCellPosition)position;

@optional
- (NSInteger)numberOfSectionsInTableView:(SYVerticalHorizontalTableView *)tableView;
- (void)tableView:(SYVerticalHorizontalTableView *)tableView titleForHeaderInSection:(NSInteger)section setTitle:(void(^)(NSString *leftTitle, NSString *rightTitle))setTitles;
- (void)tableView:(SYVerticalHorizontalTableView *)tableView titleForFooterInSection:(NSInteger)section setTitle:(void(^)(NSString *leftTitle, NSString *rightTitle))setTitles;
@end

@protocol SYVerticalHorizontalTableDelegate <UIScrollViewDelegate>
@optional
-(CGFloat)tableView:(SYVerticalHorizontalTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(SYVerticalHorizontalTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(SYVerticalHorizontalTableView *)tableView heightForFooterInSection:(NSInteger)section;
- (nullable UIView *)tableView:(SYVerticalHorizontalTableView *)tableView viewForHeaderInSection:(NSInteger)section position:(SYVerticalHorizontalCellPosition)position;
- (nullable UIView *)tableView:(SYVerticalHorizontalTableView *)tableView viewForFooterInSection:(NSInteger)section position:(SYVerticalHorizontalCellPosition)position;
- (nullable NSIndexPath *)tableView:(SYVerticalHorizontalTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath position:(SYVerticalHorizontalCellPosition)position;
- (nullable NSIndexPath *)tableView:(SYVerticalHorizontalTableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath position:(SYVerticalHorizontalCellPosition)position;
- (void)tableView:(SYVerticalHorizontalTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath position:(SYVerticalHorizontalCellPosition)position;
- (void)tableView:(SYVerticalHorizontalTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath position:(SYVerticalHorizontalCellPosition)position;
@end

#pragma mark -

@interface SYVerticalHorizontalTableView : UIScrollView

@property (nonatomic, assign) CGFloat leftContentWidth;
@property (nonatomic, assign) CGFloat rightContentWidth;
@property (nonatomic, nullable, weak) id <SYVerticalHorizontalTableDelegate> syDelegate;
@property (nonatomic, nullable, weak) id <SYVerticalHorizontalTableDataSource> syDataSource;

@property (nonatomic, assign) BOOL synClickCell;    //默认YES，左右同步点击

- (instancetype)initWithLeftContentWidth:(CGFloat)leftWidth rightContentWidth:(CGFloat)rightWidth;

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@property (nonatomic, readonly) NSInteger numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (void)reloadData;

- (void)selectRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)selectRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition positon:(SYVerticalHorizontalCellPosition)position;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated positon:(SYVerticalHorizontalCellPosition)position;
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end
