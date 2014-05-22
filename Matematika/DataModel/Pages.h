//
//  Pages.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Intros;

@interface Pages : NSManagedObject

@property (nonatomic) int16_t fixed;
@property (nonatomic, retain) NSString * content;
@property (nonatomic) int16_t order;
@property (nonatomic, retain) Intros *relationship_intro;

@end
