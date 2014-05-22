//
//  Lessons.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Intros, Tests;

@interface Lessons : NSManagedObject

@property (nonatomic, retain) NSNumber * lesson_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * demo;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *relationship_intro;
@property (nonatomic, retain) NSSet *relationship_test;
@end

@interface Lessons (CoreDataGeneratedAccessors)

- (void)addRelationship_introObject:(Intros *)value;
- (void)removeRelationship_introObject:(Intros *)value;
- (void)addRelationship_intro:(NSSet *)values;
- (void)removeRelationship_intro:(NSSet *)values;

- (void)addRelationship_testObject:(Tests *)value;
- (void)removeRelationship_testObject:(Tests *)value;
- (void)addRelationship_test:(NSSet *)values;
- (void)removeRelationship_test:(NSSet *)values;

@end
