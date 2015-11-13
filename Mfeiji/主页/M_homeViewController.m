//
//  M_homeViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-20.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_homeViewController.h"
#import "MainViewController.h"
#import "Exam_xuanYi_ViewController.h"
#import "Exam_guDingYi_ViewController.h"
#import "M_setViewController.h"
#import "M_schoolViewController.h"
#import "M_notification_ViewController.h"
#import "Exam_loginViewController.h"

@interface M_homeViewController ()<UITextFieldDelegate>
{
    UIImageView *backgroudView;
    UIImageView *headView;
    UILabel *nameLable;

    UIImageView *userImage;
    UIImageView *userBackgroundView;
    UITextField *nameText;
    NSArray *notifArr;
    UIButton * notifiBt;
}
@end

@implementation M_homeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self requstNotif];
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
    backgroudView = [[UIImageView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, Main_Screen_Width, Main_Screen_Height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    backgroudView.userInteractionEnabled = YES;
    [self.view addSubview:backgroudView];
    [self drawView];
    [self requstNotif];
}

-(void)requstNotif
{
    NSString * time = [[NSUserDefaults standardUserDefaults] objectForKey:@"notificationTime"];
    if (time ==nil) {
        NSString * strtimr = [Pulic_class getTime];
        time = strtimr;
    }
//    NSLog(@"home time=%@",time);
     NSString *str =[[NSString alloc] initWithFormat:@"http://api.mfeiji.com/v1/notices?time=%@",time];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arr = responseObject;
//        NSLog(@"noti =%lu",(unsigned long)arr.count);
        [notifiBt removeFromSuperview];
//        NSLog(@"arr =%@",arr);
        if (arr.count >0) {
            notifArr = arr;
            [self drawNotification];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}
-(void)drawNotification
{
    if (notifArr.count>0) {
        notifiBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        notifiBt.frame = CGRectMake(Main_Screen_Width/2+20, Main_Screen_Height/2 -120-49-60, 16, 16);
        [notifiBt setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)notifArr.count] forState:UIControlStateNormal];
        [notifiBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        notifiBt.backgroundColor = [UIColor colorWithRed:226/255. green:52/255. blue:90/255. alpha:1.];
        notifiBt.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.];
        [notifiBt.layer setCornerRadius:8];
        [backgroudView addSubview:notifiBt];
        if (Main_Screen_Height < 570) {
            notifiBt.frame = CGRectMake(Main_Screen_Width/2+20, Main_Screen_Height/2 -120-49-50, 16, 16);
        }
    }
}

-(void)notificationPage
{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    if ([str isEqualToString:@"麦飞机会员"]) {
        Exam_loginViewController * login = [[Exam_loginViewController alloc] init];
        login.flag = 111;
        [self.navigationController pushViewController:login animated:YES];
        
    }else{
       [notifiBt removeFromSuperview];
        MainViewController * tabbar = (MainViewController *)self.tabBarController;
        [tabbar hiddenTabBar];
        M_notification_ViewController * no = [[M_notification_ViewController alloc] init];
        [self.navigationController pushViewController:no animated:YES];
    }
}

-(void)drawView
{
    headView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-35, Main_Screen_Height/2 -120-49-70 , 70  , 70)];
    NSString * url = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];

    [headView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    if (headView.image ==nil) {
         headView.image = [UIImage imageNamed:@"test.jpg"];
    }
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *nextPage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notificationPage)];
    [headView addGestureRecognizer:nextPage];

    [backgroudView addSubview:headView];
    if (Main_Screen_Height <580) {
        headView.frame = CGRectMake(Main_Screen_Width/2-35, Main_Screen_Height/2-120-49-55 , 70  , 70);
    }
    //圆角设置
    headView.layer.cornerRadius = 35;
    headView.layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [headView.layer setBorderWidth:2];
    [headView.layer setBorderColor:[[UIColor colorWithRed:50./255 green:71./255 blue:121./255 alpha:1.] CGColor]];  //设置边框为蓝色
    //自动适应,保持图片宽高比
//    headView.contentMode = UIViewContentModeScaleAspectFit;
    nameLable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, self.view.frame.size.height/2 -120-49, 120, 20)];
    nameLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = [UIFont systemFontOfSize:14.];
    [backgroudView addSubview:nameLable];
    if (Main_Screen_Height <580) {
        nameLable.frame = CGRectMake(Main_Screen_Width/2-40, Main_Screen_Height/2-120-32 , 80  , 20);
    }
    NSArray * lableArr = [[NSArray alloc] initWithObjects:@"发现之旅",@"通航学校",@"旋翼航空器",@"固定翼航空器", nil];
    for (int i = 1; i<5; i++) {
        UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-120, self.view.frame.size.height/2 -120-49, 90, 90)];
        [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_%d.png",i]] forState:UIControlStateNormal];
        bt.tag = i;
        [bt addTarget:self action:@selector(homeChoose:) forControlEvents:UIControlEventTouchUpInside];
        [backgroudView addSubview:bt];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height/2 -30-49, 90, 20)];
        lable.text = [lableArr objectAtIndex:i-1];
        lable.textColor = [UIColor colorWithRed:68./255 green:103./255 blue:169./255 alpha:1.];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14.];
        [backgroudView addSubview:lable];
        
        if (i%2 == 0) {
            bt.frame = CGRectMake(self.view.frame.size.width/2 +30, self.view.frame.size.height/2 -120-49+70*(i-1), 90, 90);
            lable.frame = CGRectMake(self.view.frame.size.width/2 +30, self.view.frame.size.height/2-30-49+70*(i-1), 90, 20);
        }else
        {
            bt.frame = CGRectMake(self.view.frame.size.width/2-120 , self.view.frame.size.height/2 -120-49 +70*i, 90, 90);
            lable.frame = CGRectMake(self.view.frame.size.width/2-120 , self.view.frame.size.height/2 -30-49+70*i, 90, 20);
        }
    }
}

-(void)homeChoose:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar hiddenTabBar];
            M_setViewController * finde = [[M_setViewController alloc] init];
            finde.flag=1;
            [self.navigationController pushViewController:finde animated:YES];
        }
            break;
        case 2:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar hiddenTabBar];
            M_schoolViewController *scholl = [[M_schoolViewController alloc] init];
            scholl.flag=1;
            [self.navigationController pushViewController:scholl animated:YES];
        }
            break;
        case 3:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar hiddenTabBar];
            [[NSUserDefaults standardUserDefaults] setObject:@"私用航空器（直升机）考试系统" forKey:@"title"];
            Exam_xuanYi_ViewController *xuan = [[Exam_xuanYi_ViewController alloc] init];
            xuan.flag =1;
            [self.navigationController pushViewController:xuan animated:YES];
        }
            break;
        case 4:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar hiddenTabBar];
            [[NSUserDefaults standardUserDefaults] setObject:@"私用航空器（固定翼）考试系统" forKey:@"title"];
            Exam_guDingYi_ViewController *gu =[[Exam_guDingYi_ViewController alloc] init];
            gu.flag =1;
            [self.navigationController pushViewController:gu animated:YES];
        }
            break;

        default:
            break;
    }
    
    [userBackgroundView removeFromSuperview];
    MainViewController * tabbar = (MainViewController *)self.tabBarController;
    [tabbar hiddenTabBarNo];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == nameText) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
