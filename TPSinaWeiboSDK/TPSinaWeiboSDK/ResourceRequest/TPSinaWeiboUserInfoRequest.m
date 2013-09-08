//
//  TPSinaWeiboUserInfoRequest.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-8.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboUserInfoRequest.h"

@implementation TPSinaWeiboUserInfoRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"GET";
        self.urlPostfix = @"users/show.json";
        self.uid = ((TPSinaWeiboAccountService *)[TPSinaWeiboAccountService sharedInstance]).userID; //默认当前用户
    }
    return self;
}

-(NSDictionary *)requestParamsDictionary
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if(self.accessToken)
        [params setObject:self.accessToken forKey:@"access_token"];
    
    if(self.uid)
       [params setObject:self.uid forKey:@"uid"];
    
    return params;
}

-(id)decodeResponseJsonObject:(NSData *)jsonObject
{
    // 解析JSON
    NSError *error = nil;
    NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonObject options:NSJSONReadingMutableContainers error:&error];
    
    return responseDic;
}

@end
