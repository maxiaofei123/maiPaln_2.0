//
//  M_order_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-2.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_order_ViewController.h"
#import "FindeDetail_ViewController.h"

@interface M_order_ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *backgroudView;
    UITableView *orderTableView;
    int pageFlag;
    
    NSMutableArray * orderArr;
}
@end

@implementation M_order_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    orderArr = [[NSMutableArray alloc] init];
    
    [self drawNav];
    [self initTableView];
}

-(void)requestOrder:(int)num
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
    NSString *str =[[NSString alloc] initWithFormat:@"http://api.mfeiji.com/v1/orders?user_email=%@&user_token=%@&page=%d",email,token,num];
//    NSLog(@"str =%@",str);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *arr=responseObject;
//        NSLog(@"dic =%@",arr);
        if (num ==0) {
            
        }else{
            
        }
        [orderArr addObjectsFromArray:arr];
        [orderTableView footerEndRefreshing];
        [orderTableView headerEndRefreshing];
        [orderTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];

}

-(void)initTableView
{
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height-70)];
    orderTableView.backgroundColor = [UIColor whiteColor];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [orderTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [orderTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [backgroudView addSubview:orderTableView];
    [orderTableView headerBeginRefreshing];
}

-(void)headerRefresh
{
    pageFlag = 1 ;
    [self requestOrder:pageFlag];
}

-(void)footerRefresh
{
    pageFlag ++;
    [self requestOrder:pageFlag];
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
    title.text = @"我的订单";
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
    
    NSDictionary * dic = [orderArr objectAtIndex:indexPath.row];
    
    UILabel *lableCode = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, Main_Screen_Width-40, 15)];
    lableCode.font = [UIFont systemFontOfSize:14];
    lableCode.text = [NSString stringWithFormat:@"订单号: %@",[dic objectForKey:@"id"]];
    [cell.contentView addSubview:lableCode];
    //title
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, Main_Screen_Width-40, 20)];
    titleLable.font = [UIFont systemFontOfSize:14.];
    titleLable.alpha = 0.6;
    titleLable.text = [dic objectForKey:@"product_title"];
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
    FindeDetail_ViewController * detail  = [[FindeDetail_ViewController alloc] init];
    detail.schoolId = [[orderArr objectAtIndex:indexPath.row] objectForKey:@"product_id"];
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArr.count;
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

@end
