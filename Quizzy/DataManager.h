//
//  DataManager.h
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "Answer.h"

@interface DataManager : NSObject

+ (DataManager *)defaultDataManager;

- (NSArray *)fetchMainQuestions;
- (NSArray *)fetchSubquestionsOfQuestion:(Question *)question forAnswer:(Answer *)answer;
- (NSArray *)fetchAnswersForQuestion:(Question *)question;
- (NSArray *)categorizeQuestions:(NSArray *)questions;
- (NSArray *)fetchSections;
@end
