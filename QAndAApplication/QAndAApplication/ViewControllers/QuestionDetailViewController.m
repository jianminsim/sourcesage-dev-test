//
//  QuestionDetailViewController.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "AnswersViewModel.h"
#import "Answer.h"
#import "AppDelegate.h"
#import "AFMInfoBanner.h"

@interface QuestionDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) AnswersViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Question", @"");
    self.viewModel = [[AnswersViewModel alloc] initWithQuestion:self.question];
    
    [self setupNavigationItems];
    
    self.contentTextView.text = self.question.content;
    [self.contentTextView setContentOffset:CGPointZero animated:NO];
    //Setup tableview
    self.answers = [NSMutableArray array];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [AFMInfoBanner showWithText:NSLocalizedString(@"Loading ...", @"") style:AFMInfoBannerStyleInfo animated:YES];
    __weak QuestionDetailViewController *weakSelf = self;
    [self.viewModel.dataSetChangedSignal subscribeNext:^(NSMutableArray *answers) {
        weakSelf.answers = answers;
        [weakSelf.tableView reloadData];
        
        [AFMInfoBanner hideAll];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupNavigationItems {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Answer", @"")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(answerQuestionButtonPressed:)];
}


#pragma mark - button Actions

- (void)answerQuestionButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Answer", @"") message:NSLocalizedString(@"Enter your answer here", @"") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        [self postAnAnswer:textField.text];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        RAC(okAction, enabled) = [textField.rac_textSignal map:^id(NSString *value) {
            NSString *content = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            return content.length > 0 ? @(YES) : @(NO);
        }];
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)postAnAnswer:(NSString *)content {
    Answer *anwer = [[Answer alloc] init];
    anwer.content = content;
    anwer.user = [AppDelegate appDelegate].currentUser;
    
    [self.viewModel postAnswer:anwer];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.answers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"answerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Answer *answer = [self.answers objectAtIndex:indexPath.row];
    cell.textLabel.text = answer.content;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Answered by: %@", answer.user.userName];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Answers", @"");
}

@end
