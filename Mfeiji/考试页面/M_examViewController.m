//
//  M_examViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-20.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_examViewController.h"
#import "Exam_guDingYi_ViewController.h"
#import "Exam_xuanYi_ViewController.h"
#import "MainViewController.h"
@interface M_examViewController ()
{
    UIView *backgroudView;
}
@end

@implementation M_examViewController

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
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -75, 15, 150, 20)];
    title.text = @"麦飞机模拟考试系统";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
    // view
    NSArray * lableArr = [[NSArray alloc] initWithObjects:@"旋翼航空器",@"固定翼航空器", nil];
    for (int i = 0; i<2; i++) {
        
        UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -45, self.view.frame.size.height/2 -170 +150*i, 90, 90)];
        [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_%d.png",i+3]] forState:UIControlStateNormal];
        bt.tag = 202+i;
        [bt addTarget:self action:@selector(examChoose:) forControlEvents:UIControlEventTouchUpInside];
        [backgroudView addSubview:bt];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -45, self.view.frame.size.height/2 -77 +153*i, 90, 20)];
        lable.text = [lableArr objectAtIndex:i];
        lable.textColor = [UIColor colorWithRed:93./255 green:120./255 blue:170./255 alpha:1.];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14.];
        [backgroudView addSubview:lable];

    }
}


-(void)examChoose: (UIButton *)sender
{
   
    switch (sender.tag) {
        case 200:
        {
        
        }
            break;
        case 201:
            
            break;
        case 202:
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"私用航空器（直升机）考试系统" forKey:@"title"];
            Exam_xuanYi_ViewController *xuan = [[Exam_xuanYi_ViewController alloc] init];
            [self.navigationController pushViewController:xuan animated:YES];
        }
            break;
        case 203:
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"私用航空器（固定翼）考试系统" forKey:@"title"];
             Exam_guDingYi_ViewController *GU = [[Exam_guDingYi_ViewController alloc] init];
            [self.navigationController pushViewController:GU animated:YES];
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
