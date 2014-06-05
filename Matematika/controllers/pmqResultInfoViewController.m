//
//  pmqResultInfoViewController.m
//  Matematika
//
//  Created by Jan Damek on 05.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqResultInfoViewController.h"
#import "Tests.h"
#import "Lessons.h"
#import "Questions.h"
#import "pmqQuestions.h"
#import "pmqResultQuestionCell.h"

@interface pmqResultInfoViewController (){
    NSArray *questions;
    NSMutableArray *pmqQ;
}

@property (weak, nonatomic) IBOutlet UIButton *btnVysledkyTestu;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UILabel *lblDatum;
@property (weak, nonatomic) IBOutlet UILabel *lblLekce;
@property (weak, nonatomic) IBOutlet UILabel *lblPocetChyb;
@property (weak, nonatomic) IBOutlet UILabel *lblCelkovyCas;

@property (weak, nonatomic) IBOutlet UICollectionView *colPriklady;

@end

@implementation pmqResultInfoViewController

@synthesize dataResult = _dataResult;

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
    [self setViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setViews{
    self.lblLekce.text = _dataResult.relationship_test.relationship_lesson.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];// here set format which you want...
    NSString *convertedString = [dateFormatter stringFromDate:_dataResult.date];
    
    self.lblDatum.text = convertedString;
    self.lblPocetChyb.text = [NSString stringWithFormat:NSLocalizedString(@"%i (pocet prikladu %i)",nil), [_dataResult.bad_answers intValue], [_dataResult.relationship_test.test_length intValue]];
    
    [dateFormatter setDateFormat:@"hh:mm"];// here set format which you want...
    int min = [_dataResult.total_time floatValue] / 60;
    int sec = [_dataResult.total_time floatValue] - (min*60);
    self.lblCelkovyCas.text = [NSString stringWithFormat:@"%02i:%02i", min, sec];
    
    [self.colPriklady reloadData];
}

#pragma mark - propertys

-(void)setDataResult:(Results *)dataResult{
    _dataResult = dataResult;
    questions = [_dataResult.relationship_questions allObjects];
    pmqQ = [[NSMutableArray alloc] initWithCapacity:[questions count]];
    
    for (Questions *q in questions) {
        pmqQuestions *pmq = [[pmqQuestions alloc] init];
        pmq.q = q;
        [pmqQ addObject:pmq];
    }
}

#pragma mark - Navigation

-(IBAction)btnBackAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnVysledkyTestuAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnRetryAction:(id)sender{
    
}

-(IBAction)btnNextAction:(id)sender{
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [questions count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pmqResultQuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"resultCell" forIndexPath:indexPath];
    
    Questions *q = [questions objectAtIndex:indexPath.row];
    
    pmqQuestions *pmq = [pmqQ objectAtIndex:indexPath.row];
    
    if ([q.time_of_answer intValue] == [_dataResult.relationship_test.time_limit intValue]){
        [cell.timeOut setHidden:NO];
    } else [cell.timeOut setHidden:YES];
    
    UIColor *answerColor;
    if ([q.last_answer boolValue]) {
        answerColor = [UIColor whiteColor];
    } else answerColor = [UIColor redColor];
    
    cell.question.textColor = answerColor;
    cell.progress.tintColor = answerColor;
    cell.time.tintColor = answerColor;
    
    cell.question.text = pmq.resultQuestion;
    
    cell.progress.progress = [q.time_of_answer floatValue] / [_dataResult.relationship_test.time_limit floatValue];
    
    cell.time.text = [NSString stringWithFormat:@"%.2f s", [q.time_of_answer floatValue] ];
    
    return cell;
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
