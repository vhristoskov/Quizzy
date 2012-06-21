//
//  MultipleChoiceViewController.m
//  Quizzy
//
//  Created by Victor Hristoskov on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "MultipleChoiceViewController.h"
#import "DataManager.h"

@interface MultipleChoiceViewController ()
@property(strong, nonatomic) NSArray* answers;
@end

@implementation MultipleChoiceViewController
@synthesize multipleChoicePickerView;
@synthesize questionLabel;
@synthesize answers;
@synthesize question;
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
}

- (void)viewDidUnload
{
    [self setMultipleChoicePickerView:nil];
    [self setQuestionLabel:nil];
    [self setAnswers:nil];
    [self setQuestion:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPickerDelegate Methods


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.answers count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self.answers objectAtIndex:row] answerText];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}


#pragma mark - IBAction Methods
- (IBAction)cancelMultipleChoice:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)submitMultipleChoice:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
