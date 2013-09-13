//
//  TPWeiboTextParser.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWeiboTextTypeKey       @"kWeiboTextTypeKey"
#define kWeiboTextStringKey     @"kWeiboTextStringKey"

#define kEmotionWidth  18
#define kEmotionHeight 18
#define kXMargine       0
#define kYMargine       2

typedef enum
{
    TPWeiboTextTypeEmotion,          // et. [哈哈]
    TPWeiboTextTypeHightLightText,   // et. @ xxx
    TPWeiboTextTypeNomalText         // et.  ..
}
TPWeiboTextType;

@interface TPWeiboTextParser : NSObject

+(NSArray *)textArrayWithRawString:(NSString *)text;
+(CGSize)sizeWithTextArray:(NSArray *)textArray constrainsToSize:(CGSize)size Font:(UIFont *)font;

@end
