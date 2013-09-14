//
//  TPCreateDiaryViewController.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TPTextView.h"
#import "TPKeyboardHeaderView.h"
#import "TPEmotionView.h"

@interface TPCreateDiaryViewController : UIViewController

@property (nonatomic,strong) TPTextView *textView;
@property (nonatomic,strong) TPKeyboardHeaderView *keyboardHeaderView;
@property (nonatomic,strong) TPEmotionView *emotionView;


@end
