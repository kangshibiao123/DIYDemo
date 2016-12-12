//
//  EntityModel+CoreDataProperties.m
//  
//
//  Created by kangshibiao on 2016/12/9.
//
//

#import "EntityModel+CoreDataProperties.h"

@implementation EntityModel (CoreDataProperties)

+ (NSFetchRequest<EntityModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EntityModel"];
}

@dynamic imageData;
@dynamic imageName;

@end
