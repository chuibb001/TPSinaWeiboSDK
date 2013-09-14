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

@end

/*-----------------------------------
    图片数据:包括图片地址和下载后的缓存
 ------------------------------------*/
@implementation TPWeiboImageData


@end

/*-----------------------------------
        UI数据:单条微博UI数据
 ------------------------------------*/
@implementation TPWeiboUIData

@end
/*-----------------------------------
        微博数据:单条微博数据
 ------------------------------------*/
@implementation TPWeiboData
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
    TPWeiboData *aWeiboData = [[TPWeiboData alloc] init];
    TPWeiboUIData *aWeiboUIdata = [[TPWeiboUIData alloc] init];
    self.weiboData = aWeiboData;
    self.weiboUIData = aWeiboUIdata;
    
    aWeiboData.weiboId = [dic objectForKey:@"id"];  // 微博ID
    aWeiboData.userName = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];  // 用户昵称
    NSDate *date=[self fdateFromString:[dic objectForKey:@"created_at"]];   
    aWeiboData.time = date;     // 时间
    
    // 处理原文本
    aWeiboData.textData = [[TPWeiboTextData alloc] init];
    NSArray *aTextArray = [TPWeiboTextParser textArrayWithRawString:[dic objectForKey:@"text"]];
    aWeiboData.textData.parsedTextArray = aTextArray;
    aWeiboUIdata.font = [UIFont systemFontOfSize:16.0];
    aWeiboUIdata.textSize = [TPWeiboTextParser sizeWithTextArray:aTextArray constrainsToSize:CGSizeMake(270.0, 100.0) Font:aWeiboUIdata.font];
    
    self.height += aWeiboUIdata.textSize.height + 10;
    
    // 原创文字+图片
    if([dic objectForKey:@"thumbnail_pic"])  
    {
        // 处理图片URL
        self.type = TPWeiboDataTypeTextWithImage;
        TPWeiboImageData *aThumbnailImageData = [[TPWeiboImageData alloc] init];
        TPWeiboImageData *aBmiddleImageData = [[TPWeiboImageData alloc] init];
        TPWeiboImageData *aOriginalImageData = [[TPWeiboImageData alloc] init];
        
        aThumbnailImageData.imageURL = [dic objectForKey:@"thumbnail_pic"];
        aBmiddleImageData.imageURL = [dic objectForKey:@"bmiddle_pic"];
        aOriginalImageData.imageURL = [dic objectForKey:@"original_pic"];
        
        aWeiboData.thumbnailImageData = aThumbnailImageData;
        aWeiboData.bmiddleImageData = aBmiddleImageData;
        aWeiboData.originalImageData = aOriginalImageData;
        
        self.height += 140;
    }
    else
    {
        if([dic objectForKey:@"retweeted_status"])
        {
            NSDictionary *repostDic = [dic objectForKey:@"retweeted_status"];
            
            TPWeiboData *aRepostWeiboData = [[TPWeiboData alloc] init];
            TPWeiboUIData *aRepostWeboUIData = [[TPWeiboUIData alloc] init];
            aWeiboData.repostWeiboData = aRepostWeiboData;
            aWeiboUIdata.repostWeiboUIdata = aRepostWeboUIData;
            
            // 处理转发数据
            aRepostWeiboData.weiboId = [repostDic objectForKey:@"id"];  // 微博ID
            aRepostWeiboData.userName = [[repostDic objectForKey:@"user"] objectForKey:@"screen_name"];  // 用户昵称
            NSDate *date=[self fdateFromString:[repostDic objectForKey:@"created_at"]];
            aRepostWeiboData.time = date;     // 时间
            
            // 转发文本
            aRepostWeiboData.textData = [[TPWeiboTextData alloc] init];
            NSArray *aTextArray = [TPWeiboTextParser textArrayWithRawString:[repostDic objectForKey:@"text"]];
            aRepostWeiboData.textData.parsedTextArray = aTextArray;
            // 转发文本UI
            aRepostWeboUIData.font = [UIFont systemFontOfSize:15.0];
            aRepostWeboUIData.textSize = [TPWeiboTextParser sizeWithTextArray:aTextArray constrainsToSize:CGSizeMake(250.0, 100.0) Font:aRepostWeboUIData.font];
            
            
            // 转发文字+图片
            if([repostDic objectForKey:@"thumbnail_pic"])  
            {
                // 处理转发图片URL
                self.type = TPWeiboDataTypeRepostTextWithImage;
                TPWeiboImageData *aThumbnailImageData = [[TPWeiboImageData alloc] init];
                TPWeiboImageData *aBmiddleImageData = [[TPWeiboImageData alloc] init];
                TPWeiboImageData *aOriginalImageData = [[TPWeiboImageData alloc] init];
                
                aThumbnailImageData.imageURL = [repostDic objectForKey:@"thumbnail_pic"];
                aBmiddleImageData.imageURL = [repostDic objectForKey:@"bmiddle_pic"];
                aOriginalImageData.imageURL = [repostDic objectForKey:@"original_pic"];
                
                aRepostWeiboData.thumbnailImageData = aThumbnailImageData;
                aRepostWeiboData.bmiddleImageData = aBmiddleImageData;
                aRepostWeiboData.originalImageData = aOriginalImageData;
                
                self.height += aRepostWeboUIData.textSize.height + 200;
            }
            // 转发文字
            else
            {
                self.type = TPWeiboDataTypeRepostText;
                self.height += aRepostWeboUIData.textSize.height + 80;
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
            self.weiboData.thumbnailImageData.image = image;
            break;
        case TPWeiboImageTypeBmiddle:
            self.weiboData.bmiddleImageData.image = image;
            break;
        case TPWeiboImageTypeOriginal:
            self.weiboData.originalImageData.image = image;
            break;
        case TPWeiboImageTypeRepostThumbnail:
            self.weiboData.repostWeiboData.thumbnailImageData.image = image;
            break;
        case TPWeiboImageTypeRepostBmiddle:
            self.weiboData.repostWeiboData.bmiddleImageData.image = image;
            break;
        case TPWeiboImageTypeRepostOriginal:
            self.weiboData.repostWeiboData.originalImageData.image = image;
            break;
        default:
            break;
    }
}
@end
