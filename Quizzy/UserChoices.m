//
//  UserChoices.m
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "UserChoices.h"
#import "DataManager.h"
#import "UserResponse.h"

@interface UserChoices ()

@property (nonatomic, strong) NSDictionary *sortedQuestionAnswers;
@property (nonatomic, strong) NSDictionary *questionsWithIds;

- (NSDictionary *)categorizeQuestions;
- (NSString *)prepareAnswerForSingleChoiceQuestion:(Question *)question;
- (NSString *)prepareAnswerForMultipleChoiceQuestion:(Question *)question;
- (void)removeSubquestionsforQuestion:(NSNumber *)questionId withNewAnswer:(Answer *)newAnswer;

@end

@implementation UserChoices
@synthesize questionAndAnswers;
@synthesize sortedQuestionAnswers;
@synthesize questionsWithIds;

- (id)init {
    self = [super init];
    if (self) {
        questionAndAnswers = [[NSMutableDictionary alloc] init];
        questionsWithIds = [[DataManager defaultDataManager] fetchAllQuestions];
    }
    return self;
}

# pragma mark - public methods

- (void)addAnswer:(Answer *)answer toSingleChoiceQuestion:(NSNumber *)questionId {
    if ([self questionIsAnswered:questionId]) {
        [self removeSubquestionsforQuestion:questionId withNewAnswer:answer];
    }
    [self.questionAndAnswers setObject:answer forKey:questionId];
}

- (void)addAnswers:(NSArray *)answers toMultipleChoiceQuestion:(NSNumber *)questionId {
    if ([self questionIsAnswered:questionId]) {
        [self removeSubquestionsforQuestion:questionId withNewAnswers:answers];
    }
    [self.questionAndAnswers setObject:answers forKey:questionId];
}

- (void)addAnswer:(Answer *)answer toTextQuestion:(NSNumber *)questionId {
    [self addAnswer:answer toSingleChoiceQuestion:questionId];
}

