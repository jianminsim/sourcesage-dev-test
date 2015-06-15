//
//  NetworkConnection.m
//  DataScience
//
//  Created by Admin on 6/7/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import "NetworkConnection.h"
#import "AppDelegate.h"

#define BASE_URL @"https://data.gov.in/api/datastore/resource.json?resource_id=9ef84268-d588-465a-a308-a864a43d0070&api-key=04a5752f5e0a26440f219aaca97ba503&filters[variety]=other&filters[district]=Kolkata&filters[state]=West%20Bengal"

@implementation NetworkConnection
{
    NSMutableData* responseData;
}

-(id)initWithDelegate:(id)delegate_
{
    self = [super init];
    if (self) {
        self.delegate  = delegate_;
    }
    return self;
}

#pragma mark - Network Request Methods
-(void)networkRequestForData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   // [params setObject:@"zone_detail" forKey:@"action"];
    
    NSString* url = [NSString stringWithFormat:@"%@",BASE_URL];
    [self requestWithUrl:url params:params httpMethod:@"GET"];
}

- (void)requestWithUrl:(NSString *)url_ params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    if (params != nil && params.count > 0) {
        NSMutableData *httpBody = [NSMutableData data];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", boundary];
        
        for (NSString *key in params) {
            NSObject *value = [params objectForKey:key];
            
            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            if ([value isKindOfClass:[NSString class]] == YES) {
                [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [httpBody appendData:[(NSString *)value dataUsingEncoding:NSUTF8StringEncoding]];
            } else if ([value isKindOfClass:[NSNumber class]] == YES) {
                [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [httpBody appendData:[[(NSNumber *)value stringValue] dataUsingEncoding:NSUTF8StringEncoding ]];
            }
            [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [urlRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
        [urlRequest setHTTPBody:httpBody];
    }
    
    [urlRequest setHTTPMethod:httpMethod];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(responseData == nil) {
        responseData = [[NSMutableData alloc] init];
    } else {
        [responseData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // NSLog(@"Response : %@",responseStr);
    if(responseStr == nil || [responseStr isKindOfClass:[NSNull class]] || [responseStr length] < 1) {
        [self.delegate networkRequestDidFailedWithResponse:nil andError:nil];

    } else {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingAllowFragments error:nil];
        if(responseDictionary == nil || [responseDictionary isKindOfClass:[NSNull class]] || ![responseDictionary isKindOfClass:[NSDictionary class]]) {
          
            [self.delegate networkRequestDidFailedWithResponse:nil andError:nil];

        } else {
            BOOL success = [[responseDictionary objectForKey:@"success"] boolValue];
            if(success) {
                NSArray* data = [responseDictionary objectForKey:@"records"];
                if(data == nil || [data isKindOfClass:[NSNull class]] || [data count] < 1) {
                    [self.delegate networkRequestDidFailedWithResponse:nil andError:nil];
                } else {
                    [self.delegate networkRequestDidSuccessWithResponse:data];
                }
            } else {
                [self.delegate networkRequestDidFailedWithResponse:nil andError:nil];
            }
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate networkRequestDidFailedWithResponse:nil andError:nil];
}

@end
