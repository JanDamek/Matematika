//
//  Tests.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lessons, Questions, Results;

@interface Tests : NSManagedObject

@property (nonatomic, retain) NSNumber * time_limit;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * welcome_sound;
@property (nonatomic, retain) Lessons *relationship_lesson;
@property (nonatomic, retain) NSSet *relationship_results;
@property (nonatomic, retain) NSSet *relationship_question;
@end

@interface Tests (CoreDataGeneratedAccessors)

- (void)addRelationship_resultsObject:(Results *)value;
- (void)removeRelationship_resultsObject:(Results *)value;
- (void)addRelationship_results:(NSSet *)values;
- (void)removeRelationship_results:(NSSet *)values;

- (void)addRelationship_questionObject:(Questions *)value;
- (void)removeRelationship_questionObject:(Questions *)value;
- (void)addRelationship_question:(NSSet *)values;
- (void)removeRelationship_question:(NSSet *)values;

@end
