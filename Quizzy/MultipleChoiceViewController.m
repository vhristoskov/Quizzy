//
//  MultipleChoiceViewController.m
//  Quizzy
//
//  Created by Victor Hristoskov on 6/21/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "MultipleChoiceViewController.h"
#import "Answer.h"
#import "DataManager.h"

@interface MultipleChoiceViewController ()
@property(strong, nonatomic) NSArray *answers;
@property(strong, nonatomic) NSMutableArray *choosenAnswers;

-(IBAction)cancelMultipleChoice:(id)sender;
-(IBAction)submitMultipleChoice:(id)sender;
- (void)configureToolbarView;

@end

@implementation MultipleChoiceViewController
@synthesize question;
@synthesize answers;
@synthesize delegate;
@synthesize choosenAnswers;

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
    self.choosenAnswers = [NSMutableArray array];
    self.answers = [[DataManager defaultDataManager] fetchAnswersForQuestion:question];
    self.title = self.question.questionText;
    [self configureToolbarView];
       
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setAnswers:nil];
    [self setQuestion:nil];
    [self setDelegate:nil];
    [self setChoosenAnswers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    
    UserChoices *userChoices = [DataManager defaultDataManager].userChoices;
    NSNumber *questionId = [NSNumber numberWithInt:self.question.questionId];

    BOOL isQuestionAnswered = [ userChoices questionIsAnswered:questionId];
    
    if(isQuestionAnswered){
        NSArray* previousAnswers = [userChoices fetchAnswersToMultipleChoiceQuestion:questionId];

        NSIndexPath *answerIndexPath;
        for (Answer *answ in previousAnswers) {
            for (int i = 0; i< self.answers.count; ++i) {
                Answer* currAnswer = [self.answers objectAtIndex:i];
                if([currAnswer.answerText isEqualToString:answ.answerText]){
                    answerIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView selectRowAtIndexPath:answerIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self.tableView cellForRowAtIndexPath:answerIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                    [self.choosenAnswers addObject:currAnswer];
                    break;
                }
            
            }
        }
    }  

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.choosenAnswers removeObject:[self.answers objectAtIndex:indexPath.row]];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    NSLog(@"%@", self.choosenAnswers);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Answer *choosenAnswer = [self.answers objectAtIndex:indexPath.row];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.choosenAnswers addObject:choosenAnswer];
    NSLog(@"%@", self.choosenAnswers);
}


#pragma mark - CustomMethods

- (void)configureToolbarView{
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelMultipleChoice:)];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitMultipleChoice:)];
    
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

- (void)cancelMultipleChoice:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)submitMultipleChoice:(id)sender{
    
    NSArray *subquestions = [[DataManager defaultDataManager] fetchSubquestionsOfQuestion:self.question forAnswers:self.choosenAnswers];

    if([self.delegate respondsToSelector:@selector(didSubmitAnswer:withSubquestions:forQuestion:)]){
        [self.delegate didSubmitAnswer:self.choosenAnswers withSubquestions:subquestions forQuestion:self.question];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
