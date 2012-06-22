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
@property (strong, nonatomic) NSArray *answers;
@property (strong, nonatomic) Answer *answerChoice;
@end

@implementation SingleChoiceViewController
@synthesize questionLabel;
@synthesize singleChoicePickerView;
@synthesize question;
@synthesize answers;
@synthesize answerChoice;
@synthesize delegate;

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
     self.answers = [[DataManager defaultDataManager] fetchAnswersForQuestion:self.question];
     self.questionLabel.text = self.question.questionText;
 
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSingleChoicePickerView:nil];
    [self setAnswers:nil];
    [self setQuestion:nil];
    [self setQuestionLabel:nil];
    [self setAnswerChoice: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    UserChoices *userChoices = [DataManager defaultDataManager].userChoices;
    NSNumber *questionId = [NSNumber numberWithInt:self.question.questionId];
    
    BOOL isQuestionAnswered = [userChoices questionIsAnswered:questionId];
    NSInteger questionArrIndex = 0;
    
    if(isQuestionAnswered){
        Answer *previousAnswer = [userChoices fetchAnswerToSingleChoiceQuestion:questionId];
        for (int i = 0; i< self.answers.count; ++i) {
            
            if([[[self.answers objectAtIndex:i] answerText] isEqualToString:previousAnswer.answerText]){
                questionArrIndex = i;
            }
        }
    }
    
    
    self.answerChoice = [self.answers objectAtIndex:questionArrIndex];
    [self.singleChoicePickerView selectRow:questionArrIndex inComponent:0 animated:NO];
    
   

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PickerView Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.answers count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self.answers objectAtIndex:row] answerText];

}

#pragma mark - PickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%@", [[self.answers objectAtIndex:row] answerText]);
    self.answerChoice = [self.answers objectAtIndex:row];
}


#pragma mark - IBAction Methods

- (IBAction)cancelSingleChoice:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
//    [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];
}

- (IBAction)submitSingleChoice:(id)sender {
    
    NSArray *subquestions = [[DataManager defaultDataManager] fetchSubquestionsOfQuestion:self.question forAnswer:self.answerChoice];
       
    if ([self.delegate respondsToSelector:@selector(didSubmitAnswer:withSubquestions:forQuestion:)]) {
        [self.delegate didSubmitAnswer:self.answerChoice withSubquestions:subquestions forQuestion:self.question];
    }
    [self dismissModalViewControllerAnimated:YES];
//    [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];

}
@end
