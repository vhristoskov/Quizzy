//
//  DataManager.m
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <sqlite3.h>
#import "DataManager.h"
#import "Question.h"
#import "UserChoice.h"

static DataManager *defaultDataManager = nil;

@interface DataManager () {
    sqlite3 *database;
}

- (void)initDB;
- (void)closeDB;

@end

@implementation DataManager

@synthesize userChoices;

+ (DataManager *)defaultDataManager {
    if (!defaultDataManager) {
        @synchronized(self) {
            if (!defaultDataManager) {
                defaultDataManager = [[super allocWithZone:NULL] init];
            }
        }
    }
    return defaultDataManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self defaultDataManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (defaultDataManager) {
        return defaultDataManager;
    }
    self = [super init];
    
    userChoices = [[NSMutableArray alloc] init];
    [self initDB];
    
    return self;
}

- (void)initDB {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QuizData" ofType:@"sqlite"];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        NSLog(@"Opening database");
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database: %s'.", sqlite3_errmsg(database));
    }
}

- (void)closeDB {
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database: ‘%s’.", sqlite3_errmsg(database));
    }
}

- (NSArray *)fetchMainQuestions {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    const char *sqlRequest = "SELECT question.QuestionText, question.QuestionType, section.SectionText, question.QuestionId FROM Question join Section on Question.QuestionSectionId = section.sectionId where question.QuestionParentId is null";
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(database, sqlRequest, -1, &statement, NULL);
    if (sqlResult == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Question *question = [[Question alloc] init];
            
            char *questionText = (char *)sqlite3_column_text(statement, 0);
            question.questionText = (questionText) ? [NSString stringWithUTF8String:questionText] : @"";
            question.questionType = sqlite3_column_int(statement, 1);
            char *questionSection = (char *)sqlite3_column_text(statement, 2);
            question.questionSection = (questionSection) ? [NSString stringWithUTF8String:questionSection] : @"";
            question.questionId = sqlite3_column_int(statement, 3);
            
            [result addObject:question];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"Problem with the database:");
        NSLog(@"%d", sqlResult);
    }
    
    return result;
}

- (NSArray *)fetchSubquestionsOfQuestion:(Question *)question forAnswer:(Answer *)answer {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    sqlite3_stmt *statement;
    const char *sqlRequest = "SELECT question.QuestionText, question.QuestionType, section.SectionText, question.QuestionId FROM Question join Section on Question.QuestionSectionId = section.sectionId join QuestionParent on QuestionParent.ParentId = question.QuestionParentId where (question.QuestionId = ?) and QuestionParent.AnswerId = ?";
    
    int sqlResult = sqlite3_prepare_v2(database, sqlRequest, -1, &statement, NULL);
    
    if(sqlResult == SQLITE_OK) {
        sqlite3_bind_int(statement,1,question.questionId);
        sqlite3_bind_int(statement,2,answer.answerId);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Question *question = [[Question alloc] init];
            
            char *questionText = (char *)sqlite3_column_text(statement, 0);
            question.questionText = (questionText) ? [NSString stringWithUTF8String:questionText] : @"";
            question.questionType = sqlite3_column_int(statement, 1);
            char *questionSection = (char *)sqlite3_column_text(statement, 2);
            question.questionSection = (questionSection) ? [NSString stringWithUTF8String:questionSection] : @"";
            question.questionId = sqlite3_column_int(statement, 3);
            
            [result addObject:question];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"Problem with the database:");
        NSLog(@"%d", sqlResult);
    }
    
    return result;
}

- (NSArray *)fetchAnswersForQuestion:(Question *)question {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    const char *sqlRequest = "SELECT answer.AnswerText, answer.AnswerId FROM Answer join QuestionParent on QuestionParent.AnswerId = answer.AnswerId join Question on Question.QuestionId = QuestionParent.QuestionId where (question.QuestionId = ?)";
    
    int sqlResult = sqlite3_prepare_v2(database, sqlRequest, -1, &statement, NULL);
    
    if(sqlResult == SQLITE_OK) {
        sqlite3_bind_int(statement,1,question.questionId);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Answer *answer = [[Answer alloc] init];
            
            char *answerText = (char *)sqlite3_column_text(statement, 0);
            answer.answerText = (answerText) ? [NSString stringWithUTF8String:answerText] : @"";
            answer.answerId = sqlite3_column_int(statement, 1);
            
            [result addObject:answer];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"Problem with the database:");
        NSLog(@"%d", sqlResult);
    }
    
    return result;
}

- (NSArray *)fetchSections {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    const char *sqlRequest = "SELECT section.sectionText FROM Section";
    
    int sqlResult = sqlite3_prepare_v2(database, sqlRequest, -1, &statement, NULL);
    
    if(sqlResult == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *section = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            [result addObject:section];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"Problem with the database:");
        NSLog(@"%d", sqlResult);
    }
    
    return result;    
}


- (NSArray *)categorizeQuestions:(NSArray *)questions{
    NSMutableArray *categorizedQuestions = [[NSMutableArray alloc]init];
    NSArray *sections = [self fetchSections];
    
    for (NSString *section in sections) {
        NSArray *values = [NSArray arrayWithObjects:section, [NSMutableArray array], nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sectionTitle", @"questions", nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [categorizedQuestions addObject:dict];
    }
    
    for (Question *q in questions) {
        for(NSDictionary *dict in categorizedQuestions){
            if([[dict valueForKey:@"sectionTitle"] isEqualToString:q.questionSection]){
                [((NSMutableArray *)[dict valueForKey:@"questions"]) addObject:q];
            }
        }
    }
    
    return categorizedQuestions;
}

- (void)addChoice:(NSString *)answerText withQuestion:(NSString *)questionText {
    UserChoice *userChoice = [[UserChoice alloc] init];
    userChoice.answer = answerText;
    userChoice.question = questionText;
    [self.userChoices addObject:userChoice];
}

@end
