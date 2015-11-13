//
//  Test_checkAnswerNumber_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-7.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Test_checkAnswerNumber_ViewController.h"
#import "Test_checkAnswer_ViewController.h"

@interface Test_checkAnswerNumber_ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * checkTableView;
    int questionNumber;
    UIView * backgroudView;
}

@end

@implementation Test_checkAnswerNumber_ViewController
@synthesize wrDic;

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
    title.text = @"查看答案";
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
        Test_checkAnswer_ViewController *anwser = [[Test_checkAnswer_ViewController alloc] init];
        anwser.showDic = wrDic;
        anwser.textId = sender.tag;
        anwser.ztDic = _zhuangtaiDic;
        [self.navigationController pushViewController:anwser animated:YES];
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

    for (int i =0; i< 5; i++) {
        //题号
        UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width/5)*i, 0.5, Main_Screen_Width/5, Main_Screen_Width/5-0.5)];
        [bt setTitle:[NSString stringWithFormat:@"%ld",(indexPath.row*5 +(i + 1))] forState:UIControlStateNormal];
        [bt setTitle:[NSString stringWithFormat:@"%ld",(indexPath.row*5 +(i + 1))] forState:UIControlStateSelected];
        bt.titleLabel.textColor = [UIColor blackColor];
        bt.tag = indexPath.row*5 +i ;
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:bt];
        
        //添加分界线
        UIView * btLine = [[UIView alloc] initWithFrame:CGRectMake(Main_Screen_Width/5*i, 0, 0.5, Main_Screen_Width/5)];
        btLine.backgroundColor = [UIColor grayColor];
        [cell addSubview:btLine];
        
        UIView * line =[[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Width/5, Main_Screen_Width, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        line.alpha =1;
        [cell.contentView addSubview:line];
        
        //对的错的
        NSArray * wrongArr = [[NSArray alloc] init];
        wrongArr = [wrDic objectForKey:@"wrongArr"] ;
        for (int j =0; j < wrongArr.count ; j++) {
            NSString * str =[[NSString alloc] initWithFormat:@"%@",[wrongArr objectAtIndex:j]];
            int com = [str intValue];
            if (com == (indexPath.row*5 +i)) {
                bt.backgroundColor = [UIColor colorWithRed:255./255 green:213./255 blue:228./255 alpha:1];
                bt.titleLabel.textColor = [UIColor redColor];
            }
        }
        
        NSArray * rArr = [[NSArray alloc] init];
        rArr = [wrDic objectForKey:@"weidaArr"] ;
        for (int k =0; k < rArr.count ; k++) {
            NSString * str =[[NSString alloc] initWithFormat:@"%@",[rArr objectAtIndex:k]];
            int com = [str intValue];
            if (com == (indexPath.row*5 +i)) {
                bt.backgroundColor = [UIColor whiteColor];
            }
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
    return 16;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
