//
//  TextChoiceViewController.m
//  Quizzy
//
//  Created by Victor Hristoskov on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "TextChoiceViewController.h"
#import "Answer.h"
#import "DataManager.h"

@interface TextChoiceViewController ()

@end

@implementation TextChoiceViewController
@synthesize questionTitle;
@synthesize answerTextView;
@synthesize question;
@synthesize delegate;
@synthesize contentView;


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.questionTitle.text = self.question.questionText;
}

- (void)viewDidUnload
{
    [self setAnswerTextView:nil];
    [self setQuestion:nil];
    [self setQuestionTitle:nil];
    [self setDelegate:nil];
    [self setContentView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IBAction Methods
- (IBAction)cancelTextChoice:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)submitTextChoice:(id)sender {

    Answer *answer = [[Answer alloc] init];
    answer.answerId = NSIntegerMax;
    answer.answerText = self.answerTextView.text;

    if([self.delegate respondsToSelector:@selector(didSubmitTextAnswer:forQuestion:)]){
        [self.delegate didSubmitTextAnswer:answer forQuestion:self.question];
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - additional functionality

-(void) keyboardWillShow
{
    [self moveAllComponentsWithAnimationForOffset:-80.0f];
}
-(void) keyboardWillHide
{
    [self moveAllComponentsWithAnimationForOffset:+80.0f];
}

-(void) moveAllComponentsWithAnimationForOffset:(CGFloat) offset
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y+offset, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [UIView commitAnimations];
}


@end
