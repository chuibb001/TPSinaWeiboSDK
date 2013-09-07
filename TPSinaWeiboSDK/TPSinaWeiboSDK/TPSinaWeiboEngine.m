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
        self.accountServeice = [[TPSinaWeiboAccountService alloc] init];
    }
    return self;
}
- (void)Login
{
    self.accountServeice.loginResultHandler = ^(TPSinaWeiboAccountStatus status)
    {
        switch (status) {
            case TPSinaWeiboAccountLoginDidSuccess:
                NSLog(@"success");
                break;
            case TPSinaWeiboAccountLoginDidFail:
                NSLog(@"fail");
                break;
            default:
                break;
        }
    };
    
    [self.accountServeice Login];
}
@end
