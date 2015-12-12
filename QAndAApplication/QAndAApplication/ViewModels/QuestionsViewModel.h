//
//  QuestionsViewModel.h
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@class Question;
@interface QuestionsViewModel : BaseViewModel
@property (nonatomic, strong, readonly) NSMutableArray *questions;
@property (nonatomic, strong, readonly) RACSignal *dataSetChangedSignal;


- (void)postQuestion:(Question *)question;

@end
