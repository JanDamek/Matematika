//
//  pmqPagesViewController.m
//  Matematika
//
//  Created by Jan Damek on 23.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqIntrosViewController.h"
#import "Pages.h"
#import "Lessons.h"
#import "pmqPages.h"
#import "pmqExpleinCell.h"
#import "pmqTestingViewController.h"
#import "pmqDetailLesonsViewController.h"

@interface pmqIntrosViewController (){
    float w;
    float h;
    NSEnumerator *n;
    bool isReadyToPlay;
    
    UIFont *_font;
    
    AVAudioPlayer *_player;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UICollectionView *explainGrid;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) Pages *pages;
@property int act_page;
@property (strong, nonatomic) pmqPages *p;

@end

@implementation pmqIntrosViewController

@synthesize data = _data;
@synthesize pages = _pages;
@synthesize act_page = _act_page;
@synthesize explainGrid = _explainGrid;
@synthesize webView = _webView;
@synthesize p = _p;

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
    isReadyToPlay = NO;
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self prepareData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    isReadyToPlay = YES;
    
    @try {
        NSString *sound_file = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"lng", nil),
                                @"intro"];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:sound_file
                                             ofType:@"mp3"]];
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
        _player.delegate = self;
        [_player play];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
    }
    
}

-(pmqPages *)p{
    if (!_p){
        _p = [[pmqPages alloc]init];
    }
    return _p;
}

-(void)setData:(Intros *)data{
    _data = data;
    _act_page = 0;
    n = [_data.relationship_pages objectEnumerator];
    
    [self next:_btnNext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareData{
    self.p.data = _pages;
    if ([self.p numOfColumns]==1){
        w = 50;
        h = 50;
        [_explainGrid setHidden:YES];
        [_webView setHidden:NO];
        [_webView loadHTMLString:_pages.content baseURL:[NSURL URLWithString:@""]];
    }else{
        [_webView setHidden:YES];
        [_explainGrid setHidden:NO];
        w = (_explainGrid.frame.size.width - (_p.numOfColumns * 5) - 10 ) / [self.p numOfColumns];
        h = (_explainGrid.frame.size.height - (_p.numOfColumns * 5) - 10) / [self.p numOfRows] ;
        
        [_explainGrid reloadData];}
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    w = (_explainGrid.frame.size.width - (_p.numOfColumns * 5) - 10 ) / [self.p numOfColumns];
    h = (_explainGrid.frame.size.height - (_p.numOfColumns * 5) - 10) / [self.p numOfRows] ;
    
    if (h<w){
        _font = [UIFont boldSystemFontOfSize:h / 2];
    } else
        _font = [UIFont boldSystemFontOfSize:w / 2];

    return CGSizeMake(w, h);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [_explainGrid reloadData];
}


- (IBAction)next:(UIButton *)sender {
    if (!_pages){
        _pages = [n nextObject];
        if (_pages){
            _act_page++;
            
            [self prepareData];
            
            [self next:sender];
        } else {
            pmqDetailLesonsViewController *d = [self.navigationController.viewControllers objectAtIndex:0];
            [d performSelector:@selector(performProcvicovani)];
        }
    } else {
        if (![_p next]){
            if (sender){
                _pages = nil;
                [self next:sender];
            }
        }else{
            [_explainGrid reloadData];
            
            if ([_p.data.type isEqualToString:@"html"])
            {
                
            }else if (isReadyToPlay) {
                if (_player.isPlaying) {
                    [_player stop];
                }
                @try {
                    NSString *sound_file = NSLocalizedString([_p actualChar], nil);
                    sound_file = [sound_file stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    sound_file = [sound_file stringByReplacingOccurrencesOfString:@")" withString:@""];
                    
                    sound_file = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"lng", nil),
                                  sound_file];
                    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                         pathForResource:sound_file
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
    }
    
}

- (IBAction)preview:(id)sender {
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self next:nil];
}

#pragma mark - collection delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.p numOfItems];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pmqExpleinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpleinCell" forIndexPath:indexPath];
    id object = [self.p objectForItemIndex:indexPath.row];
    
    if ([object isKindOfClass:[NSString class]]){
        cell.lab.text = (NSString*)object;
        [cell.lab setFont:_font];
        [cell.img setHidden:YES];
        [cell.lab setHidden:NO];
    } else {
        cell.img.image = (UIImage*)object;
        [cell.img setHidden:NO];
        [cell.lab setHidden:YES];
    }
    
    if (indexPath.row+1 == _p.actualIndex){
        [cell highlite];
    }
    return cell;
}

@end
