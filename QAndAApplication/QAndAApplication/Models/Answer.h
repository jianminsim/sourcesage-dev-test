//
//  Answer.h
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import <Mantle/Mantle.h>

@class User;
@interface Answer : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *content;

+ (Answer *)fromJSONDictionary:(NSDictionary *)dict;


+ (NSDictionary *)toDictionaryFromObject:(Answer *)answer;
@end
