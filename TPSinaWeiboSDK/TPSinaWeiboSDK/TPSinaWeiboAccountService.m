//
//  TPSinaWeiboAccountService.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboAccountService.h"

@implementation TPSinaWeiboAccountService

static TPSinaWeiboAccountService * accountService = nil;

+(id)sharedInstance
{
    if (!accountService) {
        accountService = [[TPSinaWeiboAccountService alloc] init];
    }
    return accountService;
}
- (id)init
{
    self = [self initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI ssoCallbackScheme:nil];
    if (self) {
        // 读取存储的账号登录信息 ( weak login )
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:kTPSinaWeiboEngineAuthDataKey];
        if ([sinaweiboInfo objectForKey:kTPSinaWeiboEngineAccessTokenKey] && [sinaweiboInfo objectForKey:kTPSinaWeiboEngineExpirationDateKey] && [sinaweiboInfo objectForKey:kTPSinaWeiboEngineUserIDKey])
        {
            accountService.accessToken = [sinaweiboInfo objectForKey:kTPSinaWeiboEngineAccessTokenKey];
            accountService.expirationDate = [sinaweiboInfo objectForKey:kTPSinaWeiboEngineExpirationDateKey];
            accountService.userID = [sinaweiboInfo objectForKey:kTPSinaWeiboEngineUserIDKey];
        }
    }
    return self;
}
- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
{
    if ((self = [super init]))
    {
        self.appKey = appKey;
        self.appSecret = appSecrect;
        self.appRedirectURI = appRedirectURI;
        
        if (!_ssoCallbackScheme)
        {
            _ssoCallbackScheme = [NSString stringWithFormat:@"sinaweibosso.%@://", self.appKey];
        }
        self.ssoCallbackScheme = ssoCallbackScheme;
        
    }
    
    return self;
}

#pragma mark - Validation
/*
   判断是否登录
*/
- (BOOL)isLoggedIn
{
    return _userID && _accessToken && _expirationDate;
}

/*
   判断登录是否过期
*/
- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:_expirationDate] == NSOrderedDescending);
}

/*
   判断登录是否有效，当已登录并且登录未过期时为有效状态
*/
- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

#pragma mark - LogIn / LogOut
/*
    登录入口
*/
- (void)Login
{
    if ([self isAuthValid])
    {
        return ;
    }
    
    [self removeAuthData];
    
    _ssoLoggingIn = NO;
    
    // open sina weibo app
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
        [device isMultitaskingSupported])
    {
        NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                self.appKey, @"client_id",
                                self.appRedirectURI, @"redirect_uri",
                                self.ssoCallbackScheme, @"callback_uri", nil];
        
        // 先用iPad微博打开
        NSString *appAuthBaseURL = kSinaWeiboAppAuthURL_iPad;
        if ([self SinaWeiboIsDeviceIPad])
        {
            NSString *appAuthURL = [TPSinaWeiboCommonFuction serializeURL:appAuthBaseURL
                                                           params:params httpMethod:@"GET"];
            _ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
        }
        
        // 在用iPhone微博打开
        if (!_ssoLoggingIn)
        {
            appAuthBaseURL = kSinaWeiboAppAuthURL_iPhone;
            NSString *appAuthURL = [TPSinaWeiboCommonFuction serializeURL:appAuthBaseURL
                                                           params:params httpMethod:@"GET"];
            _ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthURL]];
            
        }
    }
    
    if (!_ssoLoggingIn)
    {
        // open authorize view
        
        NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                self.appKey, @"client_id",
                                @"code", @"response_type",
                                self.appRedirectURI, @"redirect_uri",
                                @"mobile", @"display", nil];
        
        SinaWeiboAuthorizeView *authorizeView = [[SinaWeiboAuthorizeView alloc] initWithAuthParams:params delegate:self];
        [authorizeView show];
    }
}

/*
   退出方法，需要退出时直接调用此方法
*/
- (void)Logout
{
    [self removeAuthData];
}

/*
   清空认证信息
*/
- (void)removeAuthData
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.weibo.cn"]];
    
    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
}

#pragma mark - SinaWeiboAuthorizeView Delegate

- (void)authorizeView:(SinaWeiboAuthorizeView *)authView didRecieveAuthorizationCode:(NSString *)code
{
    [self requestAccessTokenWithAuthorizationCode:code];
}

- (void)authorizeView:(SinaWeiboAuthorizeView *)authView didFailWithErrorInfo:(NSDictionary *)errorInfo
{
    //[self logInDidFailWithErrorInfo:errorInfo];
}

- (void)authorizeViewDidCancel:(SinaWeiboAuthorizeView *)authView
{
    //[self logInDidCancel];
}

#pragma mark private
- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code
{
    NSDictionary *params = @{@"client_id":self.appKey,@"client_secret":self.appSecret,@"grant_type":@"authorization_code",@"redirect_uri":self.appRedirectURI,@"code":code};
    
    [[TPNetworkManager sharedInstance] requestWithURL:kSinaWeiboWebAccessTokenURL httpMethod:@"POST" params:params completionHandler:^(NSData *responseData,int httpStatusCode)
     {
         if(httpStatusCode == 200)
         {

             [self handleResponseData:responseData];
             
             self.loginResultHandler(TPSinaWeiboAccountLoginDidSuccess);  // 登录成功回调
             
         }
         else
         {
             self.loginResultHandler(TPSinaWeiboAccountLoginDidFail);  // 登录失败回调
             NSLog(@"请求accessToken失败");
         }
         
     }];
}

-(void) handleResponseData:(NSData *)responseData
{
    // 解析JSON
    NSError *error = nil;
    NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *access_token = [responseDic objectForKey:@"access_token"];
    NSString *uid = [responseDic objectForKey:@"uid"];
    NSString *remind_in = [responseDic objectForKey:@"remind_in"];
    NSString *refresh_token = [responseDic objectForKey:@"refresh_token"];
    if (access_token && uid)
    {
        if (remind_in != nil)
        {
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        self.accessToken = access_token;
        self.userID = uid;
        self.refreshToken = refresh_token;
        
        [self storeAuthDataToUserDefaults];
    }
}

- (void)logInDidFailWithErrorInfo:(NSDictionary *)errorInfo
{
    NSString *error_code = [errorInfo objectForKey:@"error_code"];
    if ([error_code isEqualToString:@"21330"])
    {
        //[self logInDidCancel];
    }
    else
    {
        NSString *error_description = [errorInfo objectForKey:@"error_description"];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  errorInfo, @"error",
                                  error_description, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain
                                             code:[error_code intValue]
                                         userInfo:userInfo];
        
        self.loginResultHandler(TPSinaWeiboAccountLoginDidFail);  // 登录失败回调
    }
}
- (void)removeAuthDataFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTPSinaWeiboEngineAuthDataKey];
}

- (void)storeAuthDataToUserDefaults
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.accessToken, kTPSinaWeiboEngineAccessTokenKey,
                              self.expirationDate, kTPSinaWeiboEngineExpirationDateKey,
                              self.userID, kTPSinaWeiboEngineUserIDKey,
                              self.refreshToken, kTPSinaWeiboEngineRefreshTokenKey, nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:kTPSinaWeiboEngineAuthDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) SinaWeiboIsDeviceIPad
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
#endif
    return NO;
}

@end
