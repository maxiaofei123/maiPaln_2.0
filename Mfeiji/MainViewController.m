//
//  MainViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-24.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "MainViewController.h"
#import "M_homeViewController.h"
#import "M_examViewController.h"
#import "M_myselfViewController.h"
#import "M_schoolViewController.h"
#import "M_setViewController.h"

@interface MainViewController ()
{
    UIView *TabBarBG;
    NSMutableArray * btArr;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    [self loadViewControllers];
    [self loadCustumTabBarView];
}

-(void)loadViewControllers{
   
    //1
    M_homeViewController *firstView = [[M_homeViewController alloc] init];
    UINavigationController *fistNv = [[UINavigationController alloc] initWithRootViewController:firstView];

    //2
    M_examViewController *secondView = [[M_examViewController alloc] init];
    UINavigationController *secondNv = [[UINavigationController alloc] initWithRootViewController:secondView];

    //3
    M_myselfViewController *thirdView = [[M_myselfViewController alloc] init];
    UINavigationController *thirdNv = [[UINavigationController alloc] initWithRootViewController:thirdView];

    //4
    M_schoolViewController *fourView = [[M_schoolViewController alloc] init];
    UINavigationController *fourNv = [[UINavigationController alloc] initWithRootViewController:fourView];

    //5
    M_setViewController * fiveView = [[M_setViewController alloc] init];
    UINavigationController * fiveNv = [[UINavigationController alloc] initWithRootViewController: fiveView];
    
    NSArray *viewControllers = [NSArray  arrayWithObjects:fistNv,secondNv,thirdNv,fourNv, fiveNv,nil];
    [self setViewControllers:viewControllers animated:YES];
}

-(void)loadCustumTabBarView
{
    // 初始化自定义tabbar背景
    TabBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-49, Main_Screen_Width, 49)];
    TabBarBG.backgroundColor = [UIColor colorWithRed:20./255 green:34./255 blue:61./255 alpha:1.];
    [self.view addSubview:TabBarBG];
    
    //初始化自定义tabbaritem  ->button
    float coordX = 0;
    btArr = [[NSMutableArray alloc] init];
    for (int i =0 ; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        button.tag = i;
        button.frame = CGRectMake((self.view.frame.size.width/5-30)/2+coordX, 7, 30, 40);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",i+1]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i_2.png",i+1]] forState:UIControlStateSelected];
        button.selected = NO;
        [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        [TabBarBG addSubview:button];
        [btArr addObject:button];
        coordX += self.view.frame.size.width/5;
        if (i==0) {
            button.selected = YES;
        }
    }
}

-(void)changeViewController:(UIButton *)sender
{
    self.selectedIndex =  sender.tag;
    sender.selected = YES;
    for (int i =0 ; i<5; i++) {
        if (i == sender.tag) {
            UIButton * bt = [btArr objectAtIndex:i] ;
            bt.selected = YES;
        }
        else
        {
            UIButton * bt = [btArr objectAtIndex:i] ;
            bt.selected = NO;
        }
    }
}

//显示tabbar
-(void)showTabBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    TabBarBG.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
    [UIView commitAnimations];
   
}

//隐藏tabbar
-(void)hiddenTabBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.22];
    TabBarBG.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-49, self.view.frame.size.width, 49);
    [UIView commitAnimations];

}

-(void)hiddenTabBarNo
{
    TabBarBG.hidden = NO;
}

-(void)hiddenTabBarYes
{
    TabBarBG.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
