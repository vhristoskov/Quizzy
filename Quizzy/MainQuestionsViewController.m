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
#import "SingleChoiceViewController.h"
#import "TextChoiceViewController.h"
#import "PreviewAnswersViewController.h"
#include <MessageUI/MessageUI.h>

@interface MainQuestionsViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) Question *selectedQuestion;

- (void)openAnswerViewController;

@end

@implementation MainQuestionsViewController
@synthesize sections;
@synthesize selectedQuestion;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Quiz Questions"];
    UIBarButtonItem *sendEmailBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendEmail)];
    [self.navigationItem setRightBarButtonItem:sendEmailBtn];
    
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
    
    NSDictionary *sectionDict = [self.sections objectAtIndex:[indexPath section]];
    NSArray *sectionQuestions = [sectionDict objectForKey:@"questions"];
    Question *question = [sectionQuestions objectAtIndex:[indexPath row]];
    NSString *questionText = [question questionText];
    
    if ([[[DataManager defaultDataManager] userChoices] questionIsAnswered:[NSNumber numberWithInt:question.questionId]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    UIImage *image = [UIImage imageNamed:@"Question"];
    [cell.imageView setImage:image];
    
    [cell.textLabel setNumberOfLines:2];
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
    
    self.selectedQuestion = question;
    
    if ([[[DataManager defaultDataManager] userChoices] questionIsAnswered:[NSNumber numberWithInt:question.questionId]]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"What next?" message:@"Preview or edit?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Preview", @"Edit", nil];
        [alertView show];
    } else {
        [self openAnswerViewController];
    }
}

# pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        PreviewAnswersViewController *previewAnswersViewController = [[PreviewAnswersViewController alloc] 
                                                                      initWithNibName:@"PreviewAnswersViewController" bundle:nil];
        NSArray *allQuestionsAnswersForSection = [[[DataManager defaultDataManager] userChoices] 
                                                  fetchAllAnswersFromQuestion:[NSNumber numberWithInt:self.selectedQuestion.questionId]];
        previewAnswersViewController.tableData = allQuestionsAnswersForSection;
        
        UINavigationController *answerPreviewNavController = [[UINavigationController alloc] initWithRootViewController:previewAnswersViewController];
        [self presentViewController:answerPreviewNavController animated:YES completion:NULL];
    } else {
        [self openAnswerViewController];
    }
}

# pragma mark - private methods

- (void)openAnswerViewController {
    switch (self.selectedQuestion.questionType) {
        case 0:
        {    
            SingleChoiceViewController *singleChoiceVC = [[SingleChoiceViewController alloc]initWithNibName:@"SingleChoiceViewController" bundle:nil];
            singleChoiceVC.question = self.selectedQuestion;
            singleChoiceVC.delegate = self;
            [self presentModalViewController:singleChoiceVC animated:YES];
            break;
        }        
        case 1:
            // load multiple choice type question view controller
            // set its answers and question properties
            // push it to the navigation controller
            break;
        case 2:
        {
            TextChoiceViewController *textChoiceVC = [[TextChoiceViewController alloc] initWithNibName:@"TextChoiceViewController" bundle:nil];
            textChoiceVC.question = self.selectedQuestion;
            textChoiceVC.delegate = self;
            [self presentModalViewController:textChoiceVC animated:YES];
            
            break;
        }
        default:
            break;
    }
}

- (void)sendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        NSString *messageBody = [[DataManager defaultDataManager] fetchEmailBody];
        [mailer setMessageBody:messageBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Failure"
                                    message:@"Your device doesn't support the composer sheet"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }

    [self dismissModalViewControllerAnimated:YES];
}

# pragma mark - AnswerDelegate methods

- (void)didSubmitAnswer:(Answer *)answer withSubquestions:(NSArray *)subquestions forQuestion:(Question *)question {
    [self.tableView reloadData];
    [[DataManager defaultDataManager] addAnswers:answer forQuestion:[NSNumber numberWithInt:question.questionId]];
    
    if ([subquestions count] > 0) {
        SubquestionsViewController *subquestionsVC = [[SubquestionsViewController alloc] initWithNibName:@"SubquestionsViewController" bundle:nil];
        subquestionsVC.previousQuestion = question.questionText;
        subquestionsVC.previousAnswer = answer.answerText;
        subquestionsVC.tableData = subquestions;
        
        [self.navigationController pushViewController:subquestionsVC animated:YES];
    }
}

@end
