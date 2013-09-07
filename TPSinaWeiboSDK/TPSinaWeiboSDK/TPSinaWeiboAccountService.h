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

typedef enum
{
    TPSinaWeiboAccountLoginDidSuccess = 0,
    TPSinaWeiboAccountLoginDidFail
}
TPSinaWeiboAccountStatus;

typedef void(^TPSinaWeiboAccountServiceHanlder)(TPSinaWeiboAccountStatus status);

@interface TPSinaWeiboAccountService : NSObject<SinaWeiboAuthorizeViewDelegate>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate   *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *ssoCallbackScheme;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;
@property (nonatomic, strong) NSString *appRedirectURI;
@property (nonatomic, assign) BOOL  ssoLoggingIn;
@property (nonatomic, assign) TPSinaWeiboAccountServiceHanlder loginResultHandler;

+(id)sharedInstance;
-(void)Login;
-(void)Logout;

@end
