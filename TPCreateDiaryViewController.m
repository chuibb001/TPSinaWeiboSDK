//
//  TPCreateDiaryViewController.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-14.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPCreateDiaryViewController.h"

@interface TPCreateDiaryViewController ()
{
    BOOL isEmotionViewOpen;
    CGRect emotionViewOpenRect;
    CGRect emotionViewCloseRect;
}
@end

@implementation TPCreateDiaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initData];
    [self initTextView];
    [self initKeyboardHeaderView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark Notification
-(void)KeyboardWillShowNotification:(NSNotification *)note
{
    if(isEmotionViewOpen)   // 修正逻辑
    {
        isEmotionViewOpen = NO;
        [self beginEmotionViewAnimation:NO];
    }
}
-(void)KeyboardWillHideNotification:(NSNotification *)note
{
}

#pragma mark Init Method
-(void)initData
{
    isEmotionViewOpen = NO;
}
-(void)initTextView
{
    self.textView = [[TPTextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.textView.placeHolder = @"写点什么吧..";
    self.textView.text = @"";
    self.textView.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:self.textView];
}
-(void)initKeyboardHeaderView
{
    self.keyboardHeaderView = [[TPKeyboardHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44)];
    [self.keyboardHeaderView.emotionButton addTarget:self action:@selector(emotionButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keyboardHeaderView];
}
-(void)initEmotionView
{
    emotionViewOpenRect = CGRectMake(0, CGRectGetHeight(self.view.frame) - 216.0, CGRectGetWidth(self.view.frame), 216.0);
    emotionViewCloseRect = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 216.0);
    self.emotionView = [[TPEmotionView alloc] initWithFrame:emotionViewCloseRect];
    [self.view addSubview:self.emotionView];
}

#pragma mark ButtonTaped
-(void)emotionButtonTaped:(id)sender
{
    if(!isEmotionViewOpen)
    {
        isEmotionViewOpen = YES;
        if(!self.emotionView)  // 首次初始化
            [self initEmotionView];
        [self beginEmotionViewAnimation:YES];
        [self.textView resignFirstResponder];
        self.keyboardHeaderView.frame = CGRectMake(self.keyboardHeaderView.frame.origin.x, emotionViewOpenRect.origin.y - self.keyboardHeaderView.frame.size.height, self.keyboardHeaderView.frame.size.width, self.keyboardHeaderView.frame.size.height);
    }
    else
    {
        isEmotionViewOpen = NO;
        [self beginEmotionViewAnimation:NO];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark Animations
-(void)beginEmotionViewAnimation:(BOOL)isOpen
{
    if(isOpen) // 打开
    {
        self.emotionView.frame = emotionViewCloseRect;
        [UIView beginAnimations:@"emotionViewOpenAnimation" context:nil];
        self.emotionView.frame = emotionViewOpenRect;
        [UIView commitAnimations];
    }
    else
    {
        self.emotionView.frame = emotionViewOpenRect;
        [UIView beginAnimations:@"emotionViewCloseAnimation" context:nil];
        self.emotionView.frame = emotionViewCloseRect;
        [UIView commitAnimations];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
