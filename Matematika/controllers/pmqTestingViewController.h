//
//  pmqTestingViewController.h
//  Matematika
//
//  Created by Jan Damek on 27.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tests.h"
#import "Questions.h"
#import "Results.h"
#import "UIArcTimerView.h"
#import <AVFoundation/AVFoundation.h>

enum TestMode {
    tmNone, tmTest, tmTestOnTime, tmTestFails, tmTestOverAll, tmTestOverAllFail
};

@interface pmqTestingViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIArcTimerViewDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) Tests *data;
@property enum TestMode testMode;

@end