//
//  pmqMasterViewController.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pmqDetailViewController;

#import <CoreData/CoreData.h>

@interface pmqMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) pmqDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
