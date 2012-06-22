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
    
    UIBarButtonItem *sendMailBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendMail)];
    [self.navigationItem setRightBarButtonItem:sendMailBtn];
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

- (void)sendMail {
    //..
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    UserResponse *userResponse = [self.tableData objectAtIndex:[indexPath row]];
    NSString *cellText = userResponse.response;
    NSLog(@"%i - %@", userResponse.questionLevel, cellText);
    [cell.textLabel setNumberOfLines:4];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setText:cellText];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
