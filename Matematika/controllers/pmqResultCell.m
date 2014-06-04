//
//  pmqResultCell.m
//  Matematika
//
//  Created by Jan Damek on 04.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqResultCell.h"

@interface pmqResultCell(){

    int _rowNumber;
}

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end

@implementation pmqResultCell

@synthesize lessonName = _lessonName;
@synthesize bgImage = _bgImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - methods

-(int)rowNumber{
    return _rowNumber;
}

-(void)setRowNumber:(int)rowNumber{
    if (rowNumber % 2){
        _bgImage.image = [UIImage imageNamed:@"bg_list2_even.9.png"];
    }else{
        _bgImage.image = [UIImage imageNamed:@"bg_list2_odd.9.png"];
    }
    _rowNumber = rowNumber;
}

@end
