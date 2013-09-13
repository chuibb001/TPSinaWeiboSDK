//
//  TPWeiboListViewController.m
//  TPSinaWeiboSDK
//
//  Created by yan simon on 13-9-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPWeiboListViewController.h"

@interface TPWeiboListViewController ()

@end

@implementation TPWeiboListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initData];
    [self initTableView];
    [self loadWeibo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserTimelineNotification:) name:kTPSinaWeiboEngineUserTimelineNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPWeiboDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    return dataModel.height;;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPWeiboDataModel *dataModel = [self.listData objectAtIndex:indexPath.row];
    switch (dataModel.type) {
        case TPWeiboDataTypeText:   // 0
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewTextCell";
            
            TPWeiboTableViewTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setDisplayData:dataModel];
            
            return cell;
        }
        break;
        case TPWeiboDataTypeTextWithImage:  // 1
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewTextWithImageCell";
            
            TPWeiboTableViewTextWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewTextWithImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setDisplayData:dataModel];
            
            return cell;
        }
        break;
        case TPWeiboDataTypeRepostText:  // 2
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewRepostTextCell";
            
            TPWeiboTableViewRepostTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewRepostTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setDisplayData:dataModel];
            
            return cell;
        }
        break;
        case TPWeiboDataTypeRepostTextWithImage:  // 3
        {
            static NSString *CellIdentifier = @"TPWeiboTableViewRepostTextWithImageCell";
            
            TPWeiboTableViewRepostTextWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[TPWeiboTableViewRepostTextWithImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setDisplayData:dataModel];
            
            return cell;
        }
            break;
            
        default:
        return nil;
            break;
        }
    return nil; 
}
#pragma mark private
-(void)loadWeibo
{
    [[TPSinaWeiboEngine sharedInstance] requestUserTimelineWithUID:nil Count:nil Page:nil SinceId:nil trimUSer:nil];
}
-(void)UserTimelineNotification:(NSNotification *)note
{
    NSDictionary *dic = note.object;
    NSError *error = dic[kTPSinaWeiboEngineErrorCodeKey];
    NSLog(@"%@",error);
    if(error.code == 200)
    {
        NSDictionary * responseDic = dic[kTPSinaWeiboEngineResponseDataKey];
        //NSLog(@"%@",responseDic);
        NSArray *statuses = [responseDic objectForKey:@"statuses"];
        int count = [statuses count];
        for(int i = 0;i<count ;i++)
        {
            NSDictionary *status = [statuses objectAtIndex:i];
            TPWeiboDataModel *dataModel = [[TPWeiboDataModel alloc] initWithDictionary:status];
            [self.listData addObject:dataModel];
        }
        [self.weiboTableView reloadData];
    }
}

#pragma mark init
-(void)initData
{
    self.listData = [[NSMutableArray alloc] init];
}
-(void)initTableView
{
    self.weiboTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.weiboTableView.delegate = self;
    self.weiboTableView.dataSource = self;
    [self.view addSubview:self.weiboTableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
