//
//  TPSinaWeiboEngine.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboAccountService.h"

@interface TPSinaWeiboEngine : NSObject

@property (nonatomic, strong) TPSinaWeiboAccountService *accountServeice;



//    返回单例
+ (id)sharedInstance;

//    登录
- (void)Login;

//    登出
- (void)Logout;

@end
