//
//  pmgQuestions.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqQuestions.h"

@interface pmqQuestions()

@end

@implementation pmqQuestions

@synthesize q = _q;
@synthesize answers = _answers;
@synthesize corect_answer = _corect_answer;
@synthesize fistPartQuestion = _fistPartQuestion;
@synthesize secondPartQuestion = _secondPartQuestion;


#pragma mark - getters for property


-(void)setQ:(Questions *)q{
    _q = q;
    [self doParseContent];
}

#pragma mark - parse question content

-(void) doParseContent{
    NSString *s = [_q.content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    NSArray * question = [s componentsSeparatedByString:@"[...]"];
    s = [[question objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    NSArray *q = [s componentsSeparatedByString:@"[?]"];
    _fistPartQuestion = [q objectAtIndex:0];
    _secondPartQuestion = [q objectAtIndex:1];
    s = [[question objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    _answers = [s componentsSeparatedByString:@" "];
    for (NSString *s in _answers) {
        if ([s hasPrefix:@"*"]) {
            _corect_answer = [s substringFromIndex:1];
        }
    }
}


@end
