//
//  Test_noAnswer_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-7.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Test_noAnswer_ViewController.h"
#import "Exam_test_ViewController.h"
#import "CycleScrollView.h"

@interface Test_noAnswer_ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * checkTableView;
    int questionNumber;
    UIView * backgroudView;
}
@end

@implementation Test_noAnswer_ViewController
@synthesize weidaArry ,delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, Main_Screen_Width,Main_Screen_Height-20);
    backgroudView.backgroundColor = [UIColor colorWithRed:35./255 green:41./255 blue:70./255 alpha:1.];
    [self.view addSubview:backgroudView];
    
    UIView * huiBg = [[UIView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height-70)];
    huiBg.backgroundColor = [UIColor colorWithRed:239./255 green:239./255 blue:239./255 alpha:1.];
    [backgroudView addSubview:huiBg];
    
    checkTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width, Main_Screen_Height-70)];
    checkTableView.delegate =self;
    checkTableView.dataSource =self;
    checkTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    checkTableView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:checkTableView];
    
    [self drawNav];

}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 111;
    [backgroudView addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"未做题目";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
}

-(void)choose:(UIButton *)sender
{
    if (sender.tag ==111) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if([delegate respondsToSelector:@selector(setQuestionTest:)])
        {
            [delegate setQuestionTest:((int)sender.tag-1)];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
        
    }else{
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];//取消cell点击效果
    cell.backgroundColor= [UIColor clearColor];
    
    UIView * line =[[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Width/5-0.5, Main_Screen_Width, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha =1;
    [cell.contentView addSubview:line];
    if (indexPath.row ==0) {
        UIView * line1 =[[UIView alloc] initWithFrame:CGRectMake(0, 0.5, Main_Screen_Width, 0.5)];
        line1.backgroundColor = [UIColor grayColor];
        line1.alpha =1;
        [cell.contentView addSubview:line1];
    }
    for (int i =0; i< 5; i++) {
        //题号
        if ((indexPath.row*5 +i)<weidaArry.count) {
            NSString * str = [weidaArry objectAtIndex:(indexPath.row*5 +i )];
            UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width/5)*i, 0.5, Main_Screen_Width/5, Main_Screen_Width/5)];
            [bt setTitle:[NSString stringWithFormat:@"%@",[weidaArry objectAtIndex:(indexPath.row*5 +i)]] forState:UIControlStateNormal];
            [bt setTitle:[NSString stringWithFormat:@"%@",[weidaArry objectAtIndex:(indexPath.row*5 +i)]] forState:UIControlStateSelected];
            [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bt.tag = [str intValue] ;
            [bt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:bt];
            //添加分界线
            UIView * btLine = [[UIView alloc] initWithFrame:CGRectMake((Main_Screen_Width/5-0.5)*i, 0, 0.5, Main_Screen_Width/5)];
            btLine.backgroundColor = [UIColor grayColor];
            [cell addSubview:btLine];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Main_Screen_Width/5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (weidaArry.count%5 >0) {
        return (weidaArry.count/5 +1);
    }
    return (weidaArry.count/5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
