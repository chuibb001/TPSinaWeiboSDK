//
//  TPSinaWeiboCommentsRequest.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-9.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboCommentsRequest.h"

@implementation TPSinaWeiboCommentsRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"GET";
        self.urlPostfix = @"comments/show.json";
        self.weiboId = @"3620577140624625"; // for test
        self.count = @"50"; // 默认50条
        self.page = @"1"; // 默认第1页
    }
    return self;
}

-(NSDictionary *)requestParamsDictionary
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if(self.accessToken)
        [params setObject:self.accessToken forKey:@"access_token"];
    
    if(self.weiboId)
        [params setObject:self.weiboId forKey:@"id"];
    
    if(self.count)
        [params setObject:self.count forKey:@"count"];
    
    if(self.page)
        [params setObject:self.page forKey:@"page"];
    
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
