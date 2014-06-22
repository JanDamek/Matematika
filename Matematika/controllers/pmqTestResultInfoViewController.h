//
//  pmqTestResultInfoViewController.h
//  Matematika
//
//  Created by Jan Damek on 05.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Results.h"
#import <AVFoundation/AVFoundation.h>

@interface pmqTestResultInfoViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) Results *result;

@end
