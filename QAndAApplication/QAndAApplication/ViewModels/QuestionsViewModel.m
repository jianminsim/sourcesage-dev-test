//
//  QuestionsViewModel.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "QuestionsViewModel.h"
#import "Question.h"
#import "AppConstants.h"

@interface QuestionsViewModel ()
@property (nonatomic, strong, readwrite) NSMutableArray *questions;
@property (nonatomic, strong, readwrite) RACSubject *dataChangedSubject;
@end

@implementation QuestionsViewModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.questions = [NSMutableArray array];
        self.dataChangedSubject = [RACSubject subject];
        [self setupFireBase];
    }
    
    return self;
}

- (void)setupFireBase {
    self.fireBase = [[Firebase alloc] initWithUrl:kFireBaseURLString];
    [self observeChildNodeAdded];
    [self observeDataChanges];
}

- (void)observeDataChanges {
    [self.fireBase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self.dataChangedSubject sendNext:self.questions];
    }];
}

- (void)observeChildNodeAdded {
    [self.fireBase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        Question *question = [Question fromJSONDictionary:snapshot.value];
        question.fireBaseKey = snapshot.key;
        
        if (question) {
            [self.questions insertObject:question atIndex:0];
            [self.dataChangedSubject sendNext:self.questions];
        }
    }];
}

- (RACSignal *)dataSetChangedSignal {
    return _dataChangedSubject;
}

- (void)postQuestion:(Question *)question {
    [[self.fireBase childByAutoId] setValue:[Question toDictionaryFromObject:question]];
}

@end
