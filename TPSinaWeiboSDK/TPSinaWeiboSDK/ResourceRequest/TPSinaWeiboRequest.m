//
//  TPSinaWeiboRequest.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboRequest.h"

@implementation TPSinaWeiboRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.accessToken = ((TPSinaWeiboAccountService *)[TPSinaWeiboAccountService sharedInstance]).accessToken;
        self.httpMethod = @"POST";
        self.urlPostfix = nil;
    }
    return self;
}

-(void)request
{
    if(!self.accessToken)
    {
        return ;
    }
    
    if(!self.urlPostfix)
    {
        return ;
    }
    
    NSString *fullURL = [kSinaWeiboSDKAPIDomain stringByAppendingString:self.urlPostfix];
    
    if([self.httpMethod isEqualToString:@"GET"]) // GET的参数跟在URL后面
        fullURL = [TPSinaWeiboCommonFuction serializeURL:fullURL
                                                           params:[self requestParamsDictionary] httpMethod:self.httpMethod];
    
    // 请求数据
    [[TPNetworkManager sharedInstance] requestWithURL:fullURL httpMethod:self.httpMethod params:[self requestParamsDictionary] completionHandler:^(NSData *responseData,int httpStatusCode)
     {
         if(httpStatusCode == 200)
         {
             
             id decodedResponseData = [self decodeResponseJsonObject:responseData]; // 解析JSON
             
             NSLog(@"解析JSON后:%@",decodedResponseData);
         }
         else
         {
             NSLog(@"请求资源失败 %d",httpStatusCode);
         }
         
     }];
}

#pragma mark subClassHooks
-(NSDictionary *)requestParamsDictionary
{
    return nil;
}

-(id)decodeResponseJsonObject:(NSData *)jsonObject
{
    return nil;
}
@end
