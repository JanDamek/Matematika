//
//  Intros.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Intros : NSManagedObject

@property (nonatomic) int16_t order;
@property (nonatomic, retain) NSManagedObject *relationship_lesson;
@property (nonatomic, retain) NSManagedObject *relationship_pages;

@end
