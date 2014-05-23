//
//  LastResults.h
//  Matematika
//
//  Created by Jan Damek on 23.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Results, Tests;

@interface LastResults : NSManagedObject

@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) NSDate * stop_date;
@property (nonatomic, retain) Tests *relationship_test;
@property (nonatomic, retain) Results *relationship_result;

@end
