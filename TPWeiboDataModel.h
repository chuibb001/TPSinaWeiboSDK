//
//  TPWeiboDataModel.h
//  TPSinaWeiboSDK

//  时光胶囊关心的字段

//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPWeiboTextParser.h"
#import "TPImageDownloader.h"

#define kDefaultTextFont        [UIFont systemFontOfSize:16.0]
#define kDefaultRepostTextFont  [UIFont systemFontOfSize:15.0]
#define kDefaultTextSize        CGSizeMake(270.0, 100.0)
#define kDefaultRepostTextSize  CGSizeMake(250.0, 100.0)
#define kDefaultImageSize       CGSizeMake(100.0, 100.0)

typedef enum
{
    TPWeiboDataTypeText,                    // 原创文字
    TPWeiboDataTypeTextWithImage,           // 原创文字+图片
    TPWeiboDataTypeRepostText,              // 转发文字
    TPWeiboDataTypeRepostTextWithImage      // 转发文字+图片
}
TPWeiboDataType;

typedef enum
{
    TPWeiboDataUserTypeMine,                 // 我的微博
    TPWeiboDataUserTypeOther                 // 朋友微博
}
TPWeiboDataUserType;

/*-----------------------------------
            微博数据模型
 ------------------------------------*/
@interface TPWeiboDataModel : NSObject<TPAbstractModelDelegate,NSCoding,NSCopying>

@property (nonatomic,strong) NSString *weiboId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *repostUserName;
@property (nonatomic,strong) NSDate *time;
@property (nonatomic,strong) NSArray *textArray;
@property (nonatomic,strong) NSArray *repostTextArray;
@property (nonatomic,strong) NSString *thumbnailImageURL;
@property (nonatomic,strong) NSString *bmiddleImageURL;
@property (nonatomic,strong) NSString *originalImageURL;
@property (nonatomic,strong) UIImage  *thumbnailImage;
@property (nonatomic,strong) UIImage  *bmiddleImage;
@property (nonatomic,strong) UIImage  *originalImage;
@property (nonatomic,assign) CGSize textSize;
@property (nonatomic,assign) CGSize repostTextSize;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,assign) TPWeiboDataType type;
@property (nonatomic,assign) TPWeiboDataUserType userType;
@property (nonatomic,assign) CGFloat rowHeight;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
