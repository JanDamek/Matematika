//
//  pmqResultViewController.m
//  Matematika
//
//  Created by Jan Damek on 01.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqResultViewController.h"
#import "pmqResultCell.h"
#import "pmqAppDelegate.h"
#import "pmqResultInfoViewController.h"

@interface pmqResultViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, readonly) NSFetchedResultsController *results;

@end

@implementation pmqResultViewController

@synthesize tableView = _tableView;
@synthesize results = _results;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property getters and setters

-(NSFetchedResultsController *)results{
    if (!_results) {
        pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
        _results = d.data.results;
    }
    return _results;
}

#pragma mark - UITableViewDelegate, UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.results sections][section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    pmqResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.rowNumber = indexPath.row;
    
    Results *r = [self.results objectAtIndexPath:indexPath];
    
    cell.lessonName.text = r.relationship_test.relationship_lesson.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:r.date];
    
    cell.dateOfTest.text = convertedString;
    cell.testOk.text = [NSString stringWithFormat:@"%i", [r.bad_answers intValue]];
    cell.testCount.text = [NSString stringWithFormat:@"%i", [r.relationship_test.test_length intValue]];
    
    [dateFormatter setDateFormat:@"hh:mm"];// here set format which you want...
    int min = [r.total_time floatValue] / 60;
    int sec = [r.total_time floatValue] - (min*60);
    cell.testTime.text = [NSString stringWithFormat:@"%02i:%02i", min, sec];
    if ([r.bad_answers intValue]>0){
        [cell.btnTest setHidden:NO];
    } else [cell.btnTest setHidden:YES];
    
    return cell;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"resultInfo"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         
         Results *object = [[self results] objectAtIndexPath:indexPath];
         [(pmqResultInfoViewController*)[segue destinationViewController] setDataResult:object];
     }
 }


@end