- (NSString *)prepareEmailBody {
    self.sortedQuestionAnswers = [self categorizeQuestions];
    
    NSMutableString *emailBody = [[NSMutableString alloc] init];
    NSArray *sections = [self.sortedQuestionAnswers allKeys];
    for (NSString *section in sections) {
        NSMutableArray *sectionUserResponses = [self.sortedQuestionAnswers valueForKey:section];
        
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"questionLevel" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sd];
        NSArray *sortedSectionUserResponses = [sectionUserResponses sortedArrayUsingDescriptors:sortDescriptors];
        
        if ([sectionUserResponses count] > 0) {
            [emailBody appendString:[NSString stringWithFormat:@"%@\n", section]];
            for (UserResponse *userResponse in sortedSectionUserResponses) {
                [emailBody appendString:[NSString stringWithFormat:@"%@\n", userResponse.response]];
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

- (Answer *)fetchAnswerToSingleChoiceQuestion:(NSNumber *)questionId {
    if (![self questionIsAnswered:questionId]) {
        return nil;
    }
    Answer *answer = [self.questionAndAnswers objectForKey:questionId];
    return answer;
}

- (NSArray *)fetchAnswersToMultipleChoiceQuestion:(NSNumber *)questionId {
    if (![self questionIsAnswered:questionId]) {
        return nil;
    }
    NSArray *answers = [self.questionAndAnswers objectForKey:questionId];
    return answers;
}

- (NSArray *)fetchAllAnswersFromQuestion:(NSNumber *)questionId {
    self.sortedQuestionAnswers = [self categorizeQuestions];
    
    Question *question = [self.questionsWithIds objectForKey:questionId];
    NSArray *sectionUserResponses = [self.sortedQuestionAnswers objectForKey:question.questionSection];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"questionLevel" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sd];
    NSArray *sortedSectionUserResposes = [sectionUserResponses sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedSectionUserResposes;
}

# pragma mark - private methods

- (NSDictionary *)categorizeQuestions {
    NSMutableDictionary *categorizedQuestionAnswers = [[NSMutableDictionary alloc] init];
    
    NSArray *sections = [[DataManager defaultDataManager] fetchSections];
    for (NSString *sectionText in sections) {
        [categorizedQuestionAnswers setValue:[NSMutableArray array] forKey:sectionText];
    }
    
    NSArray *allQuestions = [self.questionsWithIds allValues];
    NSMutableArray *answeredQuestions = [[NSMutableArray alloc] init];
    for (Question *q in allQuestions) {
        if ([self questionIsAnswered:[NSNumber numberWithInt:q.questionId]]) {
            [answeredQuestions addObject:q];
        }
    }

    for (Question *question in answeredQuestions) {
        NSString *questionAnswer;
        UserResponse *userResponse = [[UserResponse alloc] init];
        
        switch (question.questionType) {
            case 0:
            {
                questionAnswer = [self prepareAnswerForSingleChoiceQuestion:question];
                userResponse.questionLevel = question.questionLevel;
                userResponse.response = questionAnswer;
                break;
            }
            case 1:
            {
                questionAnswer = [self prepareAnswerForMultipleChoiceQuestion:question];
                userResponse.questionLevel = question.questionLevel;
                userResponse.response = questionAnswer;
                break;
            }
            case 2:
            {
                questionAnswer = [self prepareAnswerForSingleChoiceQuestion:question];
                userResponse.questionLevel = question.questionLevel;
                userResponse.response = questionAnswer;
                break;
            }
            default:
                NSLog(@"Error - Unrecognized question type");
                break;
        }
        
        NSMutableArray *sectionQuestionAnswers = [categorizedQuestionAnswers valueForKey:question.questionSection];
        [sectionQuestionAnswers addObject:userResponse];
    }
    
    return categorizedQuestionAnswers;
}

- (NSString *)prepareAnswerForSingleChoiceQuestion:(Question *)question {
    Answer *answer = [self.questionAndAnswers objectForKey:[NSNumber numberWithInt:question.questionId]];
    NSString *result = [NSString stringWithFormat:@"%@\nYou answered: %@\n", question.questionText, answer.answerText];
    return result;
}

- (NSString *)prepareAnswerForMultipleChoiceQuestion:(Question *)question {
    NSArray *answers = [self.questionAndAnswers objectForKey:[NSNumber numberWithInt:question.questionId]];
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@\nYou replied:\n", question.questionText];
    for (Answer *a in answers) {
        [result appendString:[NSString stringWithFormat:@"%@\n", a.answerText]];
    }
    return result;
}

- (void)removeSubquestionsforQuestion:(NSNumber *)questionId withNewAnswer:(Answer *)newAnswer {
    Answer *oldAnswer = [self.questionAndAnswers objectForKey:questionId];
    if (newAnswer) {
        if (!oldAnswer || oldAnswer.answerId == newAnswer.answerId) {
            return;
        }
    }
    
    Question *question = [self.questionsWithIds objectForKey:questionId];
    NSArray *subquestions = [[DataManager defaultDataManager] fetchSubquestionsOfQuestion:question forAnswer:oldAnswer];
    if ([subquestions count] == 0) {
        return;
    }
    
    NSMutableArray *subquestionIds = [[NSMutableArray alloc] init];
    for (Question *q in subquestions) {
        NSNumber *subquestionId = [NSNumber numberWithInt:q.questionId];
        [subquestionIds addObject:subquestionId];
        [self removeSubquestionsforQuestion:subquestionId withNewAnswer:nil];
    }
    
    [self.questionAndAnswers removeObjectsForKeys:subquestionIds];
}

- (void)removeSubquestionsforQuestion:(NSNumber *)questionId withNewAnswers:(NSArray *)newAnswers {
    NSArray *oldAnswers = [self.questionAndAnswers objectForKey:questionId];
    
    Question *question = [self.questionsWithIds objectForKey:questionId];
    NSArray *subquestions = [[DataManager defaultDataManager] fetchSubquestionsOfQuestion:question forAnswers:oldAnswers];
    if ([subquestions count] == 0) {
        return;
    }
    
    NSMutableArray *subquestionIds = [[NSMutableArray alloc] init];
    for (Question *q in subquestions) {
        NSNumber *subquestionId = [NSNumber numberWithInt:q.questionId];
        [subquestionIds addObject:subquestionId];
        if (q.questionType == 0) {
            [self removeSubquestionsforQuestion:subquestionId withNewAnswer:nil];
        } else {
            [self removeSubquestionsforQuestion:subquestionId withNewAnswers:nil];
        }
    }
    
    [self.questionAndAnswers removeObjectsForKeys:subquestionIds];
}

@end
