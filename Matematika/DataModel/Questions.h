//
//  Questions.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Questions : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic) int16_t welcome_sound;
@property (nonatomic, retain) NSOrderedSet *relationship_answer;
@property (nonatomic, retain) NSManagedObject *relationship_result;
@property (nonatomic, retain) NSManagedObject *relationship_test;
@end

@interface Questions (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inRelationship_answerAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelationship_answerAtIndex:(NSUInteger)idx;
- (void)insertRelationship_answer:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelationship_answerAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelationship_answerAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceRelationship_answerAtIndexes:(NSIndexSet *)indexes withRelationship_answer:(NSArray *)values;
- (void)addRelationship_answerObject:(NSManagedObject *)value;
- (void)removeRelationship_answerObject:(NSManagedObject *)value;
- (void)addRelationship_answer:(NSOrderedSet *)values;
- (void)removeRelationship_answer:(NSOrderedSet *)values;
@end
