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
    
    NSUInteger time_to_show_answer;
    
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
@synthesize questionLabel1 = _questionLabel1;
@synthesize questionLabel2 = _questionLabel2;
@synthesize questionMark = _questionMark;

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
    
    [_questionLabel1 setHidden:YES];
    [_questionLabel2 setHidden:YES];
    [_questionMark setHidden:YES];
    [_timerView setHidden:YES];
    [_labelAnswer setHidden:YES];
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
                                                 ofType:@"aac"]];
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self realignView];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void)realignView{
    int midl = self.view.frame.size.width / 2;
    
    [_questionLabel1 sizeToFit];
    [_questionLabel2 sizeToFit];
    [_labelAnswer sizeToFit];
    
    CGRect q1 = _questionLabel1.frame;
    CGRect q2 = _questionLabel2.frame;
    CGRect qM = _questionMark.frame;
    CGRect ti = _timerView.frame;
    CGRect lA = _labelAnswer.frame;
    
    int size = q1.size.width;
    
    if (!_labelAnswer.isHidden){
        size += lA.size.width;
    } else
        if (!_questionMark.isHidden){
            size += qM.size.width;
        } else
            if (!_timerView.isHidden){
                size += ti.size.width;
            };
    
    size += q2.size.width;
    q1.origin.x = midl - (size / 2);
    size = q1.origin.x + q1.size.width;
    
    if (!_labelAnswer.isHidden){
        lA.origin.x = size;
        size += lA.size.width;
    } else
        if (!_questionMark.isHidden){
            qM.origin.x = size;
            size += qM.size.width;
        } else
            if (!_timerView.isHidden){
                ti.origin.x = size;
                size += ti.size.width;
            };
    
    q2.origin.x = size;
    
    _questionLabel1.frame = q1;
    _questionLabel2.frame = q2;
    _questionMark.frame = qM;
    _timerView.frame = ti;
    _labelAnswer.frame = lA;
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
        
        CGRect v = self.view.frame;
        int pos = v.size.width / 2;
        
        CGRect s = _questionLabel2.frame;
        s.origin.y = _questionLabel1.frame.origin.y;
        
        pos -= ((s.size.width  + _timerView.frame.size.width + _questionLabel1.frame.size.width)/2);
        v = _questionLabel1.frame;
        v.origin.x = pos;
        _questionLabel1.frame = v;
        
        if (_testMode == tmTest){
            [_questionMark setHidden:NO];
            [_timerView setHidden:YES];
            
            int y;
            int height;
            if (_questionLabel1.frame.size.height>0){
                y = _questionLabel1.frame.origin.y;
                height = _questionLabel1.frame.size.height;
            } else {
                y = _questionLabel2.frame.origin.y;
                height = _questionLabel2.frame.size.height;
            }
            
            CGRect p = _questionMark.frame;
            p.origin.x = _questionLabel1.frame.origin.x + _questionLabel1.frame.size.width;
            p.origin.y = y - ((_questionMark.frame.size.height - height)/2);
            _questionMark.frame=p;
            s.origin.x = _questionMark.frame.origin.x + _questionMark.frame.size.width;
        }else{
            [_questionMark setHidden:YES];
            [_timerView setHidden:NO];
            
            CGRect p = _timerView.frame;
            p.origin.x = _questionLabel1.frame.origin.x + _questionLabel1.frame.size.width;
            
            int y;
            int height;
            if (_questionLabel1.frame.size.height>0){
                y = _questionLabel1.frame.origin.y;
                height = _questionLabel1.frame.size.height;
            } else {
                y = _questionLabel2.frame.origin.y;
                height = _questionLabel2.frame.size.height;
            }
            
            p.origin.y = y - ((_timerView.frame.size.height - height)/2);
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
    [UIView beginAnimations:@"correct" context:nil];
    
    if (time_to_show_answer>1) {
        [_labelAnswer setTextColor:[UIColor redColor]];
    }
    
    [UIView setAnimationDuration:time_to_show_answer];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
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
        
        [self performSelector:@selector(markCorrect) withObject:nil afterDelay:time_to_show_answer / 5];
        
    } else if ( [(NSString*)anim isEqualToString:@"correct"] ){
        
        [_labelAnswer setTextColor:[UIColor blackColor]];
        [self performSelector:@selector(prepareNextQuestion) withObject:nil afterDelay:time_to_show_answer];
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
            if (_labelAnswer.frame.origin.x <_questionLabel2.frame.origin.x) {
                CGRect p = _questionLabel2.frame;
                p.origin.x = _labelAnswer.frame.origin.x + _labelAnswer.frame.size.width;
                _questionLabel2.frame = p;
            }
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
    if ([q.last_answer boolValue]) {
        time_to_show_answer = 1;
    } else {
        time_to_show_answer = 3;
    }
    
    NSString *sound_file;
    if (sender==nil){
        sound_file = @"snd_timeout";
    } else if (sender.tag==1){
        sound_file = @"snd_correct";
    } else sound_file = @"snd_failed";
    
    @try {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:sound_file
                                             ofType:@"aac"]];
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
