//
//  Question.h
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import <Mantle/Mantle.h>

@class User;
@interface Question : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *fireBaseKey;

+ (Question *)fromJSONDictionary:(NSDictionary *)dict;
+ (NSDictionary *)toDictionaryFromObject:(Question *)question;
@end
