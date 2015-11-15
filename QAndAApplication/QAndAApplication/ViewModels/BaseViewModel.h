//
//  BaseViewModel.h
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Firebase/Firebase.h>

@interface BaseViewModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Firebase *fireBase;
@end
@interface BaseViewModel (FireBase)
- (void)setupFireBase;
- (void)observeDataChanges;
- (void)observeChildNodeAdded;
@end
