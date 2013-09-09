//
//  TPSinaWeiboUserTimelineRequest.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboUserTimelineRequest.h"

@implementation TPSinaWeiboUserTimelineRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"GET";
        self.urlPostfix = @"statuses/user_timeline.json";
        self.uid = ((TPSinaWeiboAccountService *)[TPSinaWeiboAccountService sharedInstance]).userID; // 默认当前用户
        self.page = @"1"; // 默认第一页
        self.count = @"50"; // 默认每页50条
        self.trimUser = @"1";
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
    
    if(self.count)
        [params setObject:self.count forKey:@"count"];
    
    if(self.page)
        [params setObject:self.page forKey:@"page"];
    
    if(self.sinceId)
        [params setObject:self.sinceId forKey:@"since_id"];
    
    if(self.trimUser)
        [params setObject:self.trimUser forKey:@"trim_user"];
    
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
