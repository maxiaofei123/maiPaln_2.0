//
//  Exam_guDingYi_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-21.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Exam_guDingYi_ViewController.h"
#import "Exam_sizhao_ViewController.h"
#import "Exam_loginViewController.h"

@interface Exam_guDingYi_ViewController ()
{
    UIView * backgroudView;
}
@end

@implementation Exam_guDingYi_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    
    [self drawView];
}


-(void)drawView
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(guDingChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 221;
    [backgroudView addSubview:backBt];
    
//    UIButton *shareBt =[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 11, 30, 30)];
//    [shareBt setImage:[UIImage imageNamed:@"public_share.png"] forState:UIControlStateNormal];
//    [shareBt addTarget:self action:@selector(guDingChoose:) forControlEvents:UIControlEventTouchUpInside];
//    shareBt.tag = 222;
//    [backgroudView addSubview:shareBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -75, 15, 150, 20)];
    title.text = @"麦飞机模拟考试系统";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
    
    // view
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 -45, Main_Screen_Height/2-200, 90, 90)];
    image.image = [UIImage imageNamed:@"home_4.png"];
    [backgroudView addSubview:image];
    if (Main_Screen_Height <560) {
        image.frame =CGRectMake(Main_Screen_Width/2 -45, Main_Screen_Height/2-190, 90, 90);
    }
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-45,Main_Screen_Height/2 -100, 90, 20)];
    lable.text = @"固定翼航空器";
    lable.textColor = [UIColor colorWithRed:93./255 green:120./255 blue:170./255 alpha:1.];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14.];
    [backgroudView addSubview:lable];
    
    UIButton *sizhaoBt =[[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-70, Main_Screen_Height/2-50, 140, 39)];
    [sizhaoBt setImage:[UIImage imageNamed:@"exam_sizhao.png"] forState:UIControlStateNormal];
    sizhaoBt.tag = 223;
    [sizhaoBt addTarget:self action:@selector(guDingChoose:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:sizhaoBt];
    
    UIButton *shangzhaoBt =[[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-70,Main_Screen_Height/2+5, 140, 39)];
    [shangzhaoBt setImage:[UIImage imageNamed:@"exam_shangzhao.png"] forState:UIControlStateNormal];
    shangzhaoBt.tag =224;
    [shangzhaoBt addTarget:self action:@selector(guDingChoose:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:shangzhaoBt];
}


-(void)guDingChoose: (UIButton *)sender
{
    switch (sender.tag) {
        case 221:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar showTabBar];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 222:

            break;
        case 223:

        {
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
            if ([str isEqualToString:@"麦飞机会员"]) {
                Exam_loginViewController * sizhao = [[Exam_loginViewController alloc] init];
                sizhao.classflag = 3;
                sizhao.testflag = self.flag;
                [self.navigationController pushViewController:sizhao animated:YES];
            }else
            {
                if (self.flag ==1) {
                    MainViewController * tabbar = (MainViewController *)self.tabBarController;
                    [tabbar hiddenTabBar];
                }
                
                //跳转到私照考试页
                Exam_sizhao_ViewController * sizhao = [[Exam_sizhao_ViewController alloc] init];
                sizhao.classflag =3;
                 sizhao.flag = self.flag;
                [self.navigationController pushViewController:sizhao animated:YES];
            }
        }

            break;
        case 224:
        {
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
            if ([str isEqualToString:@"麦飞机会员"]) {
                Exam_loginViewController * sizhao = [[Exam_loginViewController alloc] init];
                sizhao.classflag = 4;
                sizhao.testflag = self.flag;
                [self.navigationController pushViewController:sizhao animated:YES];
            }else
            {
                if (self.flag ==1) {
                    MainViewController * tabbar = (MainViewController *)self.tabBarController;
                    [tabbar hiddenTabBar];
                }
                
                //跳转到私照考试页
                Exam_sizhao_ViewController * sizhao = [[Exam_sizhao_ViewController alloc] init];
                sizhao.classflag =4;
                 sizhao.flag = self.flag;
                [self.navigationController pushViewController:sizhao animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
