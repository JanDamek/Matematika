//
//  Answers.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Questions;

@interface Answers : NSManagedObject

@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Questions *relationship_question;

@end
