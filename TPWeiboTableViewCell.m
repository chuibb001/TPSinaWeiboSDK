//
//  TPWeiboTableViewCell.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboTableViewCell.h"

@implementation TPWeiboTableViewTextCell // 0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*选择按钮*/
        self.radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.radioButton.frame=CGRectMake(5, 10, 25, 25);
        [self addSubview:self.radioButton];
        /*文本*/
        self.textView=[[TPImageTextView alloc] initWithFrame:CGRectMake(40, 10, 270, 400)];
        self.textView.backgroundColor=[UIColor clearColor];
        self.textView.font=[UIFont systemFontOfSize:16.0];
        [self addSubview:self.textView];
        /*时间标签*/
        self.timeLabel=[[UILabel alloc] init];
        self.timeLabel.font=[UIFont systemFontOfSize:12.0];
        self.timeLabel.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.timeLabel.textAlignment=kCTLeftTextAlignment;
        self.timeLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.weiboUIData.textSize.width, dataModel.weiboUIData.textSize.height);
    const CGRect timeLabelFrame = CGRectMake(40, 5 + textViewFrame.size.height + textViewFrame.origin.y, 270, 20);
    
    [self.textView setTextArray:dataModel.weiboData.textData.parsedTextArray];
    self.textView.frame = textViewFrame;
    self.timeLabel.text = [[dataModel.weiboData.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
}

@end

@implementation TPWeiboTableViewTextWithImageCell  // 1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*图片*/
        self.picImageView=[[UIImageView alloc] init];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.picImageView];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.weiboUIData.textSize.width, dataModel.weiboUIData.textSize.height);
    const CGRect imageViewFrame = CGRectMake(textViewFrame.origin.x, 5 + textViewFrame.size.height + textViewFrame.origin.y, 100.0, 100.0);
    const CGRect timeLabelFrame = CGRectMake(40, 5 + imageViewFrame.size.height + imageViewFrame.origin.y, 270, 20);
    
    [self.textView setTextArray:dataModel.weiboData.textData.parsedTextArray];
    self.textView.frame = textViewFrame;
    // 加载图片:从缓存取或者异步加载
    if(dataModel.weiboData.thumbnailImageData.image)
        self.picImageView.image = dataModel.weiboData.thumbnailImageData.image;
    else
        [[TPImageDownloadCenter sharedInstance] loadImageWithURL:dataModel.weiboData.thumbnailImageData.imageURL Type:TPWeiboImageTypeThumbnail ViewDelegate:self ModelDelegate:dataModel ProgressDelegate:nil];
    
    self.picImageView.frame = imageViewFrame;
    self.timeLabel.text = [[dataModel.weiboData.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
}

#pragma mark TPAbstractViewDelegate
-(void)updateViewWithImage:(UIImage *)image
{
    self.picImageView.image = image;
}

@end

@implementation TPWeiboTableViewRepostTextCell  // 2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*背景色块*/
        self.repostBackgroundImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.repostBackgroundImageView];
        /*转发文本*/
        self.repostTextView=[[TPImageTextView alloc] init];
        self.repostTextView.backgroundColor=[UIColor clearColor];
        self.repostTextView.font=[UIFont systemFontOfSize:15.0];
        [self.repostBackgroundImageView addSubview:self.repostTextView];
        /*转发者名字*/
        self.nameLabel=[[UILabel alloc] init];
        self.nameLabel.backgroundColor=[UIColor clearColor];
        self.nameLabel.textColor=[UIColor colorWithRed:81.0/255.0 green:108.0/255.0 blue:151.0/255.0 alpha:1.0];
        [self.repostBackgroundImageView addSubview:self.nameLabel];
        
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.weiboUIData.textSize.width, dataModel.weiboUIData.textSize.height);
    const CGRect nameLabelFrame = CGRectMake(10, 10, 250, 20);
    const CGRect repostTextViewFrame = CGRectMake(nameLabelFrame.origin.x, nameLabelFrame.origin.y + nameLabelFrame.size.height + 5 , dataModel.weiboUIData.repostWeiboUIdata.textSize.width, dataModel.weiboUIData.repostWeiboUIdata.textSize.height);
    const CGRect repostBackfroundImageViewFrame = CGRectMake(textViewFrame.origin.x, 5 + textViewFrame.size.height + textViewFrame.origin.y, textViewFrame.size.width, repostTextViewFrame.size.height + nameLabelFrame.size.height + 20);
    const CGRect timeLabelFrame = CGRectMake(40, 5 + repostBackfroundImageViewFrame.size.height + repostBackfroundImageViewFrame.origin.y, 270, 20);
    
    [self.textView setTextArray:dataModel.weiboData.textData.parsedTextArray];
    self.textView.frame = textViewFrame;
    self.nameLabel.text = dataModel.weiboData.repostWeiboData.userName;
    self.nameLabel.frame = nameLabelFrame;
    [self.repostTextView setTextArray:dataModel.weiboData.repostWeiboData.textData.parsedTextArray];
    self.repostTextView.frame = repostTextViewFrame;
    self.repostBackgroundImageView.frame = repostBackfroundImageViewFrame;
    self.timeLabel.text = [[dataModel.weiboData.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
}

@end

@implementation TPWeiboTableViewRepostTextWithImageCell  // 3

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*图片*/
        self.picImageView=[[UIImageView alloc] init];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.repostBackgroundImageView addSubview:self.picImageView];
        /*转发者名字*/
        self.nameLabel=[[UILabel alloc] init];
        self.nameLabel.backgroundColor=[UIColor clearColor];
        self.nameLabel.textColor=[UIColor colorWithRed:81.0/255.0 green:108.0/255.0 blue:151.0/255.0 alpha:1.0];
        [self.repostBackgroundImageView addSubview:self.nameLabel];
    }
    return self;
}

