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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation pmqTestingViewController

@synthesize marks = _marks, q = _q;
@synthesize timerView = _timerView;
@synthesize answerButtons = _answerButtons;
@synthesize testMode = _testMode;

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
    // Do any additional setup after loading the view.
    _timerView.delegate = self;
    mark_size = (_marks.frame.size.width - 120) / 12;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareTest];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:answered];
    
    [self loadFromLastTest];
    
    if ([_data.welcome_sound hasSuffix:@"mp3"]) {
        NSString *sounf_file = [[_data.welcome_sound lastPathComponent] stringByDeletingPathExtension];
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
    _testMode = testMode;
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
    int test_length = [_data.test_length intValue];
    
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
        pmqQ.q = (Questions*)[_questions objectAtIndex:answered];
        
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
            } else {
                [b setTitle:@"" forState:UIControlStateNormal];

            }
            i++;
            [b setHidden:[b.titleLabel.text isEqualToString:@""]];
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

- (IBAction)answerButtonAction:(UIButton *)sender {
    Questions *q = [_questions objectAtIndex:answered];
    q.last_answer = [NSNumber numberWithBool:sender.tag==1];
    answered++;
    
    NSString *sound_file;
    if (sender==nil){
        sound_file = @"snd_timeout";
    } else if ([q.last_answer intValue]==1){
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
    
    
    if (answered<[_data.test_length intValue]){
        [self loadFromLastTest];
    } else {
        if (_testMode==tmTest) {
            _testMode = tmTestOnTime;
            [self prepareTest];
            [self loadFromLastTest];
        } else {
            //TODO: show test result
            pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
            Results *r = _data.relationship_results;
            if (!r){
                r = [d.data newResults];
                _data.relationship_results = r;
            }
            NSArray *rq = [r.relationship_questions allObjects];
            for (Questions *q in rq) {
                [r removeRelationship_questionsObject:q];
            }
            for (int i=0; i<[_questions count]; i++) {
                Questions *q = [_questions objectAtIndex:i];
                [r addRelationship_questionsObject:q];
            }
            r.date = [NSDate date];
            
            [d.data saveResults];
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
