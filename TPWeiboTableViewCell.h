//
//  TPWeiboTableViewCell.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPImageTextView.h"
#import "TPWeiboDataModel.h"
#import "TPImageDownloadCenter.h"

@interface TPWeiboTableViewTextCell : UITableViewCell

@property (nonatomic,strong) TPImageTextView *textView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *radioButton;

- (void)setDisplayData:(TPWeiboDataModel *)dataModel;

@end

@interface TPWeiboTableViewTextWithImageCell : TPWeiboTableViewTextCell<TPAbstractViewDelegate>

@property (nonatomic,strong) UIImageView *picImageView;

@end

@interface TPWeiboTableViewRepostTextCell : TPWeiboTableViewTextCell

@property (nonatomic,strong) TPImageTextView *repostTextView;
@property (nonatomic,strong) UIImageView *repostBackgroundImageView;
@property (nonatomic,strong) UILabel *nameLabel;

@end

@interface TPWeiboTableViewRepostTextWithImageCell : TPWeiboTableViewRepostTextCell<TPAbstractViewDelegate>

@property (nonatomic,strong) UIImageView *picImageView;

@end