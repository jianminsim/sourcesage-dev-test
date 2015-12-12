//
//  Answer.m
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import "Answer.h"
#import "User.h"

@implementation Answer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"user": @"user",
             @"content": @"content",
             };
}


+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}


+ (Answer *)fromJSONDictionary:(NSDictionary *)dict {
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dict error:nil];
}


+ (NSDictionary *)toDictionaryFromObject:(Answer *)answer {
    return [MTLJSONAdapter JSONDictionaryFromModel:answer error:nil];
}

@end
