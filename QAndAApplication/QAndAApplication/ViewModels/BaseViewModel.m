//
//  BaseViewModel.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setupFireBase {
    //Override
}

- (void)observeChildNodeAdded {
    //Override
}

- (void)observeDataChanges {
    //Override
}

@end
