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
#import "MultipleChoiceViewController.h"
#import "SingleChoiceViewController.h"
#import "TextChoiceViewController.h"


@interface SubquestionsViewController ()

- (void)displayPreviousQuestion;
- (void)goHome;

@end

@implementation SubquestionsViewController
@synthesize tableData;
@synthesize previousQuestion;
@synthesize previousAnswer;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayPreviousQuestion];
    UIBarButtonItem *goHomeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(goHome)];
    [self.navigationItem setRightBarButtonItem:goHomeBtn];
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
    [cell.textLabel setNumberOfLines:2];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    [cell.textLabel setText:question.questionText];
    
    if ([[[DataManager defaultDataManager] userChoices] questionIsAnswered:[NSNumber numberWithInt:question.questionId]]) {
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
        {    
            SingleChoiceViewController *singleChoiceVC = [[SingleChoiceViewController alloc]initWithNibName:@"SingleChoiceViewController" bundle:nil];
            singleChoiceVC.question = question;
            singleChoiceVC.delegate = self;
            [self presentModalViewController:singleChoiceVC animated:YES];
            break;
        }  
        case 1:
        {
            MultipleChoiceViewController *multipleChoiceVC = [[MultipleChoiceViewController alloc]initWithNibName:@"MultipleChoiceViewController" bundle:nil];
            multipleChoiceVC.question = question;
            multipleChoiceVC.delegate = self;
            UINavigationController *multipleChoiceNC = [[UINavigationController alloc] initWithRootViewController:multipleChoiceVC];
            [self presentModalViewController:multipleChoiceNC animated:YES];
            break;
        }
        case 2:
        {
            TextChoiceViewController *textChoiceVC = [[TextChoiceViewController alloc] initWithNibName:@"TextChoiceViewController" bundle:nil];
            textChoiceVC.question = question;
            textChoiceVC.delegate = self;
            [self presentModalViewController:textChoiceVC animated:YES];
        }
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

- (void)goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

# pragma mark - AnswerDelegate methods

- (void)didSubmitAnswer:(NSObject *)answerObject withSubquestions:(NSArray *)subquestions forQuestion:(Question *)question {
    [self.tableView reloadData];
    [[DataManager defaultDataManager] addAnswers:answerObject forQuestion:[NSNumber numberWithInt:question.questionId]];
    
    if ([subquestions count] > 0) {
        SubquestionsViewController *subquestionsVC = [[SubquestionsViewController alloc] initWithNibName:@"SubquestionsViewController" bundle:nil];
        subquestionsVC.previousQuestion = question.questionText;
        subquestionsVC.tableData = subquestions;
        
        [self.navigationController pushViewController:subquestionsVC animated:YES];
    }
}

- (void)didSubmitTextAnswer:(Answer *)textAnswer forQuestion:(Question *)question{
    [self.tableView reloadData];
    
    [[DataManager defaultDataManager] addAnswers:textAnswer forQuestion:[NSNumber numberWithInt:question.questionId]];
    
}


@end
