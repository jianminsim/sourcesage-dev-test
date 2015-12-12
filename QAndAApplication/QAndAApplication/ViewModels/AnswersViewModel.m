//
//  AnswersViewModel.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "AnswersViewModel.h"
#import "Question.h"
#import "Answer.h"
#import "AppConstants.h"

@interface AnswersViewModel ()
@property (nonatomic, strong, readwrite) NSMutableArray *answers;
@property (nonatomic, strong, readwrite) RACSubject *dataSetChangedSubject;
@property (nonatomic, strong, readwrite) Question *question;
@end
@implementation AnswersViewModel

- (instancetype)initWithQuestion:(Question *)question {
    self = [super init];
    
    if (self) {
        self.question = question;
        self.dataSetChangedSubject = [RACSubject subject];
        self.answers = [NSMutableArray array];
        [self setupFireBase];
    }
    
    return self;
}


- (void)setupFireBase {
    self.fireBase = [[[[Firebase alloc] initWithUrl:kFireBaseURLString]
                      childByAppendingPath:self.question.fireBaseKey]
                     childByAppendingPath:@"answers"];
    [self observeChildNodeAdded];
    [self observeDataChanges];
}


- (void)observeChildNodeAdded {
    [self.fireBase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        Answer *answer = [Answer fromJSONDictionary:snapshot.value];
        
        if (answer) {
            [self.answers insertObject:answer atIndex:0];
            [self.dataSetChangedSubject sendNext:self.answers];
        }
    }];
}


- (void)observeDataChanges {
    [self.fireBase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self.dataSetChangedSubject sendNext:self.answers];
    }];
}


- (void)postAnswer:(Answer *)answer {
    [[self.fireBase childByAutoId] setValue:[Answer toDictionaryFromObject:answer]];
}


- (RACSignal *)dataSetChangedSignal {
    return _dataSetChangedSubject;
}

@end
