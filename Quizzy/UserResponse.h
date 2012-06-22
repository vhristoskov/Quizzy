//
//  UserResponse.h
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/22/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserResponse : NSObject

@property (nonatomic, strong) NSString *response;
@property (nonatomic) NSInteger questionLevel;

@end
