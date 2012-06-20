//
//  MainQuestionsViewController.m
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "MainQuestionsViewController.h"
#import "SubquestionsViewController.h"
#import "DataManager.h"

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
    sections = [[DataManager defaultDataManager] categorizeQuestions:mainQuestions];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *sectionDict = [self.sections objectAtIndex:[indexPath section]];
    NSArray *sectionQuestions = [sectionDict objectForKey:@"questions"];
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
    NSDictionary *sectionDict = [self.sections objectAtIndex:[indexPath section]];
    NSArray *sectionQuestions = [sectionDict objectForKey:@"questions"];
    Question *question = [sectionQuestions objectAtIndex:[indexPath row]];
    
    switch (question.questionType) {
        case 0:
            // load single choice type question view controller
            // set its answers and question properties
            // push it to the navigation controller
            break;
        case 1:
            // load multiple choice type question view controller
            // set its answers and question properties
            // push it to the navigation controller
            break;
        case 3:
            // load text choice type question view controller
            // set its answers and question properties
            // push it to the navigation controller
            break;
        default:
            break;
    }
}

@end