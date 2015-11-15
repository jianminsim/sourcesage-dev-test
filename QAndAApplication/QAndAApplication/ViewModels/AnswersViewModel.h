//
//  AnswersViewModel.h
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "BaseViewModel.h"

@class Answer;
@class Question;
@interface AnswersViewModel : BaseViewModel
@property (nonatomic, strong, readonly) NSMutableArray *answers;
@property (nonatomic, strong, readonly) RACSignal *dataSetChangedSignal;

- (instancetype)initWithQuestion:(Question *)question;


- (void)postAnswer:(Answer *)answer;
@end
