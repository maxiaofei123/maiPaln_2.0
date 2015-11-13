//
//  M_about_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-2.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_about_ViewController.h"

@interface M_about_ViewController ()
{
    UIView *backgroudView;
}
@end

@implementation M_about_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    
    [self drawNav];
    [self lableAndView];
}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(aboutChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 200;
    [backgroudView addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -75, 15, 150, 20)];
    title.text = @"关于我们";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];

}

-(void)lableAndView
{
    NSArray *arr = [[NSArray alloc] initWithObjects:@"麦飞机   版本2.0",@"麦飞机是一家集飞行体验、飞行旅游、飞行培训及",@"飞机租售的一体化信息平台", nil];
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-36, 70, 72, 72)];
    icon.image = [UIImage imageNamed:@"about.png"];
    [backgroudView addSubview:icon];
    for (int i=0; i<3; i++) {
        UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 -140, 180 +30*i , 290, 30)];
        lable1.text =[arr objectAtIndex:i];
        [backgroudView addSubview:lable1];
        lable1.font = [UIFont systemFontOfSize:13.];
        lable1.textColor = [UIColor colorWithRed:107/255. green:145/255. blue:197/255. alpha:1.];
    }
}

-(void)aboutChoose:(UIButton *)sender
{
    MainViewController * tabbar = (MainViewController *)self.tabBarController;
    [tabbar showTabBar];

    [self.navigationController popViewControllerAnimated:YES ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
