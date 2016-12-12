//
//  KSRequestManager.m
//  HSH
//
//  Created by kangshibiao on 16/6/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "KSRequestManager.h"
@implementation KSRequestManager

+ (void)postRequestWithUrlString:(NSString *)url
                       parameter:(id)parameter
                         success:(void (^)(id responseObject))success
                         failure:(void (^) (NSError *error))failure{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];

    [manager POST:[NSString stringWithFormat:@"%@",url] parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}
/**
 * @param get 请求
 *
 * @param url       请求地址的url
 * @param parameter 请求参数
 * @return success   请求成功
 * @return failure   失败
 */
+ (void)gitRequestWithUrlString:(NSString *)url
                      parameter:(id)parameter
                        success:(void (^)(id responseObject))success
                        failure:(void (^) (NSError *error))failure{
    

//    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
//    
//    [manager GET:[NSString stringWithFormat:@"%@",url] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [JCProgressHUD showErrorWithStatus:FAILURE];
//        failure(error);
//    }];
}
/**
 * @param Pos 请求上传图片
 *
 * @param url       请求地址的url
 * @param parameter 请求参数
 * @param success   请求成功
 * @param failure   失败
 */
+ (void)upLodImageRequestWithUrlString:(NSString *)url
                             parameter:(id)parameter
                                images:(NSArray *)images
                               success:(void (^)(id responseObject))success
                               failure:(void (^) (NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_MANURL,url] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(UIImage  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, .2) name:@"upufdmfile" fileName:@"upufdmfile.jpeg" mimeType:@"image/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id head = KSDIC(responseObject, @"head");
        if ([KSDIC(head, @"respCode") isEqualToString:@"0000000"]) {
            //成功
            success(KSDIC(responseObject, @"body"));
        }else{
            //失败
            failure (head);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

@end
