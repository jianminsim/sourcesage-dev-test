//
//  QuestionsTableViewController.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "QuestionsTableViewController.h"
#import "QuestionsViewModel.h"
#import "AppConstants.h"
#import "Question.h"
#import "User.h"
#import "PostQuestionViewController.h"
#import "QuestionDetailViewController.h"
#import "AppDelegate.h"
#import "AFMInfoBanner.h"

@interface QuestionsTableViewController () <PostQuestionViewControllerDelegate>
@property (nonatomic, strong, readwrite) QuestionsViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *questions;
@end

@implementation QuestionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[QuestionsViewModel alloc] init];
    self.viewModel.title = [AppDelegate appDelegate].currentUser.userName;
    
    self.title = self.viewModel.title;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(postAQuestionButtonPressed:)];
    
    self.questions = [NSMutableArray array];
    //set up tableview
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [AFMInfoBanner showWithText:NSLocalizedString(@"Loading ...", @"") style:AFMInfoBannerStyleInfo animated:YES];
    __weak QuestionsTableViewController *weakSelf = self;
    [self.viewModel.dataSetChangedSignal subscribeNext:^(NSMutableArray *questions) {
        [weakSelf setQuestions:questions];
        [weakSelf.tableView reloadData];
        [AFMInfoBanner hideAll];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button actions

- (void)postAQuestionButtonPressed:(id)sender {
    PostQuestionViewController *postQuestionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostAQuestionVC"];
    postQuestionVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:postQuestionVC];
    [self presentViewController:navVC animated:YES completion:nil];
}


#pragma mark - PostQuestionViewControllerDelegate

- (void)postQuestionViewController:(PostQuestionViewController *)vc didPostAQuestion:(Question *)question {
    [self.viewModel postQuestion:question];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"questionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    Question *question = [self.questions objectAtIndex:indexPath.row];
    cell.textLabel.text = question.content;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Asked by: %@", question.user.userName];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Question *question = [self.questions objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showQuestionDetailSegue" sender:question];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showQuestionDetailSegue"]) {
        QuestionDetailViewController *questionDetailVC = segue.destinationViewController;
        questionDetailVC.question = sender;
    }
}

@end
