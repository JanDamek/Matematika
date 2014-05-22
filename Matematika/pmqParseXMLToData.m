//
//  pmgParseXMLToData.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqParseXMLToData.h"
#import "pmqAppDelegate.h"
#import "XMLReader.h"
#import "Lessons.h"
#import "pmqData.h"

@interface pmqParseXMLToData()

@property (readonly, strong, getter = getD) pmqData *d;

@end

@implementation pmqParseXMLToData

@synthesize d = _d;

-(pmqData*)getD{
    if (!_d){
        pmqAppDelegate *delegate = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
        _d = delegate.data;
    }
    return _d;
}

-(void)doParse{
    NSString *filePath = [ [ NSBundle mainBundle ] pathForResource: @"game_definition" ofType: @"xml" ];
    NSString *xml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *in_data = [[XMLReader dictionaryForXMLString:xml error:NULL] valueForKey:@"PMQcalculations"];

    
    for (NSDictionary *i in [in_data valueForKey:@"lesson"]) {
        
        int lesson_id = [[i valueForKey:@"id"] intValue] ;
        Lessons *l = [self.d newLessons];
        l.lesson_id = [NSNumber numberWithInt:lesson_id];
        l.demo = [NSNumber numberWithInt:[[i valueForKey:@"demo"] intValue]];
        l.name = [i valueForKey:@"name"];
        
        Intros *intros = [self.d newIntros];
        [l addRelationship_introObject:intros];
        NSDictionary *intr = [i valueForKey:@"intro"];
        for (NSDictionary *page in [intr valueForKey:@"page"]) {
            Pages *p = [self.d newPages];
            [intros addRelationship_pagesObject:p];

            p.fixed = [NSNumber numberWithInt:[[page valueForKey:@"fixed"] intValue]];
            p.content = [page valueForKey:@"text"];
            [self.d savePages];
        }
        [self.d saveIntros];
        
        Tests *test = [self.d newTests];
        [l addRelationship_testObject:test];
        NSDictionary *te = [i valueForKey:@"test"];
        test.time_limit = [NSNumber numberWithInt:[[te valueForKey:@"timeLimit"] intValue]];
        test.welcome_sound = [te valueForKey:@"welcomeSound"];
        for (NSDictionary *question in [te valueForKey:@"question"]) {
            Questions *q = [self.d newQuestions];
            [test addRelationship_questionObject:q];
            
            q.content = [question valueForKey:@"text"];
            [self.d saveQuestions];
        }
        [self.d saveTests];
    }
    [self.d saveLessons];
    
}

@end
