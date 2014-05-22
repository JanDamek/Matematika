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

@property (nonatomic) int16_t time;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) Questions *relationship_question;

@end
