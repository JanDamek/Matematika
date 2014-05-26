//
//  pmqPages.m
//  Matematika
//
//  Created by Jan Damek on 26.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqPages.h"

@interface pmqPages(){
    int _numOfColumns;
    NSMutableArray *_charAtPos;
}
@end

@implementation pmqPages

@synthesize data = _data;

-(void)setData:(Pages *)data{
    _data = data;
    [self prepareData];
}

-(int)numOfColumns{
    return _numOfColumns;
}

-(NSString*)charAtPos:(int)pos{
    if (pos<[_charAtPos count]){
        return [_charAtPos objectAtIndex:pos];
    } else return @"";
}

-(int)numOfItems{
    return [_charAtPos count];
}

-(void)prepareData{
    if ([_data.type isEqualToString:@"html"]) {
        _numOfColumns = 1;
        _charAtPos = [[NSMutableArray alloc]init];
        [_charAtPos addObject:_data.content];
    }else{
        _numOfColumns = -1;
        NSArray *ch = [_data.content componentsSeparatedByString:@" "];
        _charAtPos = [[NSMutableArray alloc]init];
        for (NSString *s in ch) {
            NSString *item = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            item = [item stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
            if (![item isEqualToString:@"\n"] && ![item isEqualToString:@""]){
                NSArray *ni = [item componentsSeparatedByString:@"\n"];
                for (NSString *ss in ni) {
                    [_charAtPos addObject:ss];
                    if (_numOfColumns==-1) {
                        if ([ss rangeOfString:@":" options:NSCaseInsensitiveSearch].location!=NSNotFound){
                            _numOfColumns = [_charAtPos count]-1;
                        }}
                }
            }
        }
    }
}

@end
