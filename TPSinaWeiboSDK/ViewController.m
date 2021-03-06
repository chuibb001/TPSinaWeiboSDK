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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoNotification:) name:kTPSinaWeiboEngineUserInfoNotification object:nil];
	// 登录
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, 300, 44);
    [button addTarget:self action:@selector(LoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 登出
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"登出" forState:UIControlStateNormal];
    button2.frame = CGRectMake(10, 70, 300, 44);
    [button2 addTarget:self action:@selector(LogoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    // 请求
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"资源" forState:UIControlStateNormal];
    button1.frame = CGRectMake(10, 130, 300, 44);
    [button1 addTarget:self action:@selector(ResourceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}


-(void)LogoutButtonClicked:(id)sender
{
    [[TPSinaWeiboEngine sharedInstance] Logout];
}

-(void)LoginButtonClicked:(id)sender
{
    [[TPSinaWeiboEngine sharedInstance] Login];
}

-(void)ResourceButtonClicked:(id)sender
{
    //[[TPSinaWeiboEngine sharedInstance] requestUserInfoWithUID:nil];
    TPWeiboListViewController *c = [[TPWeiboListViewController alloc] init];
    TPCreateDiaryViewController *b = [[TPCreateDiaryViewController alloc] init];
    [self presentViewController:c animated:YES completion:nil];
}

-(void)UserInfoNotification:(NSNotification *)note
{
    NSDictionary *dic = note.object;
    NSError *error = dic[kTPSinaWeiboEngineErrorCodeKey];
    NSLog(@"%@",error);
    if(error.code == 200)
    {
        NSDictionary * responseDic = dic[kTPSinaWeiboEngineResponseDataKey];
        NSLog(@"%@",responseDic);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
