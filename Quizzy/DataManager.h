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
#import "UserChoices.h"

@interface DataManager : NSObject

@property (nonatomic, strong) UserChoices *userChoices;
@property (nonatomic, strong) NSMutableArray *questions;

+ (DataManager *)defaultDataManager;

- (NSDictionary *)fetchAllQuestions;
- (NSArray *)fetchMainQuestions;
- (NSArray *)fetchSubquestionsOfQuestion:(Question *)question forAnswer:(Answer *)answer;
- (NSArray *)fetchSubquestionsOfQuestion:(Question *)question forAnswers:(NSArray *)answers;
- (NSArray *)fetchAnswersForQuestion:(Question *)question;
- (NSArray *)categorizeQuestions:(NSArray *)questions;
- (NSArray *)fetchSections;
- (void)addAnswers:(NSObject *)answerObject forQuestion:(NSNumber *)questionId;
- (NSString *)fetchEmailBody;

@end
