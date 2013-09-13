//
//  TPImageTextView.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPWeiboTextParser.h"

@interface TPImageTextView : UIView
{
    UIColor *textColor;
}

@property (nonatomic, strong) NSArray *parsedTextArray;
@property (nonatomic, strong) NSArray *weiboEmotions;
@property (nonatomic, retain) UIFont *font;

-(void)setTextArray:(NSArray *)parsedTextArray;

@end
