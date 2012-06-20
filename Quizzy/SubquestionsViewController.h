//
//  SubquestionsViewController.h
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/20/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubquestionsViewController : UITableViewController

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSString *previousQuestion;

@end
