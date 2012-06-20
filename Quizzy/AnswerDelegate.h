//
//  AnswerDelegate.h
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "Answer.h"

@protocol AnswerDelegate <NSObject>

- (void)didSubmitAnswer:(Answer *)answer withSubquestions:(NSArray *)subquestions forQuestion:(Question *)question;

@end
