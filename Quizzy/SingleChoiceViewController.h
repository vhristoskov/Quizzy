//
//  SingleChoiceViewController.h
//  Quizzy
//
//  Created by Victor Hristoskov on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDelegate.h"
@class Question;

@interface SingleChoiceViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) IBOutlet UIPickerView *singleChoicePickerView;
- (IBAction)cancelSingleChoice:(id)sender;
- (IBAction)submitSingleChoice:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) id<AnswerDelegate> delegate;

@end
