//
//  ViewController.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// 登录
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, 300, 44);
    [button addTarget:self action:@selector(LoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 请求
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"资源" forState:UIControlStateNormal];
    button1.frame = CGRectMake(10, 70, 300, 44);
    [button1 addTarget:self action:@selector(ResourceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

-(void)LoginButtonClicked:(id)sender
{
    [[TPSinaWeiboEngine sharedInstance] Login];
}

-(void)ResourceButtonClicked:(id)sender
{
    [[TPSinaWeiboEngine sharedInstance] postImageStatus];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
