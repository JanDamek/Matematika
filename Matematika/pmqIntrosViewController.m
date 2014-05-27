//
//  pmqPagesViewController.m
//  Matematika
//
//  Created by Jan Damek on 23.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqIntrosViewController.h"
#import "Pages.h"
#import "pmqPages.h"
#import "pmqExpleinCell.h"

@interface pmqIntrosViewController (){
    float w;
    float h;
    NSEnumerator *n;
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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
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
        w = _explainGrid.frame.size.width / ([self.p numOfColumns]+1);
        h = _explainGrid.frame.size.height / ([self.p numOfRows]+1);
    
        [_explainGrid reloadData];}
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(w, h);
}


- (IBAction)next:(UIButton *)sender {
    if (!_pages){
        _pages = [n nextObject];
        _act_page++;
        
        [_btnNext setEnabled:_act_page<=([_data.relationship_pages count]-1)];

        [self prepareData];
    } else {
        if (![_p next]){
            _pages = nil;
            [self next:sender];
            
        }else
            [_explainGrid reloadData];
    }
    
}

- (IBAction)preview:(id)sender {

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
        [cell.img setHidden:YES];
        [cell.lab setHidden:NO];
    } else {
        cell.img.image = (UIImage*)object;
        [cell.img setHidden:NO];
        [cell.lab setHidden:YES];
    }
    return cell;
}


@end
