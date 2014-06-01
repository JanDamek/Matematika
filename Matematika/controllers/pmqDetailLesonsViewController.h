//
//  pmqDetailViewController.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pmqDetailLesonsViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UINavigationItem *label;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

-(void)performProcvicovani;

@end
