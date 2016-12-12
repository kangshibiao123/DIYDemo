//
//  KSRequestManager.h
//  HSH
//
//  Created by kangshibiao on 16/6/14.
//  Copyright © 2016年 Mac. All rights reserved.
//
#define  URL_MANURL @"http://139.224.18.4:8080/ljj"
#define KSDIC(dic,valuer) [dic objectForKey:valuer]==[NSNull null]?@"":[dic objectForKey:valuer]


#define FAILURE @"网络连接失败！"

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
//#import "JCProgressHUD.h"
@interface KSRequestManager : NSObject
/**
 * @param Post 请求
 *
 * @param url       请求地址的url
 * @param parameter 请求参数
 * @param success   请求成功
 * @param failure   失败
 */
+ (void)postRequestWithUrlString:(NSString *)url
                       parameter:(id)parameter
                         success:(void (^)(id responseObject))success
                         failure:(void (^) (NSError *error))failure;
/**
 * @param get 请求
 *
 * @param url       请求地址的url
 * @param parameter 请求参数
 * @param success   请求成功
 * @param failure   失败
 */
+ (void)gitRequestWithUrlString:(NSString *)url
                       parameter:(id)parameter
                         success:(void (^)(id responseObject))success
                         failure:(void (^) (NSError *error))failure;
/**
 * @param Post 请求上传图片
 *
 * @param url       请求地址的url
 * @param parameter 请求参数
 * @param success   请求成功
 * @param images    图片数组
 * @param failure   失败
 */
+ (void)upLodImageRequestWithUrlString:(NSString *)url
                      parameter:(id)parameter
                         images:(NSArray *)images
                        success:(void (^)(id responseObject))success
                        failure:(void (^) (NSError *error))failure;

@end
