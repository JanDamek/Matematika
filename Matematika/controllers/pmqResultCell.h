//
//  pmqResultCell.h
//  Matematika
//
//  Created by Jan Damek on 04.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqLessonTableViewCell.h"

@interface pmqResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lessonName;
@property int rowNumber;

@end
