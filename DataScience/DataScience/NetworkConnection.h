//
//  NetworkConnection.h
//  DataScience
//
//  Created by Admin on 6/7/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkConnection_Delegate <NSObject>

- (void)networkRequestDidSuccessWithResponse:(id)response;
- (void)networkRequestDidFailedWithResponse:(id)response andError:(NSError*)error;

@end

@interface NetworkConnection : NSObject

@property (nonatomic, assign) id delegate;

-(void)networkRequestForData;

-(id)initWithDelegate:(id)delegate_;

@end
