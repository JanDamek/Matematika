//
//  Tests.h
//  Matematika
//
//  Created by Jan Damek on 03.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lessons, Questions, Results;

@interface Tests : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * test_length;
@property (nonatomic, retain) NSNumber * time_limit;
@property (nonatomic, retain) NSString * welcome_sound;
@property (nonatomic, retain) Lessons *relationship_lesson;
@property (nonatomic, retain) Results *relationship_results;
@property (nonatomic, retain) NSSet *relationship_question;
@end

@interface Tests (CoreDataGeneratedAccessors)

- (void)addRelationship_questionObject:(Questions *)value;
- (void)removeRelationship_questionObject:(Questions *)value;
- (void)addRelationship_question:(NSSet *)values;
- (void)removeRelationship_question:(NSSet *)values;

@end
