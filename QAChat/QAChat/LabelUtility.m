//
//  MaxisViewUtility.m
//  MyMaxis
//
//  Created by Amit on 9/9/14.
//  Copyright (c) 2014 Maxis Mobile Services Sdn Bhd. All rights reserved.
//

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "LabelUtility.h"

@implementation LabelUtility

+ (CGFloat)heightWithLabel:(UILabel *)label
{
    return [LabelUtility findHeightForText:label.text havingWidth:label.frame.size.width andFont:label.font];
}

+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize+4;
    CGFloat width = widthValue;
    if (text) {
        CGSize textSize = { width, CGFLOAT_MAX };       //Width and height of text area
        CGSize size;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            //iOS 7
            CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            size = CGSizeMake(frame.size.width, frame.size.height+1);
        }
        else
        {
            //iOS 6.0
            size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        result = MAX(size.height, result); //At least one row
    }
    return result;
}

+ (CGFloat)heightWithLabel:(UILabel *)label width:(CGFloat)width
{
    if ([UIDevice currentDevice].systemVersion.integerValue < 7) {
        CGSize textSize = [label.text sizeWithFont:label.font
                                 constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        return textSize.height;
    }
    
    if (label.font == nil) {
        return 0;
    }
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:label.font forKey:NSFontAttributeName];
    
    NSAttributedString *attrobutedText = [[NSAttributedString alloc] initWithString:label.text attributes:attributes];
    
    CGRect rect = [attrobutedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    // [attributes release];
    // [attrobutedText release];
    return ceilf(size.height);
}


@end
