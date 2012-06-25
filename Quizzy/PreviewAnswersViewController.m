
//
//  PreviewAnswersViewController.m
//  Quizzy
//
//  Created by Vladimir Tsenev on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "PreviewAnswersViewController.h"
#import "UserResponse.h"

@interface PreviewAnswersViewController ()

@end

@implementation PreviewAnswersViewController
@synthesize tableData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Answer Preview"];
    
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    [self.navigationItem setLeftBarButtonItem:goBackBtn];

//    self.tableView.backgroundColor = [UIColor g];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setTableData:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2*[self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UIImageView *balloonView;
    UILabel *label;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        balloonView.tag = 1;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2;
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.font = [UIFont systemFontOfSize:14.0];
        
        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        message.tag = 0;
        [message addSubview:balloonView];
        [message addSubview:label];
        [cell.contentView addSubview:message];
        
        
        
    }
    else
    {
        balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
        label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
    }

    UserResponse *userResponse;
    NSString *questionText;
    NSString *answerText;
    
    CGSize questionTextSize; 
    CGSize answerTextSize; 

    UIImage *balloon;
//    NSLog(@"%@, ")
    //Answer Cell right aligned
    if(indexPath.row % 2 == 0)
    {
        userResponse = [self.tableData objectAtIndex:[indexPath row]/2];
        questionText = userResponse.question;
        
        questionTextSize = [questionText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        balloonView.frame = balloonView.frame = CGRectMake(0.0, 4.0, questionTextSize.width + 28, questionTextSize.height + 15);
        balloon = [[UIImage imageNamed:@"aqua_2.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        label.frame = CGRectMake(16, 10, questionTextSize.width + 5, questionTextSize.height);
        label.text = questionText;
    }
    else
    {

        userResponse = [self.tableData objectAtIndex:[indexPath row]/2];
        answerText = userResponse.answer;
        
        answerTextSize =[answerText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        balloonView.frame = CGRectMake(320.0f - (answerTextSize.width + 28.0f), 4.0f, answerTextSize.width + 28.0f, answerTextSize.height + 15.0f);
        balloon = [[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        label.frame = CGRectMake(307.0f - (answerTextSize.width + 5.0f), 10.0f, answerTextSize.width + 5.0f, answerTextSize.height);
        label.text = answerText;
    }

    balloonView.image = balloon;

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserResponse *userResponse;
    NSString *questionText;
    NSString *answerText;
    
    CGSize questionTextSize; 
    CGSize answerTextSize; 
    

    if(indexPath.row % 2 == 0)
    {
        userResponse = [self.tableData objectAtIndex:[indexPath row]/2];
        questionText = userResponse.question;
        
        questionTextSize = [questionText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        return questionTextSize.height + 15;
    }
    else
    {
        
        userResponse = [self.tableData objectAtIndex:[indexPath row]/2];
        answerText = userResponse.answer;
        
        answerTextSize =[answerText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        return answerTextSize.height + 15;
    }

}

@end
