//
//  Results.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Questions, Tests;

@interface Results : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Tests *relationship_test;
@property (nonatomic, retain) NSSet *relationship_questions;
@end

@interface Results (CoreDataGeneratedAccessors)

- (void)addRelationship_questionsObject:(Questions *)value;
- (void)removeRelationship_questionsObject:(Questions *)value;
- (void)addRelationship_questions:(NSSet *)values;
- (void)removeRelationship_questions:(NSSet *)values;

@end
