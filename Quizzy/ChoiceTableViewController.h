//
//  ChoiceTableViewController.h
//  Quizzy
//
//  Created by Victor Hristoskov on 6/22/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDelegate.h"

@class Question;
@interface ChoiceTableViewController : UITableViewController

@property(weak, nonatomic) id<AnswerDelegate> delegate;
@property(retain, nonatomic) Question *question;
@property(strong, nonatomic) NSArray *answers;

- (IBAction)cancelChoice:(id)sender;
- (IBAction)submitChoice:(id)sender;
- (void)configureToolbarView;

@end
