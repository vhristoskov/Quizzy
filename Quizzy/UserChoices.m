//
//  UserChoices.m
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "UserChoices.h"
#import "DataManager.h"

@interface UserChoices ()

@property (nonatomic, strong) NSDictionary *sortedQuestionAnswers;

- (NSDictionary *)sortQuestionAnswers;
- (NSString *)prepareAnswerForSingleChoiceQuestion:(Question *)question;
- (NSString *)prepareAnswerForMultipleChoiceQuestion:(Question *)question;
- (void)removeSubquestionsforQuestion:(NSNumber *)questionId WithNewAnswer:(Answer *)newAnswer;

@end

@implementation UserChoices
@synthesize questionAndAnswers;
@synthesize sortedQuestionAnswers;

- (id)init {
    self = [super init];
    if (self) {
        questionAndAnswers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

# pragma mark - public methods

- (void)addAnswer:(Answer *)answer toSingleChoiceQuestion:(NSNumber *)questionId {
    if ([self questionIsAnswered:questionId]) {
        [self removeSubquestionsforQuestion:questionId WithNewAnswer:answer];
    }
    [self.questionAndAnswers setObject:answer forKey:questionId];
}

- (void)addAnswers:(NSArray *)answers toMultipleChoiceQuestion:(NSNumber *)questionId {
    if ([self questionIsAnswered:questionId]) {
        for (Answer *answer in answers) {
            [self removeSubquestionsforQuestion:questionId WithNewAnswer:answer];
        }
    }
    [self.questionAndAnswers setObject:answers forKey:questionId];
}

- (void)addAnswer:(Answer *)answer toTextQuestion:(NSNumber *)questionId {
    [self addAnswer:answer toSingleChoiceQuestion:questionId];
}

- (NSString *)prepareEmailBody {
    self.sortedQuestionAnswers = [self sortQuestionAnswers];
    
    NSMutableString *emailBody = [[NSMutableString alloc] init];
    NSArray *sections = [self.sortedQuestionAnswers allKeys];
    for (NSString *section in sections) {
        NSMutableArray *sectionQuestionAnswers = [self.sortedQuestionAnswers valueForKey:section];
        if ([sectionQuestionAnswers count] > 0) {
            [emailBody appendString:[NSString stringWithFormat:@"%@\n", section]];
            for (NSString *questionAnswer in sectionQuestionAnswers) {
                [emailBody appendString:[NSString stringWithFormat:@"%@\n", questionAnswer]];
            }
            [emailBody appendString:@"\n"];
        }
    }
    
    return emailBody;
}

- (BOOL)questionIsAnswered:(NSNumber *)questionId {
    if ([self.questionAndAnswers objectForKey:questionId]) {
        return YES;
    } else {
        return NO;
    }
}

# pragma mark - private methods

- (NSDictionary *)sortQuestionAnswers {
    NSMutableDictionary *categorizedQuestionAnswers = [[NSMutableDictionary alloc] init];
    
    NSArray *sections = [[DataManager defaultDataManager] fetchSections];
    for (NSString *sectionText in sections) {
        [categorizedQuestionAnswers setValue:[NSMutableArray array] forKey:sectionText];
    }
    
    NSDictionary *questionsWithIds = [[DataManager defaultDataManager] fetchAllQuestions];
    NSArray *allQuestions = [questionsWithIds allValues];
    
    NSMutableArray *answeredQuestions = [[NSMutableArray alloc] init];
    for (Question *q in allQuestions) {
        if ([self questionIsAnswered:[NSNumber numberWithInt:q.questionId]]) {
            [answeredQuestions addObject:q];
        }
    }

    for (Question *question in answeredQuestions) {
        NSString *questionAnswer;
        
        switch (question.questionType) {
            case 0:
                questionAnswer = [self prepareAnswerForSingleChoiceQuestion:question];
                break;
            case 1:
                questionAnswer = [self prepareAnswerForMultipleChoiceQuestion:question];
                break;
            case 2:
                questionAnswer = [self prepareAnswerForSingleChoiceQuestion:question];
                break;
            default:
                NSLog(@"Error - Unrecognized question type");
                break;
        }
        
        NSMutableArray *sectionQuestionAnswers = [categorizedQuestionAnswers valueForKey:question.questionSection];
        [sectionQuestionAnswers addObject:questionAnswer];
    }
    
    return categorizedQuestionAnswers;
}

- (NSString *)prepareAnswerForSingleChoiceQuestion:(Question *)question {
    Answer *answer = [self.questionAndAnswers objectForKey:[NSNumber numberWithInt:question.questionId]];
    NSString *result = [NSString stringWithFormat:@"Question: %@\nAnswer: %@\n", question.questionText, answer.answerText];
    return result;
}

- (NSString *)prepareAnswerForMultipleChoiceQuestion:(Question *)question {
    NSArray *answers = [self.questionAndAnswers objectForKey:[NSNumber numberWithInt:question.questionId]];
    NSMutableString *result = [NSMutableString stringWithFormat:@"Question: %@\nAnswers:\n", question.questionText];
    for (Answer *a in answers) {
        [result appendString:[NSString stringWithFormat:@"%@\n", a.answerText]];
    }
    return result;
}

- (void)removeSubquestionsforQuestion:(NSNumber *)questionId WithNewAnswer:(Answer *)newAnswer {
    NSDictionary *questionsWithIds = [[DataManager defaultDataManager] fetchAllQuestions];
    Question *question = [questionsWithIds objectForKey:questionId];
    
    Answer *oldAnswer = [self.questionAndAnswers objectForKey:questionId];
    if (oldAnswer.answerId == newAnswer.answerId) {
        return;
    }
    
    NSArray *subquestions = [[DataManager defaultDataManager] fetchSubquestionsOfQuestion:question forAnswer:oldAnswer];
    NSMutableArray *subquestionIds = [[NSMutableArray alloc] init];
    for (Question *q in subquestions) {
        [subquestionIds addObject:[NSNumber numberWithInt:q.questionId]];
    }
    
    [self.questionAndAnswers removeObjectsForKeys:subquestionIds];
}

@end
