//
//  PostQuestionViewController.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "PostQuestionViewController.h"
#import "AppConstants.h"
#import "Question.h"
#import "AppDelegate.h"


@interface PostQuestionViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation PostQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupNavigationItems {
    self.title = NSLocalizedString(@"Post A Question", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(didCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didDonePostAQuestion:)];
}


#pragma mark - button actions


- (void)didDonePostAQuestion:(id)sender {
    if (self.delegate) {
        Question *question = [[Question alloc] init];
        question.content = self.contentTextView.text;
        question.user = [AppDelegate appDelegate].currentUser;
        [self.delegate postQuestionViewController:self didPostAQuestion:question];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
