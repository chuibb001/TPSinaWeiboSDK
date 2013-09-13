//
//  TPWeiboListViewController.h
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWeiboTableViewCell.h"
#import "TPWeiboDataModel.h"
#import "TPSinaWeiboEngine.h"

@interface TPWeiboListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *weiboTableView;
@property (nonatomic,strong) NSMutableArray *listData;

@end
