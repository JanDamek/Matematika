//
//  pmqMasterViewController.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pmqDetailLesonsViewController;

#import <CoreData/CoreData.h>

@interface pmqLessonsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) pmqDetailLesonsViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
