//
//  PostQuestionViewController.h
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostQuestionViewController;
@class Question;
@protocol PostQuestionViewControllerDelegate <NSObject>

- (void)postQuestionViewController:(PostQuestionViewController *)vc didPostAQuestion:(Question *)question;

@end

@interface PostQuestionViewController : UIViewController
@property (nonatomic, weak) id<PostQuestionViewControllerDelegate> delegate;
@end
