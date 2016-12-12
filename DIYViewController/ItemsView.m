//
//  ItemsView.m
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/9.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import "ItemsView.h"
#import "DidMenuCell.h"
@implementation ItemsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        [self addSubview:self.myTableView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStyleGrouped];
        _myTableView.dataSource = self;
        _myTableView.delegate   = self;
        _myTableView.separatorColor = [UIColor clearColor];
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DidMenuCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DidMenuCell class])];
        _myTableView.backgroundColor = [UIColor clearColor];
    }
    return _myTableView;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_mainIdx == 0) {
        return self.subDataArray.count;
    }else if (_mainIdx == 1){
        NSArray * sml = self.bigArray[section][@"items"];
        id data = self.bigArray[section];
        if ([data[@"isFlog"] intValue] == 0) {
            return 0;
        }
        else{
            return  [sml count];
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_mainIdx == 0) {
        return 1;
    }else if (_mainIdx == 1){
        return self.bigArray.count;
    }
    return self.subDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DidMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DidMenuCell class]) forIndexPath:indexPath];
    if (_mainIdx == 0) {
        cell.data = self.subDataArray[indexPath.row];

    }else{
        cell.data =self.bigArray[indexPath.section][@"items"][indexPath.row];
    }
    cell.selectionStyle = UITableViewCellStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.subDataArray) {
        if (self.mainIdx == 0) {
            [self addBigArrayData:self.subDataArray[indexPath.row]];
            self.mainIdx = 1;
            self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 60, [UIScreen mainScreen].bounds.size.height);
            [self showMoveItemsView];
        }else if (self.mainIdx == 1){
            if (self.mainData) {
                self.mainData(self.bigArray[indexPath.section][@"items"][indexPath.row]);
            }
            /**
             "box_id" = 23152;
             "button_img" = "vm/8b/be/c6/8bbec628eca9c5afd8e7e6ae7e882830.png";
             hasproduct = 0;
             img = "vm/d4/6b/c8/d46bc8bfb26cc0d0220483416946fd3a.png";
             "model_id" = 1174;

             */
        }
       
        [self.myTableView reloadData];

    }
}

- (void)addBigArrayData:(id)data{
    self.bigArray = [NSMutableArray array];
    NSArray * array = data[@"factorys"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:obj];
        [dic setObject:@(0) forKey:@"isFlog"];
        [self.bigArray addObject:dic];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_mainIdx == 0) {
        return 0.1;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_mainIdx == 0) {
        return nil;;
    }
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIButton * itemsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemsButton addTarget:self action:@selector(itemsButton:) forControlEvents:UIControlEventTouchUpInside];
    itemsButton.frame = CGRectMake(10, 10, 40, 40);
    itemsButton.backgroundColor = [UIColor grayColor];
    id data= self.bigArray [section];
    [itemsButton setTitle:data[@"factory_name"] forState:UIControlStateNormal];
    [itemsButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    itemsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    itemsButton.titleLabel.numberOfLines = 0;
    [itemsButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [itemsButton.layer setBorderWidth:2];
    [itemsButton.layer setCornerRadius:8];
    itemsButton.tag = section;
    [view addSubview:itemsButton];
    return view;
}

- (void)showMoveItemsView{
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 60, [UIScreen mainScreen].bounds.size.height );
    }];
}

- (void)itemsButton:(UIButton *)sender{
    NSMutableDictionary * data= self.bigArray[sender.tag];
    NSArray *array = data[@"items"];
    NSMutableArray * indexPathArray =[NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPathArray addObject:[NSIndexPath indexPathForRow:idx inSection:sender.tag]];
    }];
    if ([data[@"isFlog"] intValue] == 0) {
        [data setValue:@(1) forKey:@"isFlog"];
        [self.myTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];

    }else{
        [data setValue:@(0) forKey:@"isFlog"];
        [self.myTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
