//
//  pmqPagesViewController.m
//  Matematika
//
//  Created by Jan Damek on 23.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqIntrosViewController.h"
#import "pmqExpleinCollectionView.h"
#import "Pages.h"

@interface pmqIntrosViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (weak, nonatomic) IBOutlet pmqExpleinCollectionView *explainGrid;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) Pages *pages;
@property int act_page;

@end

@implementation pmqIntrosViewController

@synthesize data = _data;
@synthesize pages = _pages;
@synthesize act_page = _act_page;

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
}

-(void)setData:(Intros *)data{
    _data = data;
    _act_page = 0;
    
    [self next:_btnNext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawPage{
    NSString *s = _pages.content;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)next:(UIButton *)sender {
    NSEnumerator *n = [_data.relationship_pages objectEnumerator];
    _pages = [n nextObject];
    _act_page++;
    
    [_btnNext setEnabled:_act_page<=[_data.relationship_pages count]];
    
    [self drawPage];
}

- (IBAction)preview:(id)sender {

}


@end