- (void)setDisplayData:(TPWeiboDataModel *)dataModel
{
    const CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, dataModel.weiboUIData.textSize.width, dataModel.weiboUIData.textSize.height);
    const CGRect nameLabelFrame = CGRectMake(10, 10, 250, 20);
    const CGRect repostTextViewFrame = CGRectMake(nameLabelFrame.origin.x, nameLabelFrame.origin.y + nameLabelFrame.size.height + 5 , dataModel.weiboUIData.repostWeiboUIdata.textSize.width, dataModel.weiboUIData.repostWeiboUIdata.textSize.height);
    const CGRect imageViewFrame = CGRectMake(repostTextViewFrame.origin.x, 5 + repostTextViewFrame.size.height + repostTextViewFrame.origin.y, 100.0, 100.0);
    const CGRect repostBackfroundImageViewFrame = CGRectMake(textViewFrame.origin.x, 5 + textViewFrame.size.height + textViewFrame.origin.y, textViewFrame.size.width, repostTextViewFrame.size.height + nameLabelFrame.size.height + imageViewFrame.size.height + 25);
    const CGRect timeLabelFrame = CGRectMake(40, 5 + repostBackfroundImageViewFrame.size.height + repostBackfroundImageViewFrame.origin.y, 270, 20);
    
    [self.textView setTextArray:dataModel.weiboData.textData.parsedTextArray];
    self.textView.frame = textViewFrame;
    self.nameLabel.text = dataModel.weiboData.repostWeiboData.userName;
    self.nameLabel.frame = nameLabelFrame;
    [self.repostTextView setTextArray:dataModel.weiboData.repostWeiboData.textData.parsedTextArray];
    self.repostTextView.frame = repostTextViewFrame;
    self.repostBackgroundImageView.frame = repostBackfroundImageViewFrame;
    self.picImageView.frame = imageViewFrame;
    // 加载图片:从缓存取或者异步加载 
    if(dataModel.weiboData.repostWeiboData.thumbnailImageData.image)
        self.picImageView.image = dataModel.weiboData.repostWeiboData.thumbnailImageData.image;
    else
        [[TPImageDownloadCenter sharedInstance] loadImageWithURL:dataModel.weiboData.repostWeiboData.thumbnailImageData.imageURL Type:TPWeiboImageTypeRepostThumbnail ViewDelegate:self ModelDelegate:dataModel ProgressDelegate:nil];
    self.timeLabel.text = [[dataModel.weiboData.time description] substringToIndex:16];
    self.timeLabel.frame = timeLabelFrame;
}

#pragma mark TPAbstractViewDelegate
-(void)updateViewWithImage:(UIImage *)image
{
    self.picImageView.image = image;
}
@end