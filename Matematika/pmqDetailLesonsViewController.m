//
//  pmqDetailViewController.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqDetailLesonsViewController.h"
#import "Lessons.h"
#import "Intros.h"
#import "Tests.h"
#import "Questions.h"
#import "Results.h"
#import "pmqQuestions.h"
#import "pmqIntrosViewController.h"

@interface pmqDetailLesonsViewController (){
    bool _isInit;
}

@property (weak, nonatomic) IBOutlet UIButton *zkouseni_na_cas;
@property (weak, nonatomic) IBOutlet UIButton *procvicovani;
@property (weak, nonatomic) IBOutlet UIButton *jak_na_to;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UIButton *vysledky_testu;
@property (weak, nonatomic) IBOutlet UIButton *procvicovani_chyb;

- (void)configureView;
@end

@implementation pmqDetailLesonsViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        if ([self.detailItem isKindOfClass:[Lessons class]]){
            Lessons *l = (Lessons*)self.detailItem;
            self.label.title = l.name;
            Tests *t = (Tests*)[[l.relationship_test objectEnumerator]nextObject];
            Intros *i = (Intros*)[[l.relationship_intro objectEnumerator]nextObject];
            
            [self.jak_na_to setHidden:([i.relationship_pages count]==0)];
            
            self.detailDescriptionLabel.text = [NSString stringWithFormat:@"pocet stranek: %i - pocet otazek: %i - pocet vysledku: %i",  [i.relationship_pages count],[t.relationship_question count],[t.relationship_results count]];
            for (Questions *q in t.relationship_question) {
                pmqQuestions *qw = [[pmqQuestions alloc] init];
                qw.q = q;
                [qw position_char:0];
            }
        } else
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"name"] description];
    }
}

- (void)viewDidLoad
{
    _isInit = true;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_isInit){
        [self.masterPopoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        _isInit = false;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Lekce", @"Lekce");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"jnt_default"]) {
        Lessons *l = (Lessons*)self.detailItem;
        Intros *object = (Intros*)[[l.relationship_intro objectEnumerator]nextObject];
        ((pmqIntrosViewController*)[segue destinationViewController]).data = object;
    }
}

@end
