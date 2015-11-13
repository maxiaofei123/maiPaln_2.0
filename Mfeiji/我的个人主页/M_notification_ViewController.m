//
//  M_notification_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-15.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_notification_ViewController.h"
#import "Notification_detailViewController.h"
#import "YFJLeftSwipeDeleteTableView.h"

@interface M_notification_ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *backgroudView;
    YFJLeftSwipeDeleteTableView *orderTableView;
    NSMutableArray *data;
    NSString *plistPath;
    //左滑删除
    UIButton * _deleteButton;
    NSIndexPath * _editingIndexPath;
    UISwipeGestureRecognizer * _leftGestureRecognizer;
    UISwipeGestureRecognizer * _rightGestureRecognizer;
    UITapGestureRecognizer * _tapGestureRecognizer;

}
@end

@implementation M_notification_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    plistPath = [documents stringByAppendingPathComponent:@"noPlist.plist"];
    data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSLog(@"DATE =%@",data);
    [self drawNav];
    [self initTableView];
    [self requst];
}

-(void)initTableView
{
    orderTableView= [[YFJLeftSwipeDeleteTableView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height-70)];

//    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height-70)];
    orderTableView.backgroundColor = [UIColor whiteColor];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [orderTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [backgroudView addSubview:orderTableView];
    [orderTableView headerBeginRefreshing];
}


-(void)drawNav
{
    //nav
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(oderChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 200;
    [backgroudView addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -75, 15, 150, 20)];
    title.text = @"我的通知";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
}

-(void)oderChoose:(UIButton *)sender
{
    MainViewController * tabbar = (MainViewController *)self.tabBarController;
    [tabbar showTabBar];
    [self.navigationController popViewControllerAnimated:YES ];
}

#pragma mark -tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableSampleIdentifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    
    if (cell ==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    else
    {
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, Main_Screen_Width-30, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:204/255. green:204/255. blue:204/255. alpha:1.];
    [cell.contentView addSubview:line];
    
    NSDictionary * dic = [data objectAtIndex:indexPath.row];
    UILabel *lableCode = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, Main_Screen_Width-40, 15)];
    lableCode.font = [UIFont systemFontOfSize:14];
    lableCode.text = [dic objectForKey:@"title"];
    [cell.contentView addSubview:lableCode];
    //title
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, Main_Screen_Width-40, 20)];
    titleLable.font = [UIFont systemFontOfSize:14.];
    titleLable.alpha = 0.6;
    titleLable.text = [dic objectForKey:@"abstract"];
    [cell.contentView addSubview:titleLable];
    
    //time
    UILabel * timeLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, Main_Screen_Width-40, 15)];
    timeLable.font = [UIFont systemFontOfSize:11.];
    timeLable.alpha = 0.2;
    timeLable.text = [dic objectForKey:@"date"];
    [cell.contentView addSubview:timeLable];
    
    UIImageView * nextImage =[[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-40, 23, 13, 15)];
    nextImage.image =[UIImage imageNamed:@"oder_next.png"];
    [cell.contentView addSubview:nextImage];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Notification_detailViewController * detail  = [[Notification_detailViewController alloc] init];
    detail.Id = [[data objectAtIndex:indexPath.row]objectForKey:@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//        NSLog(@"arr =%@",arr);
        [data removeObjectAtIndex:indexPath.row];
        [data writeToFile:plistPath atomically:YES];
//         NSLog(@"delete data =%@",data);
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requst
{
    NSString * time = [[NSUserDefaults standardUserDefaults] objectForKey:@"notificationTime"];
    if (time ==nil) {
        NSString * strtimr = [Pulic_class getTime];
        time = strtimr;
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在请求...";
    NSString *str =[[NSString alloc] initWithFormat:@"http://api.mfeiji.com/v1/notices?time=%@",time];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * notifArr = responseObject;
        [[NSUserDefaults standardUserDefaults] setObject:[Pulic_class getTime] forKey:@"notificationTime"];
        NSMutableArray * test = [[NSMutableArray alloc] init];
        if (notifArr.count >0) {
            for (int i =0; i<notifArr.count; i++) {
                if (data.count ==0) {
                    [test addObject:[notifArr objectAtIndex:i]];
                    [test writeToFile:plistPath atomically:YES];
                }else
                {
                    [data addObject:[notifArr objectAtIndex:i]];
                  [data writeToFile:plistPath atomically:YES];
                }
            }
//            NSLog(@"date =%@ notifi =%@",data,notifArr);
            data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
            [orderTableView reloadData];
        }
        [HUD hide:YES afterDelay:1.];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
        HUD.labelText = @"请求失败，请检查网络连接";
        [HUD hide:YES afterDelay:1.];
    }];
}

@end
