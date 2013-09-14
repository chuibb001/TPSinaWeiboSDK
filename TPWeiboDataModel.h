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
        文本数据:解析后的文本结构
 ------------------------------------*/
@interface TPWeiboTextData : NSObject

@property (nonatomic,strong) NSArray *parsedTextArray;

@end

/*-----------------------------------
    图片数据:包括图片地址和下载后的缓存
 ------------------------------------*/
@interface TPWeiboImageData : NSObject

@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) UIImage  *image;

@end

/*-----------------------------------
        微博数据:单条微博数据
 ------------------------------------*/
@interface TPWeiboData : NSObject

@property (nonatomic,strong) NSString *weiboId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSDate *time;
@property (nonatomic,strong) TPWeiboTextData *textData;
@property (nonatomic,strong) TPWeiboImageData *thumbnailImageData;
@property (nonatomic,strong) TPWeiboImageData *bmiddleImageData;
@property (nonatomic,strong) TPWeiboImageData *originalImageData;
@property (nonatomic,strong) TPWeiboData *repostWeiboData;  // self pointer

@end

/*-----------------------------------
        UI数据:单条微博UI数据
 ------------------------------------*/
@interface TPWeiboUIData : NSObject

@property (nonatomic,strong) UIFont *font;
@property (nonatomic,assign) CGSize textSize;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,strong) TPWeiboUIData * repostWeiboUIdata;

@end

/*-----------------------------------
            微博数据模型
 ------------------------------------*/
@interface TPWeiboDataModel : NSObject<TPAbstractModelDelegate>

@property (nonatomic,strong) TPWeiboData *weiboData;
@property (nonatomic,strong) TPWeiboUIData *weiboUIData;
@property (nonatomic,assign) TPWeiboDataType type;
@property (nonatomic,assign) TPWeiboDataUserType userType;
@property (nonatomic,assign) CGFloat height;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
