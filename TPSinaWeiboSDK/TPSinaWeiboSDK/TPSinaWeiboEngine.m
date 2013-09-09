//
//  TPSinaWeiboEngine.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboEngine.h"

@implementation TPSinaWeiboEngine

static TPSinaWeiboEngine *instance = nil;

#pragma mark init
+(id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance)
        {
            instance = [[TPSinaWeiboEngine alloc] init];
        }
    });
    return instance;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.accountServeice = [TPSinaWeiboAccountService sharedInstance];
    }
    return self;
}
- (void)Login
{
    [self.accountServeice Login];
}

- (void)getUserInfo
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUserInfo];
    [request request];
}
- (void)getUserTimeline
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUserTimeline];
    [request request];
}
- (void)getFriends
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeFriends];
    [request request];
}
- (void)getComments
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeComments];
    [request request];
}
- (void)postStatus
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUpdateStatus];
    [request request];
}
- (void)postImageStatus
{
    TPSinaWeiboRequest * request = [TPSinaWeiboRequestFactory requestWithType:TPSinaWeiboRequestTypeUploadStatus];
    [request request];
}
@end
