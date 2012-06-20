//
//  MainQuestionsViewController.m
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "MainQuestionsViewController.h"
#import "DataManager.h"
#import "CustomAnimationUtilities.h"
#import "SingleChoiceViewController.h"

@interface MainQuestionsViewController ()

@end

@implementation MainQuestionsViewController
@synthesize sections;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Quiz Questions"];
    
    NSArray *mainQuestions = [[DataManager defaultDataManager] fetchMainQuestions];
    self.sections = [[DataManager defaultDataManager] categorizeQuestions:mainQuestions];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setSections:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDict = [self.sections objectAtIndex:section];
    NSArray *sectionQuestions = [sectionDict objectForKey:@"questions"];
    return [sectionQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSDictionary *questionDict = [self.sections objectAtIndex:[indexPath section]];
    NSArray *sectionQuestions = [questionDict objectForKey:@"questions"];
    NSString *questionText = [[sectionQuestions objectAtIndex:[indexPath row]] questionText];
    
    [cell.textLabel setText:questionText];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDict = [self.sections objectAtIndex:section];
    return [sectionDict valueForKey:@"sectionTitle"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *questionDict = [self.sections objectAtIndex:[indexPath section]];
    NSArray *sectionQuestions = [questionDict objectForKey:@"questions"];
    NSInteger questionType = [[sectionQuestions objectAtIndex:[indexPath row]] questionType];
    if(questionType == 0){
        SingleChoiceViewController *singleChoiceVC = [[SingleChoiceViewController alloc]initWithNibName:@"SingleChoiceViewController" bundle:nil];
        singleChoiceVC.question = [sectionQuestions objectAtIndex:[indexPath row]];
        [self presentModalViewController:singleChoiceVC animated:YES];
//        [CustomAnimationUtilities appearView:singleChoiceVC.view FromBottomOfView:self.view withHeight:460 withDuration:0.4];
    }
    
}

@end
