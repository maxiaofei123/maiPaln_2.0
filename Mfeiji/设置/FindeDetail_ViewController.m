//
//  FindeDetail_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-11-26.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "FindeDetail_ViewController.h"
#import "F_comment_ViewController.h"
#import "Exam_loginViewController.h"
@interface FindeDetail_ViewController ()<UIActionSheetDelegate>
{
    UIView *backgroudView;
    UIWebView *webView;
    UILabel *priceLable;
    UILabel *commentLable;
    UIWebView *phoneCallWebView;
    NSDictionary * dic ;
}

@end

@implementation FindeDetail_ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self requestWithId:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height -70-40)];
    webView.backgroundColor=[UIColor whiteColor];
    [backgroudView  addSubview: webView];
    
    [self drawNav];
    [self drawLable];
    
}

-(void)drawLable
{
    priceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, Main_Screen_Height-30, 100, 20)];
    priceLable.text = @"￥0000";
    priceLable.textColor = [UIColor colorWithRed:68./255 green:103./255 blue:169./255 alpha:1.];
    [priceLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.]];
    [self.view addSubview:priceLable];
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width-113, Main_Screen_Height-30, 93, 23)];
    [bt setImage:[UIImage imageNamed:@"tel_phone.png"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(tel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    
    UIImageView *commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width -110, 15, 52, 22)];
    commentImage.image =[UIImage imageNamed:@"pingLun.png"];
    commentImage.userInteractionEnabled = YES;
    [backgroudView addSubview:commentImage];
    
    UITapGestureRecognizer *comment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment)];
    [commentImage addGestureRecognizer:comment];
    //comment_count
    commentLable = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 46, 13)];
    commentLable.text = @"0评论";
    commentLable.textColor = [UIColor whiteColor];
    commentLable.textAlignment = NSTextAlignmentCenter;
    commentLable.font = [UIFont systemFontOfSize:9.];
    [commentImage addSubview:commentLable];

}
-(void)comment
{
    //跳转到评论页
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    if ([str isEqualToString:@"麦飞机会员"]) {
        Exam_loginViewController * sizhao = [[Exam_loginViewController alloc] init];
        sizhao.flag = 111;
        [self.navigationController pushViewController:sizhao animated:YES];
        
    }else
    {
        F_comment_ViewController *commet = [[F_comment_ViewController alloc] init];
        commet.scId = _schoolId;
        commet.schoolOrFind = @"product_id";
        [self.navigationController pushViewController:commet animated:YES];
    }
}

-(void)tel
{
    NSString * str = [NSString stringWithFormat:@"电话:%@",[dic objectForKey:@"tel"]];
    if ([str isEqualToString:@"电话:<null>"] ) {
        
    }else if([str isEqualToString:@"电话:"] )
    {
        
    }
    else if([str isEqualToString:@"电话:(null)"] )
    {
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打电话" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        [alert show];
    }

}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(findeChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 200;
    [backgroudView addSubview:backBt];
    
    UIButton *shareBt =[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 11, 30, 30)];
    [shareBt setImage:[UIImage imageNamed:@"public_share.png"] forState:UIControlStateNormal];
    [shareBt addTarget:self action:@selector(findeChoose:) forControlEvents:UIControlEventTouchUpInside];
    shareBt.tag = 201;
    [backgroudView addSubview:shareBt];
}

-(void)findeChoose:(UIButton *)sender
{
    if (sender.tag ==200) {
        MainViewController * tabbar = (MainViewController *)self.tabBarController;
        [tabbar hiddenTabBarNo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (sender.tag ==201) {
        //分享
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到微信好友",@"分享到朋友圈", nil];
        [sheet showInView:self.view];
    }
}
-(void)requestWithId:(int)num
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str =[NSString stringWithFormat:@"http://api.mfeiji.com/v1/products/%@",self.schoolId];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        dic=responseObject;
//        NSLog(@"arr =%@",dic);
        NSString * str = [dic objectForKey:@"page"];
//        NSLog(@"str html =%@",str);
        [webView loadHTMLString:str baseURL:nil];
//        NSLog(@" ,,,,=%@",[dic objectForKey:@"price"]);
        priceLable.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        commentLable.text = [NSString stringWithFormat:@"%@评论",[dic objectForKey:@"comment_count"]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        NSString *phoneNum = [dic objectForKey:@"tel"];// 电话号码
        
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
        
        if (!phoneCallWebView ) {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex == 0) {
        [Pulic_class sendLinkContent:0 title:self.shareTitle image:self.shareImage url:@"www.mfeiji.com"];
    }else if (buttonIndex == 1){
        [Pulic_class sendLinkContent:1 title:self.shareTitle image:self.shareImage url:@"www.mfeiji.com"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
