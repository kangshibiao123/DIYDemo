//
//  MainViewController.m
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/9.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import "MainViewController.h"
#import "DIYViewControler.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)additional:(id)sender{
    
    DIYViewControler * div =[DIYViewControler new];
    
    [self.navigationController pushViewController:div animated:YES];
}


@end
