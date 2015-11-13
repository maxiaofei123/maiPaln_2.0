//
//  Exam_sizhao_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-21.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Exam_sizhao_ViewController.h"
#import "Exam_test_ViewController.h"
#import "MainViewController.h"
#import "M_phoneReg_ViewController.h"


@interface Exam_sizhao_ViewController ()
{
    UIView * backgroudView;
    UIImageView *headView;
    UILabel *nameLable;
}
@end

@implementation Exam_sizhao_ViewController
- (void)viewWillAppear:(BOOL)animated
{
    nameLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * url = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    [headView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    if (headView.image ==nil) {
        headView.image = [UIImage imageNamed:@"test.jpg"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, Main_Screen_Width, Main_Screen_Height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    [self drawNav];
    [self drawView];
}

-(void)drawView
{
    headView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-35, Main_Screen_Height/2-210 , 70 ,70)];
     NSString * url = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    [headView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    if (headView.image ==nil) {
        headView.image = [UIImage imageNamed:@"test.jpg"];
    }    [backgroudView addSubview:headView];
    //圆角设置
    headView.layer.cornerRadius = 35;
    headView.layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [headView.layer setBorderWidth:2];
    [headView.layer setBorderColor:[[UIColor colorWithRed:50./255 green:71./255 blue:121./255 alpha:1.] CGColor]];  //设置边框为蓝色
    //自动适应,保持图片宽高比
//    headView.contentMode = UIViewContentModeScaleAspectFit;
    
    nameLable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-60,Main_Screen_Height/2-135, 120, 20)];
    nameLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = [UIFont systemFontOfSize:14.];
    [backgroudView addSubview:nameLable];
    if (Main_Screen_Width <560) {
        headView.frame = CGRectMake(Main_Screen_Width/2-35, Main_Screen_Height/2-200 , 70 ,70);
        nameLable.frame = CGRectMake(Main_Screen_Width/2-40,Main_Screen_Height/2-125, 80, 20);
    }
    
    NSArray * arr = [[NSArray alloc] initWithObjects:@"考试标准: 80题  ,  120分钟",@"合格标准: 满分100分 ,  90分及格",@"模拟考试: 根据比例抽取80道题",@"先考未做: 优先考未做过的题, 不错过每道题", nil];
    for (int i=0; i<2; i++) {
        UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-110,Main_Screen_Height/2-75 +30*i, 220, 30)];
        lable.text = [arr objectAtIndex:i];
        lable.textColor = [UIColor colorWithRed:93./255 green:120./255 blue:170./255 alpha:1.];
        lable.font =[UIFont systemFontOfSize:14.];
        [backgroudView addSubview:lable];
    }
    for (int i=0; i<2; i++) {
        UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-110, Main_Screen_Height/2 +30 +25*i, 220, 25)];
        lable.text = [arr objectAtIndex:i+2];
        lable.textColor = [UIColor colorWithRed:93./255 green:120./255 blue:170./255 alpha:1.];
        lable.font = [UIFont systemFontOfSize:11.];
        [backgroudView addSubview:lable];
    }

    for (int i =0; i<2; i++) {
        UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-110+116*i, Main_Screen_Height/2 -10, 104, 30)];
        [backBt setImage:[UIImage imageNamed:@"exam_moni.png"] forState:UIControlStateNormal];
        [backBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        backBt.tag = 239+i;
        [backgroudView addSubview:backBt];
        if (i==1) {
              [backBt setImage:[UIImage imageNamed:@"exam_kaoWeiZuo.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 231;
    [backgroudView addSubview:backBt];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, self.view.frame.size.width-80, 20)];
    title.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"title"];
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
 
}

-(void)choose:(UIButton *)sender
{
    switch (sender.tag) {
        case 231:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 233:
            [self drawView];
            break;
        case 234:
            
            break;
        case 236:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar hiddenTabBar];
            M_phoneReg_ViewController *reg = [[M_phoneReg_ViewController alloc] init];
            [self.navigationController pushViewController:reg animated:YES];
        }
            break;
        case 239:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar hiddenTabBar];
            Exam_test_ViewController *test =[[Exam_test_ViewController alloc] init];
            test.classFlag = _classflag;
            test.pending = @"";
            test.flag = self.flag;
            [self.navigationController pushViewController:test animated:YES];
        }
            break;
        case 240:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar hiddenTabBar];
            Exam_test_ViewController *test =[[Exam_test_ViewController alloc] init];
            test.classFlag = _classflag;
            test.pending = @"pending";
            test.flag = self.flag;
            [self.navigationController pushViewController:test animated:YES];
        }
            break;
            
        default:
            break;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
