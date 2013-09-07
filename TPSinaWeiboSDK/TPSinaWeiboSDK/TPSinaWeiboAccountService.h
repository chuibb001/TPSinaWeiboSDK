//
//  TPSinaWeiboAccountService.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboCommonFuction.h"
#import "TPSinaWeiboConst.h"
#import "SinaWeiboAuthorizeView.h"
#import "TPNetworkManager.h"

@interface TPSinaWeiboAccountService : NSObject<SinaWeiboAuthorizeViewDelegate>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSDate   *expirationDate;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *ssoCallbackScheme;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *appRedirectURI;
@property (nonatomic, assign) BOOL  ssoLoggingIn;

+(id)sharedInstance;
-(void)Login;
-(void)Logout;

@end
