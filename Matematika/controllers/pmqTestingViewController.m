//
//  pmqTestingViewController.m
//  Matematika
//
//  Created by Jan Damek on 27.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqTestingViewController.h"
#import "pmqQuestionMarkCell.h"
#import "Lessons.h"
#import "pmqAppDelegate.h"
#import "pmqQuestions.h"
#import "pmqTestResultInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface pmqTestingViewController (){
    
    float mark_size;
    
    NSMutableArray *_questions;
    
    int answered;
    
    AVAudioPlayer *_player;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *marks;
@property (strong, nonatomic) NSArray *q;

@property (weak, nonatomic) IBOutlet UIArcTimerView *timerView;
@property (weak, nonatomic) IBOutlet UIImageView *questionMark;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel1;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel2;
@property (weak, nonatomic) IBOutlet UILabel *labelAnswer;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UILabel *lblStart;

@end

@implementation pmqTestingViewController

@synthesize marks = _marks, q = _q;
@synthesize timerView = _timerView;
@synthesize answerButtons = _answerButtons;
@synthesize testMode = _testMode;
@synthesize labelAnswer = _labelAnswer;

#pragma mark - initialization

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    _timerView.delegate = self;
    mark_size = (_marks.frame.size.width - 120) / 12;
    
    self.btnStart.layer.cornerRadius = 10;
    
    for (UIButton *b in self.answerButtons) {
        b.layer.cornerRadius = 10;
    }
    
    UIImage *img = [UIImage imageNamed:@"timer_fg.png"];
    CGSize size = CGSizeMake(_timerView.frame.size.width,_timerView.frame.size.height);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _timerView.fillColor = [UIColor colorWithPatternImage:newimage];
    _timerView.roundColor = [UIColor darkGrayColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self prepareTest];
}

- (IBAction)btnStartAction:(id)sender {
    [self.lblStart setHidden:YES];
    [self.btnStart setHidden:YES];
    [_questionLabel1 setHidden:NO];
    [_questionLabel2 setHidden:NO];
    
    [self prepareTest];
    
    [self loadFromLastTest];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([_data.welcome_sound hasSuffix:@"mp3"]) {
        NSString *sounf_file = [[_data.welcome_sound lastPathComponent] stringByDeletingPathExtension];
        @try {
            sounf_file = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"lng", @"lng"),sounf_file];
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                 pathForResource:sounf_file
                                                 ofType:@"mp3"]];
            _player = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:url
                       error:nil];
            _player.delegate = self;
            [_player play];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(mark_size, mark_size);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property setters and gettrs

-(void)setData:(Tests *)data{
    _data = data;
    
    _q = [data.relationship_question allObjects];
    
    mark_size = (_marks.frame.size.width - 120) / [_data.test_length intValue];
}

-(enum TestMode)testMode{
    return _testMode;
}

-(void)setTestMode:(enum TestMode)testMode{
    answered = 0;
    [_marks reloadData];
    
    [self.lblStart setHidden:NO];
    [self.btnStart setHidden:NO];
    
    [self.questionLabel1 setHidden:YES];
    [self.timerView setHidden:YES];
    [self.questionLabel2 setHidden:YES];
    [self.questionMark setHidden:YES];
    [self.labelAnswer setHidden:YES];
    
    for (UIButton *b in self.answerButtons) {
        [b setHidden:YES];
        b.backgroundColor = [UIColor lightGrayColor];
    }
    
    _testMode = testMode;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_timerView invalidateTimer];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.data saveResults];
    [d.data saveTests];
}

#pragma mark - test methods

-(void)prepareQuestions:(NSMutableArray*)questions firstFail:(bool)firstFail{
    int count_question = 0;
    
    if ([questions count]<[_data.test_length intValue]) {
        _data.test_length = [NSNumber numberWithInteger:[questions count]];
    }
    
    int test_length = [_data.test_length intValue];
    if (test_length==0) {
        test_length = 12;
    }
    _questions = [[NSMutableArray alloc] init];
    
    if (firstFail){
        int index = 0;
        while ((index<[questions count]) && (count_question<test_length)){
            Questions *q = (Questions*)[questions objectAtIndex:index];
            if ([q.last_answer intValue]==0){
                count_question++;
                [_questions addObject:q];
                index--;
                [questions removeObject:q];
            }
            index++;
        }
    }
    
    while (count_question<test_length) {
        int div = RAND_MAX / [questions count];
        int index = rand() / div;
        Questions *q;
        if (index<[questions count]) {
            q = (Questions*)[questions objectAtIndex:index];
        } else q = nil;
        
        count_question++;
        if (q)
            [_questions addObject:q];
        [questions removeObject:q];
    }
}

