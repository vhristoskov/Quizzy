//
//  SingleChoiceViewController.m
//  Quizzy
//
//  Created by Victor Hristoskov on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "SingleChoiceViewController.h"
#import "DataManager.h"
#import "Answer.h"
#import "Question.h"
#import "SubquestionsViewController.h"
#import "UserChoices.h"
//#import "CustomAnimationUtilities.h"

@interface SingleChoiceViewController ()

@property (strong, nonatomic) Answer *chosenAnswer;
@end

@implementation SingleChoiceViewController

@synthesize chosenAnswer;



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

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserChoices *userChoices = [DataManager defaultDataManager].userChoices;
    NSNumber *questionId = [NSNumber numberWithInt:self.question.questionId];
    
    BOOL isQuestionAnswered = [userChoices questionIsAnswered:questionId];
    NSIndexPath *answerIndexPath;
    
    if(isQuestionAnswered){
        Answer *previousAnswer = [userChoices fetchAnswerToSingleChoiceQuestion:questionId];
        for (int i = 0; i< self.answers.count; ++i) {
            
            if([[[self.answers objectAtIndex:i] answerText] isEqualToString:previousAnswer.answerText]){
                answerIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:answerIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self.tableView cellForRowAtIndexPath:answerIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                self.chosenAnswer = [self.answers objectAtIndex:i];
                break;
            }
        }
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]].accessoryType = UITableViewCellAccessoryNone;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chosenAnswer = [self.answers objectAtIndex:indexPath.row];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    NSLog(@"%@", self.chosenAnswer);
}



#pragma mark - Button Action methods

- (void)cancelChoice:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES]; 
}

- (void)submitChoice:(id)sender{
    
    NSArray *subquestions = [[DataManager defaultDataManager] fetchSubquestionsOfQuestion:self.question forAnswer:self.chosenAnswer];
    
    if ([self.delegate respondsToSelector:@selector(didSubmitAnswer:withSubquestions:forQuestion:)]) {
        [self.delegate didSubmitAnswer:self.chosenAnswer withSubquestions:subquestions forQuestion:self.question];
    }
    [self dismissModalViewControllerAnimated:YES];

}

@end
