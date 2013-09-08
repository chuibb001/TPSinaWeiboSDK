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

-(void)requestWithCompletionHandler:(TPSinaWeiboRequestHandler)handler
{
    if(!self.accessToken)
    {
        handler(nil,TPSinaWeiboRequestErrorCodeAccessTokenNeeded);
        return ;
    }
    
    if(!self.urlPostfix)
    {
        handler(nil,TPSinaWeiboRequestErrorCodeURLIncompleted);
        return ;
    }
    
    NSString *fullURL = [kSinaWeiboSDKAPIDomain stringByAppendingString:self.urlPostfix];
    
    fullURL = [TPSinaWeiboCommonFuction serializeURL:fullURL
                                                           params:[self requestParamsDictionary] httpMethod:self.httpMethod];
    
    // 请求数据
    [[TPNetworkManager sharedInstance] requestWithURL:fullURL httpMethod:self.httpMethod params:[self requestParamsDictionary] completionHandler:^(NSData *responseData,int httpStatusCode)
     {
         if(httpStatusCode == 200)
         {
             
             id decodedResponseData = [self decodeResponseJsonObject:responseData]; // 解析JSON
             
             handler(decodedResponseData,TPSinaWeiboRequestErrorCodeNone);  // 成功回调
             
         }
         else
         {
             handler(nil,TPSinaWeiboRequestErrorCodeFailToFetch);  // 失败回调
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
