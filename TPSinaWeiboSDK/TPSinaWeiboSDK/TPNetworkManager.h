//
//  TPNetworkManager.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef void(^TPNetworkManagerHandler)(NSData *responseData,int httpStatusCode);

@interface TPNetworkManager : NSObject

+(id)sharedInstance;
-(void)requestWithURL:(NSString *)urlString httpMethod:(NSString *)httpMethod params:(NSDictionary *)params completionHandler:(TPNetworkManagerHandler)handler;

@end
