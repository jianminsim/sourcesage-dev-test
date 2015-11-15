//
//  Question.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "Question.h"
#import "User.h"

@implementation Question

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"user": @"user",
             @"content": @"content",
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

+ (Question *)fromJSONDictionary:(NSDictionary *)dict {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dict error:nil];
}

+ (NSDictionary *)toDictionaryFromObject:(Question *)question {
    return [MTLJSONAdapter JSONDictionaryFromModel:question error:nil];
}

@end
