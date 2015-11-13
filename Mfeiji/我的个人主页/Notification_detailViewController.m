//
//  Notification_detailViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-20.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Notification_detailViewController.h"

@interface Notification_detailViewController ()
{
    UIView *backgroudView;
    UIWebView *webView;
    NSDictionary * dic ;
}

@end

@implementation Notification_detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height -70-40)];
    webView.backgroundColor=[UIColor whiteColor];
    [backgroudView  addSubview: webView];
    
    [self drawNav];
    [self request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(findeChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 200;
    [backgroudView addSubview:backBt];

}

-(void)findeChoose:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)request
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str =[NSString stringWithFormat:@"http://api.mfeiji.com/v1/notices/%@",self.Id];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        dic=responseObject;
        NSString * str = [dic objectForKey:@"page"];
        [webView loadHTMLString:str baseURL:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



@end
