//
//  TPSinaWeiboRequest.h
//  TPSinaWeiboSDK

//  请求对象的基类

//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboAccountService.h"

typedef enum
{
    TPSinaWeiboRequestErrorCodeNone = 0,            // 成功
    TPSinaWeiboRequestErrorCodeAccessTokenNeeded,   // 需要AccessToken授权
    TPSinaWeiboRequestErrorCodeURLIncompleted,      // URL地址不完整
    TPSinaWeiboRequestErrorCodeFailToFetch          // 数据访问失败
}
TPSinaWeiboRequestErrorCode;

typedef void (^TPSinaWeiboRequestHandler)(id responseData , TPSinaWeiboRequestErrorCode errorCode);

@interface TPSinaWeiboRequest : NSObject

// 以下三个是必填参数
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *urlPostfix;
@property (nonatomic,strong) NSString *httpMethod;

-(void)requestWithCompletionHandler:(TPSinaWeiboRequestHandler)handler;

@end

// 子类实现
@interface TPSinaWeiboRequest(SubclassingHooks)

-(NSDictionary *)requestParamsDictionary;

-(id)decodeResponseJsonObject:(NSData *)jsonObject;

@end