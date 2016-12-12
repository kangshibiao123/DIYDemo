//
//  DIYViewControler.h
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/9.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface DiyImageView : UIImageView
/** */
@property (strong, nonatomic) NSDictionary  *dictionary;
@property (assign, nonatomic) NSInteger box_id;


@end

@interface DIYViewControler : UIViewController

@end
