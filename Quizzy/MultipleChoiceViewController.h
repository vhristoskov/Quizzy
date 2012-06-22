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
@interface MultipleChoiceViewController : UITableViewController

@property(weak, nonatomic) id<AnswerDelegate> delegate;
@property(retain, nonatomic) Question *question;
@end
