//
//  CreateCSV.h
//  DataScience
//
//  Created by Admin on 6/8/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateCSV : NSObject

+ (NSString*)createCSVForData:(id)data;
+ (void)removeTempStoredFiles;
@end
