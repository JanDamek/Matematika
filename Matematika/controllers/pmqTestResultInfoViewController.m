//
//  pmqTestResultInfoViewController.m
//  Matematika
//
//  Created by Jan Damek on 05.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqTestResultInfoViewController.h"
#import "pmqResultInfoViewController.h"

@interface pmqTestResultInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UIImageView *starsResult;
@property (weak, nonatomic) IBOutlet UILabel *badAnswer;
@property (weak, nonatomic) IBOutlet UILabel *totalQuestion;
@property (weak, nonatomic) IBOutlet UILabel *inTime;
@property (weak, nonatomic) IBOutlet UILabel *labelResult;

@end

@implementation pmqTestResultInfoViewController

@synthesize result = _result;

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
    int r = [_result.rate intValue];

    
    self.starsResult.image = [UIImage imageNamed:[NSString stringWithFormat:@"status_%istar", r ]];
    self.resultImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"result_%i", r ]];
    
    NSString *s = [NSString stringWithFormat:@"result_%i", r ];
    self.labelResult.text = NSLocalizedString(s, nil);
    
    int min = [_result.total_time floatValue] / 60;
    int sec = [_result.total_time floatValue] - (min*60);
    self.inTime.text = [NSString stringWithFormat:@"%02i:%02i", min, sec];
    
    self.badAnswer.text = [_result.bad_answers stringValue];
    self.totalQuestion.text = [NSString stringWithFormat:@"%i", [_result.relationship_questions count]];
}

-(void)setResult:(Results *)result{
    _result = result;
    [self setViews];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"vysledekTestu"]) {
        [(pmqResultInfoViewController*)[segue destinationViewController] setDataResult:_result];
    }
}


@end
