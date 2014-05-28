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
#import "LastResults.h"

@interface pmqTestingViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) Tests *data;

@end
