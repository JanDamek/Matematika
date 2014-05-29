//
//  UIArcTimerView.h
//  Matematika
//
//  Created by Jan Damek on 28.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIArcTimerView;

@protocol UIArcTimerViewDelegate

-(void)terminatedTimer:(UIArcTimerView*)timerView;

@end

@interface UIArcTimerView : UIView

@property int percent;

@property int timeToCount;
@property int timeLeft;

@property (nonatomic, strong) UIColor *roundColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *textColor;

@property id<UIArcTimerViewDelegate> delegate;

-(void)stopTimer;
-(void)startTimer;
-(void)startTimer:(int)timeToCount;

@end
