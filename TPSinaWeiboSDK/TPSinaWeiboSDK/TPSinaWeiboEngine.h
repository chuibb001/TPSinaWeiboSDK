//
//  TPSinaWeiboEngine.h
//  TPSinaWeiboSDK

//  接口层

//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSinaWeiboAccountService.h"
#import "TPSinaWeiboRequestFactory.h"

@interface TPSinaWeiboEngine : NSObject

@property (nonatomic, strong) TPSinaWeiboAccountService *accountServeice;

@property (nonatomic, strong) NSString *const TPSinaWeiboEngineLoginDidSuccessNotification;

/**
 *  @brief 单例
 */
+ (id)sharedInstance;

/**
 *  @brief 登陆接口,会调用本地新浪微博客户端或网页进行授权
 */
- (void)Login;

/**
 *  @brief 登出接口,会清空本地存储的账户信息
 */
- (void)Logout;

/**
 *  @brief 请求用户信息
 *  @param uid:要请求的用户ID
 */
- (void)requestUserInfoWithUID:(NSString *)uid;

/**
 *  @brief 请求用户微博
 *  @param uid:要请求的用户ID
 *  @param count:每页返回的个数
 *  @param page:第几页
 *  @param sinceId:要请求的用户ID
 *  @param trimUser:要请求的用户ID
 */
- (void)requestUserTimelineWithUID:(NSString *)uid Count:(NSString *)count Page:(NSString *)page SinceId:(NSString *)sinceId trimUSer:(NSString *)trimUser;

- (void)requestFriendsWithUID:(NSString *)uid Count:(NSString *)count Cursor:(NSString *)cursor trimStatus:(NSString *)trimStatus;

- (void)getCommentsWithWeiboId:(NSString *)weiboId Count:(NSString *)count Page:(NSString *)page;

- (void)postStatusWithText:(NSString *)text Latitude:(NSString *)latitude Longitude:(NSString *)longitude;

- (void)postImageStatusWithText:(NSString *)text Latitude:(NSString *)latitude Longitude:(NSString *)longitude Image:(NSString *)image;

@end
