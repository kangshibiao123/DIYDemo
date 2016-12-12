//
//  ItemsView.h
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/9.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsView : UIView<UITableViewDataSource,UITableViewDelegate>

/** */
@property (strong, nonatomic) UITableView *myTableView;

/** */
@property (strong, nonatomic) NSArray *subDataArray;

@property (copy, nonatomic) void (^mainData)(id NSData);

/**
 *
 */
@property (assign, nonatomic) NSInteger mainIdx;

/** */
@property (strong, nonatomic) NSMutableArray *bigArray;


- (void)showMoveItemsView;
@end

