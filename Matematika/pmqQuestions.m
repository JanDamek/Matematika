//
//  pmgQuestions.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqQuestions.h"

@interface pmqQuestions()

@property (readonly, nonatomic, getter = getPOC) NSMutableArray* pos_of_char;
@property (readonly, nonatomic, getter = getAnswers) NSMutableArray* answers;

@end

@implementation pmqQuestions

@synthesize q = _q;
@synthesize pos_of_char = _pos_of_char;
@synthesize answers = _answers;
@synthesize corect_answer = _corect_answer;

#pragma mark - public methods for work with question

- (NSString*) position_char :(int)index{
    if (index>=0 && index<[self.pos_of_char count]){
        return [_pos_of_char objectAtIndex:index];
    } else return @"";
}

- (NSArray*) answer_posibilitys{
    NSMutableArray *r = [[NSMutableArray alloc] init];
    for (int i=0; i<6; i++) {
        if (i<[self.answers count]){
            [r addObject:[_answers objectAtIndex:i]];
        } else [r addObject:@""];
    }
    return r;
}

#pragma mark - getters for property

-(NSArray *)getPOC{
    if (!_pos_of_char) {
        [self doParseContent];
    }
    return _pos_of_char;
}

-(NSArray *)getAnswers{
    if (!_answers){
        [self doParseContent];
    }
    return _answers;
}

-(NSString *)getCorrect{
    if (!_corect_answer){
        [self doParseContent];
    }
    return  _corect_answer;
}

#pragma mark - parse question content

-(void) doParseContent{
    NSMutableArray *allAnswer = [NSMutableArray arrayWithArray:[_q.content componentsSeparatedByString:@" "]];
    _pos_of_char = [[NSMutableArray alloc]init];
    _answers = [[NSMutableArray alloc]init];
    bool inAnswer = false;
    for (NSString *answer in allAnswer) {
        if (!inAnswer){
            if ([answer hasPrefix:@"[...]"]){
                inAnswer = true;
            }else{
                [_pos_of_char addObject:answer];
            }
        } else{
            if ([answer hasPrefix:@"*"]){
                _corect_answer = [answer substringFromIndex:1];
            } else
                [_answers addObject:answer];
        }
    }
    
}


@end
