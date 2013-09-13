//
//  TPWeiboDataModel.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboDataModel.h"
/*-----------------------------------
    文本数据:包括raw文本和解析后的结构
 ------------------------------------*/
@implementation TPWeiboTextData

-(void)parse
{   
    self.parsedTextArray = [TPWeiboTextParser textArrayWithRawString:self.text];
    self.textSize = [TPWeiboTextParser sizeWithTextArray:self.parsedTextArray constrainsToSize:self.textSize Font:self.font];
}
@end

/*-----------------------------------
    图片数据:包括图片地址和下载后的缓存
 ------------------------------------*/
@implementation TPWeiboImageData


@end

/*-----------------------------------
            微博数据模型
 ------------------------------------*/
@implementation TPWeiboDataModel

- (id)initWithDictionary:(NSDictionary *)dic;
{
    self = [super init];
    if (self) {
        [self setupWeiboDataModalWithDictionary:dic];
    }
    return self;
}

-(void)setupWeiboDataModalWithDictionary:(NSDictionary *)dic
{  
    self.type = TPWeiboDataTypeText;
    self.weiboId = [dic objectForKey:@"id"];
    // 处理原文本
    self.textData = [[TPWeiboTextData alloc] init];
    self.textData.text = [dic objectForKey:@"text"];
    self.textData.textSize = CGSizeMake(270.0, 100.0);
    self.textData.font = [UIFont systemFontOfSize:16.0];
    [self.textData parse];
    
    self.userName = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];
    NSDate *date=[self fdateFromString:[dic objectForKey:@"created_at"]];
    self.time = [[date description] substringToIndex:16];
    self.height += self.textData.textSize.height + 10;
    
    // 原创文字+图片
    if([dic objectForKey:@"thumbnail_pic"])  
    {
        self.type = TPWeiboDataTypeTextWithImage;
        self.imageData = [[TPWeiboImageData alloc] init];
        self.imageData.thumbnailPicURL = [dic objectForKey:@"thumbnail_pic"];
        self.imageData.bmiddlePicURL = [dic objectForKey:@"bmiddle_pic"];
        self.imageData.originalPicURL = [dic objectForKey:@"original_pic"];
        self.height += 140;
    }
    else
    {
        if([dic objectForKey:@"retweeted_status"])
        {
            NSDictionary *repostDic = [dic objectForKey:@"retweeted_status"];
            // 处理转发文本
            self.repostTextData = [[TPWeiboTextData alloc] init];
            self.repostTextData.text = [repostDic objectForKey:@"text"];
            self.repostTextData.textSize = CGSizeMake(250.0, 100.0);
            self.repostTextData.font = [UIFont systemFontOfSize:15.0];
            [self.repostTextData parse];
            
            self.repostUserName = [[repostDic objectForKey:@"user"] objectForKey:@"screen_name"];
            
            // 转发文字+图片
            if([repostDic objectForKey:@"thumbnail_pic"])  
            {
                self.type = TPWeiboDataTypeRepostTextWithImage;
                self.imageData = [[TPWeiboImageData alloc] init];
                self.imageData.thumbnailPicURL = [repostDic objectForKey:@"thumbnail_pic"];
                self.imageData.bmiddlePicURL = [repostDic objectForKey:@"bmiddle_pic"];
                self.imageData.originalPicURL = [repostDic objectForKey:@"original_pic"];
                self.height += self.repostTextData.textSize.height + 200;
            }
            // 转发文字
            else
            {
                self.type = TPWeiboDataTypeRepostText;
                self.height += self.repostTextData.textSize.height + 80;
            }
        }
        // 原创文字
        else    
        {
            self.type = TPWeiboDataTypeText;
            self.height += 35;
        }
    }
}

#pragma mark private
-(NSDate *)fdateFromString:(NSString *)string {
    //Wed Mar 14 16:40:08 +0800 2012
    if (!string)
        return nil;
    struct tm tm;
    time_t t;
    string=[string substringFromIndex:4];
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%b %d %H:%M:%S %z %Y", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    return [NSDate dateWithTimeIntervalSince1970:t];
}

#pragma mark TPAbstractModelDelegate
-(void)cacheWithImage:(UIImage *)image type:(TPWeiboImageType)type   // 缓存数据
{
    switch (type) {
        case TPWeiboImageTypeThumbnail:
            self.imageData.thumbnailPic = image;
            break;
        case TPWeiboImageTypeBmiddle:
            self.imageData.bmiddlePic = image;
            break;
        case TPWeiboImageTypeOriginal:
            self.imageData.originalPic = image;
            break;
        default:
            break;
    }
}
@end
