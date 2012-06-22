//
//  MainQuestionsViewController.h
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDelegate.h"
#import "QuestionTableViewController.h"

@interface MainQuestionsViewController : UITableViewController <AnswerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *sections;

@end