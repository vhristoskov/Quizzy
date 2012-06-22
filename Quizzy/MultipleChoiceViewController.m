//
//  MultipleChoiceViewController.m
//  Quizzy
//
//  Created by Victor Hristoskov on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "MultipleChoiceViewController.h"
#import "Answer.h"
#import "DataManager.h"

@interface MultipleChoiceViewController ()
@property(strong, nonatomic) NSMutableArray *chosenAnswers;
@end

@implementation MultipleChoiceViewController
@synthesize chosenAnswers;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.chosenAnswers = [NSMutableArray array];
           
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    
    [self setChosenAnswers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserChoices *userChoices = [DataManager defaultDataManager].userChoices;
    NSNumber *questionId = [NSNumber numberWithInt:self.question.questionId];

    BOOL isQuestionAnswered = [ userChoices questionIsAnswered:questionId];
    
    if(isQuestionAnswered){
        NSArray* previousAnswers = [userChoices fetchAnswersToMultipleChoiceQuestion:questionId];

       
        NSIndexPath *answerIndexPath;
        for (Answer *answ in previousAnswers) {
            for (int i = 0; i< self.answers.count; ++i) {
                Answer* currAnswer = [self.answers objectAtIndex:i];
                if([currAnswer.answerText isEqualToString:answ.answerText]){
                    answerIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView selectRowAtIndexPath:answerIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self.tableView cellForRowAtIndexPath:answerIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                    [self.chosenAnswers addObject:currAnswer];
                    break;
                }
            
            }
        }

    } 

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.chosenAnswers removeObject:[self.answers objectAtIndex:indexPath.row]];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    NSLog(@"%@", self.chosenAnswers);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Answer *chosenAnswer = [self.answers objectAtIndex:indexPath.row];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.chosenAnswers addObject:chosenAnswer];
    NSLog(@"%@", self.chosenAnswers);
}



#pragma mark - Button Action Methods

- (void)cancelChoice:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)submitChoice:(id)sender{
    
    NSArray *subquestions = [[DataManager defaultDataManager] fetchSubquestionsOfQuestion:self.question forAnswers:self.chosenAnswers];

    if([self.delegate respondsToSelector:@selector(didSubmitAnswer:withSubquestions:forQuestion:)]){
        [self.delegate didSubmitAnswer:self.chosenAnswers withSubquestions:subquestions forQuestion:self.question];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