-(void)loadFromLastTest{
    if (_questionLabel1){
        [_marks reloadData];
        
        pmqQuestions *pmqQ = [[pmqQuestions alloc]init];
        if (answered < [_questions count]){
            pmqQ.q = (Questions*)[_questions objectAtIndex:answered];
        } else pmqQ.q = (Questions*)[_questions objectAtIndex:answered - [_questions count]];
        
        
        _questionLabel1.text = pmqQ.fistPartQuestion;
        [_questionLabel1 sizeToFit];
        
        _questionLabel2.text = pmqQ.secondPartQuestion;
        [_questionLabel2 sizeToFit];
        
        CGRect s = _questionLabel2.frame;
        s.origin.y = _questionLabel1.frame.origin.y;
        
        if (_testMode == tmTest){
            [_questionMark setHidden:NO];
            [_timerView setHidden:YES];
            
            CGRect p = _questionMark.frame;
            p.origin.x = _questionLabel1.frame.origin.x + _questionLabel1.frame.size.width;
            p.origin.y = _questionLabel1.frame.origin.y - ((_questionMark.frame.size.height - _questionLabel1.frame.size.height)/2);
            _questionMark.frame=p;
            s.origin.x = _questionMark.frame.origin.x + _questionMark.frame.size.width;
        }else{
            [_questionMark setHidden:YES];
            [_timerView setHidden:NO];
            
            CGRect p = _timerView.frame;
            p.origin.x = _questionLabel1.frame.origin.x + _questionLabel1.frame.size.width;
            p.origin.y = _questionLabel1.frame.origin.y- ((_timerView.frame.size.height - _questionLabel1.frame.size.height)/2);
            _timerView.frame=p;
            s.origin.x = _timerView.frame.origin.x + _timerView.frame.size.width;
            [_timerView startTimer:[_data.time_limit intValue]];
        }
        _questionLabel2.frame=s;
        
        [_questionLabel1 setNeedsDisplay];
        [_questionLabel1 setHidden:NO];
        [_questionLabel2 setNeedsDisplay];
        [_questionLabel2 setHidden:NO];
        
        [_timerView setNeedsDisplay];
        [_questionMark setNeedsDisplay];
        
        int i=0;
        for (UIButton *b in _answerButtons) {
            if (i<[pmqQ.answers count]){
                NSString *s = [pmqQ.answers objectAtIndex:i];
                if ([s hasPrefix:@"*"]){
                    s = [s substringFromIndex:1];
                    b.tag = 1;
                } else b.tag = 0;
                [b setTitle:s forState:UIControlStateNormal];
                [b setHidden:NO];
                [b setEnabled:YES];
            } else {
                [b setHidden:YES];
                [b setEnabled:NO];
                [b setTitle:@"" forState:UIControlStateNormal];
                
            }
            i++;
        }
        
    }
    
}

-(void)prepareTest{
    answered = 0;
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    switch (_testMode) {
        case tmTest:
        case tmTestOnTime:
            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy] firstFail:NO];
            break;
            
        case tmTestFails:
            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy]firstFail:YES];
            break;
            
        case tmTestOverAll:
            [self prepareQuestions:[[d.data.questions fetchedObjects] mutableCopy] firstFail:NO];
            break;
            
        case tmTestOverAllFail:
            [self prepareQuestions:[[d.data.questions fetchedObjects] mutableCopy] firstFail:YES];
            break;
            
        default:
            break;
    }
}

-(void)markCorrect{
    //    [UIView beginAnimations:@"correct" context:nil];
    //
    //    [UIView setAnimationDuration:0.5];
    //    [UIView setAnimationDelegate:self];
    //    [UIView commitAnimations];
}

