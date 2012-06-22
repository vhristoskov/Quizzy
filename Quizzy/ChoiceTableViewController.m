//
//  ChoiceTableViewController.m
//  Quizzy
//
//  Created by Victor Hristoskov on 6/22/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "ChoiceTableViewController.h"
#import "DataManager.h"

@interface ChoiceTableViewController ()

@end

@implementation ChoiceTableViewController
@synthesize delegate;
@synthesize answers;
@synthesize question;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.answers = [[DataManager defaultDataManager] fetchAnswersForQuestion:question];
    self.title = self.question.questionText;
    [self configureToolbarView];

}

- (void)viewDidUnload
{
    [self setAnswers:nil];
    [self setQuestion:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.answers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.answers objectAtIndex:indexPath.row] answerText];
    
    // Configure the cell...
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - CustomMethods

- (void)configureToolbarView{
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelChoice:)];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitChoice:)];
    
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:[NSArray arrayWithObjects:cancelButton,flexibleSpaceButton,submitButton, nil ]];
    [self.navigationController setToolbarHidden:NO];
    
}

- (void)setTitle:(NSString *)title{
    
    [super setTitle:title];
    
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 40.0)];
        
        titleView.backgroundColor = [UIColor clearColor];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor colorWithWhite:1.0   alpha:1.0];
        
        titleView.textAlignment = UITextAlignmentCenter;
        titleView.font = [UIFont boldSystemFontOfSize:17.0];    
        titleView.numberOfLines = 3;
        self.navigationItem.titleView = titleView;
    }
    
    
    titleView.text = title;
    
}

#pragma mark - Button Action Methods


-(void)cancelChoice:(id)sender{
    
}

- (void)submitChoice:(id)sender{
    
}
@end
