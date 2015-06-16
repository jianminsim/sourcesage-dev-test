//
//  MaxisViewUtility.h
//  MyMaxis
//
//  Created by Amit on 9/9/14.
//  Copyright (c) 2014 Maxis Mobile Services Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LabelUtility : NSObject

+ (CGFloat)heightWithLabel:(UILabel *)label;
+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

@end