-(void)prepareNextQuestion{
    if (answered<[_data.test_length intValue]){
        [UIView beginAnimations:@"next" context:nil];
        
        [_labelAnswer setHidden:YES];
        for (UIButton *b in self.answerButtons) {
            b.backgroundColor = [UIColor lightGrayColor];
        }
        
        [self loadFromLastTest];
        
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }else{
        [self makeResult];
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([(NSString*)anim isEqualToString:@"answer"]){
        
        [self performSelector:@selector(markCorrect) withObject:nil afterDelay:0.2];
        
    } else if ( [(NSString*)anim isEqualToString:@"correct"] ){
        
        [self performSelector:@selector(prepareNextQuestion) withObject:nil afterDelay:1];
    }
}

-(void)animateAnswer:(UIButton*)button{
    
    [_marks reloadData];
    
    [UIView beginAnimations:@"answer" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    if (button.tag==1){
        button.backgroundColor = [UIColor greenColor];
    } else {
        button.backgroundColor = [UIColor redColor];
    }
    
    for (UIButton *b in self.answerButtons) {
        if (b.tag==1){
            b.backgroundColor = [UIColor greenColor];
            _labelAnswer.text = b.currentTitle;
            [_labelAnswer sizeToFit];
        }
        [b setEnabled:NO];
        if ([b isEqual:button] || b.tag==1) {
            [b setHidden:NO];
        } else [b setHidden:YES];
    }
    
    if (_testMode ==  tmTest) {
        [_questionMark setHidden:YES];
        [_labelAnswer setHidden:NO];
    }else{
        [_timerView setHidden:YES];
        [_labelAnswer setHidden:NO];
    }
    
    [UIView commitAnimations];
}

- (IBAction)answerButtonAction:(UIButton *)sender {
    
    [_timerView invalidateTimer];
    
    if (_testMode==tmTest){
        _labelAnswer.frame = _questionMark.frame;
    } else
        _labelAnswer.frame = _timerView.frame;
    
    //    if (_testMode != tmTest) {
    Questions *q = [_questions objectAtIndex:answered];
    q.last_answer = [NSNumber numberWithBool:sender.tag==1];
    float inTime = _timerView.timeToCount*(_timerView.percent/100);
    if (inTime==0) inTime = _timerView.timeToCount;
    q.time_of_answer = [NSNumber numberWithFloat:inTime];
    //    }
    answered++;
    
    NSString *sound_file;
    if (sender==nil){
        sound_file = @"snd_timeout";
    } else if (sender.tag==1){
        sound_file = @"snd_correct";
    } else sound_file = @"snd_failed";
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:sound_file
                                         ofType:@"mp3"]];
    _player = [[AVAudioPlayer alloc]
               initWithContentsOfURL:url
               error:nil];
    _player.delegate = self;
    [_player play];
    
    
    [self animateAnswer:sender];
}

-(void)makeResult{
    {
        if (_testMode==tmTest) {
            
            self.testMode = tmTestOnTime;
            //            [self prepareTest];
            //            [self loadFromLastTest];
        } else {
            
            pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
            Results *r = _data.relationship_results;
            if (!r && _data){
                r = [d.data newResults];
                _data.relationship_results = r;
            }
            NSArray *rq = [r.relationship_questions allObjects];
            for (Questions *q in rq) {
                [r removeRelationship_questionsObject:q];
            }
            float total_time = 0;
            int bad_answer = 0;
            for (int i=0; i<[_questions count]; i++) {
                Questions *q = [_questions objectAtIndex:i];
                total_time += [q.time_of_answer floatValue];
                if ([q.last_answer integerValue]==0){
                    bad_answer++;
                }
                [r addRelationship_questionsObject:q];
            }
            r.total_time = [NSNumber numberWithFloat:total_time];
            r.bad_answers = [NSNumber numberWithInt:bad_answer];
            r.date = [NSDate date];
            
            int test_length = [r.relationship_test.test_length intValue];
            float max_time = [r.relationship_test.time_limit intValue]*test_length;
            
            float rate =5 * ((float)test_length - (float)bad_answer)/(float)test_length;
            rate -= 2 * (total_time/max_time);
            rate = floorf(rate+0.49);
            
            r.rate = [NSNumber numberWithInt:(int)rate];
            
            r.relationship_test.relationship_lesson.rating = r.rate;
            
            [d.data saveLessons];
            [d.data saveResults];
            
            NSError *error =nil;
            [d.data.results performFetch:&error];
            NSAssert(!error, @"Error performing fetch request: %@", error);
            [d.data.lessons performFetch:&error];
            NSAssert(!error, @"Error performing fetch request: %@", error);
            
            UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TestResult"];
            [(pmqTestResultInfoViewController*)c setResult:r];
            [self.navigationController pushViewController:c animated:YES];
        }
    }
}

#pragma mark - collection delegate & dataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_data.test_length intValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pmqQuestionMarkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"otazkaTest" forIndexPath:indexPath];
    
    if (indexPath.row<answered) {
        Questions *q = [_questions objectAtIndex:indexPath.row];
        cell.correct = [q.last_answer boolValue];
    } else [cell noAnswer];
    
    return cell;
}

#pragma mark - timer delegate

-(void)terminatedTimer:(UIArcTimerView *)timerView{
    _timerView.percent = 0;
    [self answerButtonAction:nil];
}


@end
