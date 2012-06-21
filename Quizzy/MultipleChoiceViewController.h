//
//  MultipleChoiceViewController.h
//  Quizzy
//
//  Created by Victor Hristoskov on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDelegate.h"

@class Question;
@interface MultipleChoiceViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) id<AnswerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIPickerView *multipleChoicePickerView;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

- (IBAction)cancelMultipleChoice:(id)sender;
- (IBAction)submitMultipleChoice:(id)sender;

@end
