//
//  EntityModel+CoreDataProperties.h
//  
//
//  Created by kangshibiao on 2016/12/9.
//
//

#import "EntityModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface EntityModel (CoreDataProperties)

+ (NSFetchRequest<EntityModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
