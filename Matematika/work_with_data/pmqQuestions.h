//
//  pmgQuestions.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "Questions.h"

@interface pmqQuestions : NSObject

@property (readonly, nonatomic, getter = getCorrect) NSString* corect_answer;
@property (retain, nonatomic) Questions *q;

- (NSString*) position_char :(int)index;
- (NSArray*) answer_posibilitys;

@end
