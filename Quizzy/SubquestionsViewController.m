//
//  SubquestionsViewController.m
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "SubquestionsViewController.h"
#import "Question.h"
#import "CustomLabel.h"
#import "DataManager.h"

@interface SubquestionsViewController ()

- (void)displayPreviousQuestion;

@end

@implementation SubquestionsViewController
@synthesize tableData;
@synthesize previousQuestion;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayPreviousQuestion];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setTableData:nil];
    [self setPreviousQuestion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%@", [self.tableData count]);
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Question *question = [self.tableData objectAtIndex:[indexPath row]];
    [cell.textLabel setText:question.questionText];
    
    if ([[[DataManager defaultDataManager] userChoices] valueForKey:question.questionText]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIImage *image = [UIImage imageNamed:@"Question"];
    [cell.imageView setImage:image];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Question *question = [self.tableData objectAtIndex:[indexPath row]];
    
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

# pragma mark - private methods

- (void)displayPreviousQuestion {
    CGRect tableHeaderViewFrame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 60);
    CustomLabel *previousQuestionLabel = [[CustomLabel alloc] initWithFrame:tableHeaderViewFrame];
    [previousQuestionLabel setText:self.previousQuestion];
    [previousQuestionLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [previousQuestionLabel setNumberOfLines:2];
    [previousQuestionLabel setTextAlignment:UITextAlignmentCenter];
    
    [self.tableView setTableHeaderView:previousQuestionLabel];
}

# pragma mark - AnswerDelegate methods

- (void)didSubmitAnswer:(Answer *)answer withSubquestions:(NSArray *)subquestions forQuestion:(Question *)question {
    [[DataManager defaultDataManager] addChoice:answer withQuestion:question.questionText];
    
    SubquestionsViewController *subquestionsVC = [[SubquestionsViewController alloc] initWithNibName:@"SubquestionsViewController" bundle:nil];
    subquestionsVC.previousQuestion = question.questionText;
    subquestionsVC.tableData = subquestions;
    
    [self.navigationController pushViewController:subquestionsVC animated:YES];
}

@end
