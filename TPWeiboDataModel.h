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

/*-----------------------------------
    文本数据:包括raw文本和解析后的结构
 ------------------------------------*/
@interface TPWeiboTextData : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSArray *parsedTextArray;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,assign) CGSize textSize;

-(void)parse;

@end

/*-----------------------------------
    图片数据:包括图片地址和下载后的缓存
 ------------------------------------*/
@interface TPWeiboImageData : NSObject

@property (nonatomic,strong) NSString *thumbnailPicURL;
@property (nonatomic,strong) NSString *bmiddlePicURL;
@property (nonatomic,strong) NSString *originalPicURL;
@property (nonatomic,strong) UIImage  *thumbnailPic;
@property (nonatomic,strong) UIImage  *bmiddlePic;
@property (nonatomic,strong) UIImage  *originalPic;

@end

/*-----------------------------------
            微博数据模型
 ------------------------------------*/
@interface TPWeiboDataModel : NSObject<TPAbstractModelDelegate>

@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *weiboId;
@property (nonatomic,strong) TPWeiboTextData *textData;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) TPWeiboTextData *repostTextData;
@property (nonatomic,strong) NSString *repostUserName;
@property (nonatomic,strong) TPWeiboImageData *imageData;
@property (nonatomic,assign) TPWeiboDataType type;
@property (nonatomic,assign) CGFloat height;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
