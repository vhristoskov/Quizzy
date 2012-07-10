//
//  SubquestionsViewController.h
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDelegate.h"

@interface SubquestionsViewController : UITableViewController <AnswerDelegate>

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSString *previousQuestion;
@property (nonatomic, strong) NSString *previousAnswer;

@end
