//
//  CoreDataManager.h
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/9.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "EntityModel.h"
#import "EntityModel.h"
@interface CoreDataManager : NSObject
+ (instancetype)sharedCoreDataManager;

- (void)instertModel:(NSString *)name imageData:(NSData *)data;

- (NSDictionary  *)queryManagerGetData:(NSString *)urlString;
@end
