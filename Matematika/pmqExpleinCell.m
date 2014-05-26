//
//  pmqExpleinCell.m
//  Matematika
//
//  Created by Jan Damek on 25.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqExpleinCell.h"

@interface pmqExpleinCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lab;

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
