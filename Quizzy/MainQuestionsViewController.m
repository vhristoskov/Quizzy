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
#include <MessageUI/MessageUI.h>

@interface MainQuestionsViewController () <MFMailComposeViewControllerDelegate>

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
    NSString *questionText = [[sectionQuestions objectAtIndex:[indexPath row]] questionText];
    
    if ([[[DataManager defaultDataManager] userChoices] valueForKey:questionText]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    UIImage *image = [UIImage imageNamed:@"Question"];
    [cell.imageView setImage:image];

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
        {    
            SingleChoiceViewController *singleChoiceVC = [[SingleChoiceViewController alloc]initWithNibName:@"SingleChoiceViewController" bundle:nil];
            singleChoiceVC.question = [sectionQuestions objectAtIndex:[indexPath row]];
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
            textChoiceVC.question = [sectionQuestions objectAtIndex:[indexPath row]];
            textChoiceVC.delegate = self;
            [self presentModalViewController:textChoiceVC animated:YES];
            
            break;
        }
        default:
            break;
    }

}

# pragma mark - private methods

- (void)sendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        NSString *messageBody = [[DataManager defaultDataManager] getChoicesAsText];
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
    [[DataManager defaultDataManager] addChoice:answer withQuestion:question.questionText];
    
    if(subquestions){
        SubquestionsViewController *subquestionsVC = [[SubquestionsViewController alloc] initWithNibName:@"SubquestionsViewController" bundle:nil];
        subquestionsVC.previousQuestion = question.questionText;
        subquestionsVC.tableData = subquestions;
    [self.navigationController pushViewController:subquestionsVC animated:YES];
    }
        
    
}

@end
