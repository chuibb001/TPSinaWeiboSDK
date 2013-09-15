//
//  TPWeiboDataModel.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboDataModel.h"

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
    self.weiboId = [dic objectForKey:@"id"];  // 微博ID
    self.userName = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];  // 用户昵称
    NSDate *date=[self fdateFromString:[dic objectForKey:@"created_at"]];   
    self.time = date;     // 时间
    
    // 处理原文本
    NSArray *aTextArray = [TPWeiboTextParser textArrayWithRawString:[dic objectForKey:@"text"]];
    self.textArray = aTextArray;
    self.textSize = [TPWeiboTextParser sizeWithTextArray:aTextArray constrainsToSize:kDefaultTextSize Font:kDefaultTextFont];
    
    self.rowHeight += self.textSize.height + 10;
    
    /*-----------------------------------
                1:原创文字+图片
     -----------------------------------*/
    if([dic objectForKey:@"thumbnail_pic"])  
    {
        // 处理图片URL
        self.type = TPWeiboDataTypeTextWithImage;
        
        self.thumbnailImageURL = [dic objectForKey:@"thumbnail_pic"];
        self.bmiddleImageURL = [dic objectForKey:@"bmiddle_pic"];
        self.originalImageURL = [dic objectForKey:@"original_pic"];
        
        self.rowHeight += 140;
    }
    else
    {
        if([dic objectForKey:@"retweeted_status"])
        {
            NSDictionary *repostDic = [dic objectForKey:@"retweeted_status"];
            
            // 处理转发数据
            self.repostUserName = [[repostDic objectForKey:@"user"] objectForKey:@"screen_name"];  // 用户昵称
            
            // 转发文本
            NSArray *aTextArray = [TPWeiboTextParser textArrayWithRawString:[repostDic objectForKey:@"text"]];
            self.repostTextArray = aTextArray;
            
            // 转发文本UI
            self.repostTextSize = [TPWeiboTextParser sizeWithTextArray:aTextArray constrainsToSize:kDefaultRepostTextSize Font:kDefaultRepostTextFont];
            
            /*-----------------------------------
                       3:转发文字+图片
             -----------------------------------*/
            if([repostDic objectForKey:@"thumbnail_pic"])  
            {
                // 处理转发图片URL
                self.type = TPWeiboDataTypeRepostTextWithImage;
                
                self.thumbnailImageURL = [repostDic objectForKey:@"thumbnail_pic"];
                self.bmiddleImageURL = [repostDic objectForKey:@"bmiddle_pic"];
                self.originalImageURL = [repostDic objectForKey:@"original_pic"];
                
                self.rowHeight += self.repostTextSize.height + 200;
            }
            /*-----------------------------------
                            2:转发文字
             -----------------------------------*/
            else
            {
                self.type = TPWeiboDataTypeRepostText;
                self.rowHeight += self.repostTextSize.height + 80;
            }
        }
        /*-----------------------------------
                    0:原创文字
         -----------------------------------*/
        else
        {
            self.type = TPWeiboDataTypeText;
            self.rowHeight += 35;
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
            self.thumbnailImage = image;
            break;
        case TPWeiboImageTypeBmiddle:
            self.bmiddleImage = image;
            break;
        case TPWeiboImageTypeOriginal:
            self.originalImage = image;
            break;
        default:
            break;
    }
}

