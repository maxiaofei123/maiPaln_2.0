//
//  M_paiHang_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-1.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_paiHang_ViewController.h"

@interface M_paiHang_ViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIView *backgroudView;
    UITableView *PtableView;
    NSArray * arrScoreArr;
}
@end

@implementation M_paiHang_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    [self DrawNav];
    [self initTable];
    [self request];

}

-(void)request
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在请求...";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.mfeiji.com/v1/scores/topten" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        arrScoreArr = responseObject;
//        NSLog(@"arr =%@",arrScoreArr);
        [self initLable];
        [PtableView reloadData];
        HUD.labelText = [NSString stringWithFormat:@"请求成功"];
        [HUD hide:YES afterDelay:1.];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        HUD.labelText = [NSString stringWithFormat:@"请求失败,请检查网络连接"];
        [HUD hide:YES afterDelay:1.];
    }];
}

-(void)initTable
{
    PtableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, Main_Screen_Width,Main_Screen_Height-170 )];
    PtableView.backgroundColor = [UIColor clearColor];
    PtableView.delegate =self;
    PtableView.dataSource =self;
    PtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [backgroudView addSubview:PtableView];
}

-(void)initLable
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(50, Main_Screen_Height-80, Main_Screen_Width-100, 30)];
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:16];
    lable.textAlignment = NSTextAlignmentCenter;
    int  rankMe = [self.rank intValue];
    if (rankMe ==0 ) {
        lable.text = @"您还没有考试，暂无排名";
    }else
    {
        lable.text = [NSString stringWithFormat:@"我的排名: 目前您排在 %d 名",rankMe];
    }
    [backgroudView addSubview:lable];

}

-(void)DrawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 1;
    [backgroudView addSubview:backBt];
    
    UIButton *shareBt =[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 10, 30, 30)];
    [shareBt setImage:[UIImage imageNamed:@"public_share.png"] forState:UIControlStateNormal];
    [shareBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    shareBt.tag =2;
    [backgroudView addSubview:shareBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"排行榜";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
}

-(void)choose:(UIButton *)sender
{
    if (sender.tag ==1) {
        if(self.tag ==0)
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar showTabBar];
        }
        [self.navigationController popViewControllerAnimated:YES ];
    }else if(sender.tag ==2)
    {
        // fenxiang
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到微信好友",@"分享到朋友圈", nil];
        [sheet showInView:self.view];
    }
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, Main_Screen_Width-40, 43)];
    view.backgroundColor = [UIColor colorWithRed:48/255. green:53/255. blue:74/255. alpha:1.];
    [cell.contentView addSubview:view];
    // header
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 1 , 46  , 46)];
//    NSLog(@"%@",[[arrScoreArr objectAtIndex:indexPath.row] objectForKey:@"avatar"]);
    [headView setImageWithURL:[[arrScoreArr objectAtIndex:indexPath.row] objectForKey:@"avatar"] placeholderImage:nil];
    if (headView.image ==nil) {
        headView.image = [UIImage imageNamed:@"test.jpg"];
    }
    [cell.contentView addSubview:headView];
    //圆角设置
    headView.layer.cornerRadius = 23;
    headView.layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [headView.layer setBorderWidth:1];
    [headView.layer setBorderColor:[[UIColor whiteColor] CGColor]];  //设置边框为蓝色
    //自动适应,保持图片宽高比
//    headView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 45, 85, 20)];
    nameLable.text = [[arrScoreArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = [UIFont systemFontOfSize:10.];
    [cell.contentView addSubview:nameLable];
    
    UILabel * numberLable = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2 -50, 0, 100, 40)];
    numberLable.textAlignment = NSTextAlignmentCenter;
    numberLable.text =[NSString stringWithFormat:@"%@分",[[arrScoreArr objectAtIndex:indexPath.row] objectForKey:@"number"]] ;
    numberLable.textColor = [UIColor whiteColor];
    numberLable.font = [UIFont systemFontOfSize:18.];
    [view addSubview:numberLable];
    NSString * str =[NSString stringWithFormat:@"%@",[[arrScoreArr objectAtIndex:indexPath.row] objectForKey:@"time"]];
    UILabel * timeLable = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2+30, 0, view.frame.size.width/2-30-10, 40)];
    timeLable.textColor = [UIColor whiteColor];
    timeLable.alpha = 0.5;
    timeLable.font = [UIFont systemFontOfSize:11.];
    timeLable.text =[str substringToIndex:10];
    timeLable.textAlignment = NSTextAlignmentRight;
    [view addSubview:timeLable];
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrScoreArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * url = [[NSUserDefaults standardUserDefaults]objectForKey:@"avatar"];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    int  test = [self.rank intValue];
    NSString * str = [NSString stringWithFormat:@"全球飞行员排行中，我占第 %@ 位，你敢跟我PK吗？",self.rank];
    if (test < 1)
    {
        str = @"快来加入麦飞机全球飞行排行榜，看看你排多少位?";
    }
//    NSLog(@"%@",str);
    if (buttonIndex == 0) {
        [Pulic_class sendLinkContent:0 title:str image:[UIImage imageWithData:data] url:@"https://itunes.apple.com/us/app/mai-fei-ji/id920281189?l=zh&ls=1&mt=8"];
    }else if (buttonIndex == 1){
        [Pulic_class sendLinkContent:1 title:str image:[UIImage imageWithData:data]url:@"https://itunes.apple.com/us/app/mai-fei-ji/id920281189?l=zh&ls=1&mt=8"];
    }
}


@end
