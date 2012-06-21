//
//  TextChoiceViewController.h
//  Quizzy
//
//  Created by Victor Hristoskov on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDelegate.h"

@class Question;
@interface TextChoiceViewController : UIViewController<UITextFieldDelegate>

@property(strong, nonatomic)Question * question;
@property(weak, nonatomic) id<AnswerDelegate> delegate;



@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *questionTitle;
@property (strong, nonatomic) IBOutlet UITextView *answerTextView;
- (IBAction)cancelTextChoice:(id)sender;
- (IBAction)submitTextChoice:(id)sender;



@end
