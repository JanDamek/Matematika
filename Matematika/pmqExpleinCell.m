//
//  pmqExpleinCell.m
//  Matematika
//
//  Created by Jan Damek on 25.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqExpleinCell.h"

@interface pmqExpleinCell()

@end

@implementation pmqExpleinCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)highlite{
    [self setBackgroundColor:[UIColor whiteColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
