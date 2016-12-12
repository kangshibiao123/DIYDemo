//
//  CoreDataManager.m
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/9.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import "CoreDataManager.h"

@import CoreData;
@implementation CoreDataManager
{
    NSManagedObjectModel *_model;
    NSManagedObjectContext *_context;
    NSPersistentStoreCoordinator* _coordinator;

}

+ (instancetype)sharedCoreDataManager{
    static CoreDataManager *coreManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreManager = [[self alloc]init];
    });
    return coreManager;
}

- (instancetype)init{
    if (self = [super init]) {
        
        NSURL *momdURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc]initWithContentsOfURL:momdURL];
        _coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];
        NSURL* SQLiteURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Test.sqlite"];
        //创建或者打开一个数据库。
        if ([_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:SQLiteURL options:nil error:nil]) {
            //成功，继续执行。
            
            //创建存储数据的容器对象。
            _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            
            //从数据库读取数据，转为 MO 对象，放入容器中。
            [_context setPersistentStoreCoordinator:_coordinator];
        }else {
            //失败，退出程序。
            exit(0);
        }

    }
    return self;
}

- (void)instertModel:(NSString *)name imageData:(NSData *)data{
    EntityModel * model = [NSEntityDescription insertNewObjectForEntityForName:@"EntityModel" inManagedObjectContext:_context];
    model.imageName = name;
    model.imageData = data;
    [_context save:nil];
}

- (NSArray*)selectImage:(NSString*)imageUrl {
    if (imageUrl == nil||[imageUrl isEqualToString:@""]) {
        return @[];
    }
    // 查询类，需要知道实体和托管上下文，我们可以设置谓词以过滤查询
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"EntityModel" inManagedObjectContext:_context];
    [request setEntity:entityDescription];
    //这个 @"190000" 要换成当前的用户名
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageName like %@", imageUrl];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:request error:&error];
    if (array && error == nil) {
        return array;
    }
    return nil;
}

- (NSArray* )selectedAll {
    //创建查询请求。
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"People"];
    
    //容器执行查询请求。
    return [_context executeFetchRequest:request error:nil];
}

- ( NSDictionary *)queryManagerGetData:(NSString *)urlString{
    
    NSArray  *array = [self selectImage:urlString];
    
    if (array.count>0) {
        EntityModel * model = array[0];
        
        return @{@"imageName":model.imageName,@"imageData":model.imageData};
        
    }else{
        return nil;
    }
    
    //    KOUserModel *model = [KOUserModel shareKOUserModel];
    
    return nil;
}

@end
