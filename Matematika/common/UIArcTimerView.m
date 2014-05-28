//
//  UIArcTimerView.m
//  Matematika
//
//  Created by Jan Damek on 28.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "UIArcTimerView.h"

@interface UIArcTimerView () {
    CGFloat startAngle;
    CGFloat endAngle;
}

@end

@implementation UIArcTimerView

@synthesize percent = _percent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Display our percentage as a string
    NSString* textContent = [NSString stringWithFormat:@"%d", self.percent];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:130
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    
    // Set the display for the path, and stroke it
    bezierPath.lineWidth = 20;
    [[UIColor redColor] setStroke];
    [bezierPath stroke];
    
    // Text Drawing
    CGRect textRect = CGRectMake((rect.size.width / 2.0) - 71/2.0, (rect.size.height / 2.0) - 45/2.0, 71, 45);
    [[UIColor blackColor] setFill];
   
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 42.5], NSParagraphStyleAttributeName: paragraphStyle }];
}

@end
