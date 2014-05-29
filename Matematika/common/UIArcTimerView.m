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
@synthesize timeToCount = _timeToCount;
@synthesize timeLeft = _timeLeft;

@synthesize roundColor = _roundColor;
@synthesize fillColor = _fillColor;
@synthesize circleColor = _circleColor;

@synthesize delegate = _delegate;

-(void)maindeclare{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    // Determine our start and stop angles for the arc (in radians)
    startAngle = M_PI * 1.5;
    endAngle = startAngle + (M_PI * 2);
    
    _roundColor = [UIColor grayColor];
    _fillColor = [UIColor lightGrayColor];
    _circleColor = [UIColor blackColor];
    _textColor = [UIColor blackColor];
    
    _timeLeft = 0;
    _timeToCount = 0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self maindeclare];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self maindeclare];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self maindeclare];
    }
    return self;
}

-(int)percent{
    return _percent;
}

-(void)setPercent:(int)percent{
    _percent = percent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    float size;
    if (rect.size.width > rect.size.height){
        size = rect.size.height;
    }else{
        size = rect.size.width;
    }
    float okraj = size * 0.05;
    
    // Display our percentage as a string
    NSString* textContent = [NSString stringWithFormat:@"%d", self.percent];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:size / 4 - (okraj/2)
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPath.lineWidth = size / 2 - okraj;
    [_fillColor setStroke];
    [bezierPath stroke];
    
    UIBezierPath* bezierPathSmall = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPathSmall addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:size/2 - okraj
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPathSmall.lineWidth = okraj;
    [_roundColor setStroke];
    [bezierPathSmall stroke];

    UIBezierPath* bezierPath1 = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPath1 addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                               radius:size/2 - (okraj/2)
                           startAngle:startAngle
                             endAngle:endAngle
                            clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPath1.lineWidth = 1;
    [_circleColor setStroke];
    [bezierPath1 stroke];

    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPath2 addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                           radius:size/2 - (okraj*1.5)
                       startAngle:startAngle
                         endAngle:endAngle
                        clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPath2.lineWidth = 1;
    [_circleColor setStroke];
    [bezierPath2 stroke];

    float fontSize = size / 3;
    float fontWith = fontSize * 1.6;
    // Text Drawing
    CGRect textRect = CGRectMake((rect.size.width / 2.0) - fontWith/2.0, (rect.size.height / 2.0) - fontSize/2.0, fontWith, fontSize);
    [_textColor setFill];
   
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: fontSize * 0.95], NSParagraphStyleAttributeName: paragraphStyle }];
}

@end