#define kTPWeiboDataModelWeiboIdKey @"kTPWeiboDataModelWeiboIdKey"
#define kTPWeiboDataModelUserNameKey @"kTPWeiboDataModelUserNameKey"
#define kTPWeiboDataModelRepostUserNameKey @"kTPWeiboDataModelRepostUserNameKey"
#define kTPWeiboDataModelTimeKey @"kTPWeiboDataModelTimeKey"
#define kTPWeiboDataModelTextArrayKey @"kTPWeiboDataModelTextArrayKey"
#define kTPWeiboDataModelRepostTextArrayKey @"kTPWeiboDataModelRepostTextArrayKey"
#define kTPWeiboDataModelThumbnailImageURLKey @"kTPWeiboDataModelThumbnailImageURLKey"
#define kTPWeiboDataModelBmiddleImageURLKey @"kTPWeiboDataModelBmiddleImageURLKey"
#define kTPWeiboDataModelOriginalImageURLKey @"kTPWeiboDataModelOriginalImageURLKey"
#define kTPWeiboDataModelThumbnailImageKey @"kTPWeiboDataModelThumbnailImageKey"
#define kTPWeiboDataModelBmiddleImageKey @"kTPWeiboDataModelBmiddleImageKey"
#define kTPWeiboDataModelOriginalImageKey @"kTPWeiboDataModelOriginalImageKey"
#define kTPWeiboDataModelTextSizeKey @"kTPWeiboDataModelTextSizeKey"
#define kTPWeiboDataModelRepostTextSizeKey @"kTPWeiboDataModelRepostTextSizeKey"
#define kTPWeiboDataModelImageSizeKey @"kTPWeiboDataModelImageSizeKey"
#define kTPWeiboDataModelTypeKey @"kTPWeiboDataModelTypeKey"
#define kTPWeiboDataModelUserTypeKey @"kTPWeiboDataModelUserTypeKey"
#define kTPWeiboDataModelRowHeightKey @"kTPWeiboDataModelRowHeightKey"

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.weiboId forKey:kTPWeiboDataModelWeiboIdKey];
    [aCoder encodeObject:self.userName forKey:kTPWeiboDataModelUserNameKey];
    [aCoder encodeObject:self.repostUserName forKey:kTPWeiboDataModelRepostUserNameKey];
    [aCoder encodeObject:self.time forKey:kTPWeiboDataModelTimeKey];
    [aCoder encodeObject:self.textArray forKey:kTPWeiboDataModelTextArrayKey];
    [aCoder encodeObject:self.repostTextArray forKey:kTPWeiboDataModelRepostTextArrayKey];
    [aCoder encodeObject:self.thumbnailImageURL forKey:kTPWeiboDataModelThumbnailImageURLKey];
    [aCoder encodeObject:self.bmiddleImageURL forKey:kTPWeiboDataModelBmiddleImageURLKey];
    [aCoder encodeObject:self.originalImageURL forKey:kTPWeiboDataModelOriginalImageURLKey];
    [aCoder encodeObject:self.thumbnailImage forKey:kTPWeiboDataModelThumbnailImageKey];
    [aCoder encodeObject:self.bmiddleImage forKey:kTPWeiboDataModelBmiddleImageKey];
    [aCoder encodeObject:self.originalImage forKey:kTPWeiboDataModelOriginalImageKey];
    [aCoder encodeCGSize:self.textSize forKey:kTPWeiboDataModelTextSizeKey];
    [aCoder encodeCGSize:self.repostTextSize forKey:kTPWeiboDataModelRepostTextSizeKey];
    [aCoder encodeCGSize:self.imageSize forKey:kTPWeiboDataModelImageSizeKey];
    [aCoder encodeInteger:self.type forKey:kTPWeiboDataModelTypeKey];
    [aCoder encodeInteger:self.userType forKey:kTPWeiboDataModelUserTypeKey];
    [aCoder encodeFloat:self.rowHeight forKey:kTPWeiboDataModelRowHeightKey];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.weiboId = [aDecoder decodeObjectForKey:kTPWeiboDataModelWeiboIdKey];
    self.userName = [aDecoder decodeObjectForKey:kTPWeiboDataModelUserNameKey];
    self.repostUserName = [aDecoder decodeObjectForKey:kTPWeiboDataModelRepostUserNameKey];
    self.time = [aDecoder decodeObjectForKey:kTPWeiboDataModelTimeKey];
    self.textArray = [aDecoder decodeObjectForKey:kTPWeiboDataModelTextArrayKey];
    self.repostTextArray = [aDecoder decodeObjectForKey:kTPWeiboDataModelRepostTextArrayKey];
    self.thumbnailImageURL = [aDecoder decodeObjectForKey:kTPWeiboDataModelThumbnailImageURLKey];
    self.bmiddleImageURL = [aDecoder decodeObjectForKey:kTPWeiboDataModelBmiddleImageURLKey];
    self.originalImageURL = [aDecoder decodeObjectForKey:kTPWeiboDataModelOriginalImageURLKey];
    self.thumbnailImage = [aDecoder decodeObjectForKey:kTPWeiboDataModelThumbnailImageKey];
    self.bmiddleImage = [aDecoder decodeObjectForKey:kTPWeiboDataModelBmiddleImageKey];
    self.originalImage = [aDecoder decodeObjectForKey:kTPWeiboDataModelOriginalImageKey];
    self.textSize = [aDecoder decodeCGSizeForKey:kTPWeiboDataModelTextSizeKey];
    self.repostTextSize = [aDecoder decodeCGSizeForKey:kTPWeiboDataModelRepostTextSizeKey];
    self.imageSize = [aDecoder decodeCGSizeForKey:kTPWeiboDataModelImageSizeKey];
    self.type = [aDecoder decodeIntegerForKey:kTPWeiboDataModelTypeKey];
    self.userType = [aDecoder decodeIntegerForKey:kTPWeiboDataModelUserTypeKey];
    self.rowHeight = [aDecoder decodeFloatForKey:kTPWeiboDataModelRowHeightKey];
    
    return self;
}
@end
