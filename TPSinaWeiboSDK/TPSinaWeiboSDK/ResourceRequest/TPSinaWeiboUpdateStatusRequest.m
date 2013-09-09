//
//  TPSinaWeiboUpdateStatusRequest.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboUpdateStatusRequest.h"

@implementation TPSinaWeiboUpdateStatusRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"POST";
        self.urlPostfix = @"statuses/update.json";
        self.status = @"test";
        self.latitude = nil;
        self.longitude = nil;
    }
    return self;
}

-(NSDictionary *)requestParamsDictionary
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if(self.accessToken)
        [params setObject:self.accessToken forKey:@"access_token"];
    
    if(self.status)
        [params setObject:self.status forKey:@"status"];
    
    if(self.latitude)
        [params setObject:self.latitude forKey:@"lat"];
    
    if(self.longitude)
        [params setObject:self.longitude forKey:@"long"];
      
    return params;
}

-(id)decodeResponseJsonObject:(NSData *)jsonObject
{
    // 解析JSON
    NSError *error = nil;
    NSMutableDictionary *responsedic = [NSJSONSerialization JSONObjectWithData:jsonObject options:NSJSONReadingMutableContainers error:&error];
    
    return responsedic;
}

@end
