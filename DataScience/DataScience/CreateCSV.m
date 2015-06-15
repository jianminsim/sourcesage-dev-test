//
//  CreateCSV.m
//  DataScience
//
//  Created by Admin on 6/8/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import "CreateCSV.h"

@implementation CreateCSV

+ (NSString*)createCSVForData:(NSMutableArray*)data
{
    NSString* myCsvString = @"Commodity Name,Minimum Price(INR) - 100Kg,Maximum Price(INR)  - 100Kg,Modal price(INR) - 100Kg";
    
    if(data!=nil && data.count > 0) {
        
        for(int i=0; i<data.count;i++) {
            NSString* commodityName = [[data objectAtIndex:i] objectForKey:@"commodity"];
            NSString* minPrice = [[data objectAtIndex:i] objectForKey:@"min_price"];
            NSString* maxPrice = [[data objectAtIndex:i] objectForKey:@"max_price"];
            NSString* modalPrice = [[data objectAtIndex:i] objectForKey:@"modal_price"];
            
            if(commodityName==nil) {
                commodityName = @"";
            }
            if(minPrice==nil) {
                minPrice = @"";
            }
            if(maxPrice==nil) {
                maxPrice = @"";
            }
            if(modalPrice==nil) {
                modalPrice = @"";
            }
            
            myCsvString = [myCsvString stringByAppendingFormat:@"\n%@,%@,%@,%@",commodityName,minPrice,maxPrice,modalPrice];
        }
        
        NSString *filename=[NSString stringWithFormat:@"Commodity_Record.csv"];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePathLib = [NSString stringWithFormat:@"%@",[docDir stringByAppendingPathComponent:filename]];
        NSError* error;
        [myCsvString writeToFile:filePathLib atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if(error) {
            NSLog(@"Eror While writing CSV of Trip->> %@",error.debugDescription);
        }
        
        return filePathLib;
    }
    return nil;
}

+(void)removeTempStoredFiles
{
    /*** Removing A CSV File ***/
    NSError *error;
    NSString *filename=[NSString stringWithFormat:@"Commodity_Record.csv"];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@",[docDir stringByAppendingPathComponent:filename]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO] &&    [[NSFileManager defaultManager] isDeletableFileAtPath:filePath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
}

@end
