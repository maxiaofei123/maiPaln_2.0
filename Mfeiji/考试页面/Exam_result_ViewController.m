//
//  Exam_result_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-1.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Exam_result_ViewController.h"
#import "Test_checkAnswerNumber_ViewController.h"
#import "M_paiHang_ViewController.h"
@interface Exam_result_ViewController ()<UIActionSheetDelegate>
{
    NSArray *lableArr;
    UIView *backgroudView;
    UIView *whiteView ;
    NSString * avatar;
    NSString * rank;
}
@end

@implementation Exam_result_ViewController
@synthesize useSec,useTime,resultScore,checkDic,zhuangtai;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height-49-64)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backgroudView addSubview:whiteView];
    
    lableArr = [[NSArray alloc] initWithObjects:@"成绩:",@"用时:", nil];
    [self drawNav];
    [self drawTabar];
    [self drawView];
    [self commitScore];
    [self commitMyself];
}


-(void)commitScore
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString * score= [NSString stringWithFormat:@"%.2f",self.resultScore];
    
    NSDictionary * managerDic = [[NSDictionary alloc] initWithObjectsAndKeys:email,@"user_email",token,@"user_token",userId ,@"score[user_id]",score,@"score[number]",[self.checkDic objectForKey:@"testYiDaId"],@"score[score_lines]", nil];
    
//    NSLog(@"str =%@",managerDic);
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在请求...";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://api.mfeiji.com/v1/scores/" parameters:managerDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary * dic =responseObject;

//        NSLog(@"dic =%@",dic);
        HUD.labelText = @"提交成功。。。";
        [HUD hide:YES afterDelay:1.];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error =%@",error);
        HUD.labelText = @"请求失败,请检查网络链接";
        [HUD hide:YES afterDelay:1.];
    }];
}


-(void)drawView
{
    
    NSString * name =[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if (name ==nil ) {
        name =@"";
    }
    
    UILabel * userLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 140, 200, 20)];
    userLable.text = [NSString stringWithFormat:@"%@:",name];
    userLable.textColor = [UIColor colorWithRed:107/255. green:135/255. blue:182/255. alpha:1.];
    userLable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:userLable];
    
    UILabel * tishiL = [[UILabel alloc] initWithFrame:CGRectMake(50, 165, 270, 40)];
    tishiL.font = [UIFont systemFontOfSize:16];
    tishiL.lineBreakMode = NSLineBreakByWordWrapping;
    tishiL.numberOfLines = 0;
    tishiL.textColor = [UIColor colorWithRed:107/255. green:135/255. blue:182/255. alpha:1.];
    [self.view addSubview:tishiL];
    if (resultScore < 80) {
        tishiL.text =@"您的梦想已经折断了双翼，请继续战斗!";
    }else
    {
        tishiL.text =@"恭喜您，即将翱翔在蓝天之上，快去飞行吧!";
    }

    for (int i =0 ; i<2; i++) {
        UILabel * Lable =[[UILabel alloc] initWithFrame:CGRectMake(50, 230+i*30, 200, 20)];
        Lable.textColor = [UIColor colorWithRed:107/255. green:135/255. blue:182/255. alpha:1.];
        if (i==0) {
            Lable.text = [NSString stringWithFormat:@"%@   %.2f   分",[lableArr objectAtIndex:i],resultScore];
        }
        else if (i ==1 ) {
            Lable.text = [NSString stringWithFormat:@"%@   %d   分  %d   秒",[lableArr objectAtIndex:i],useTime,useSec];
        }
        else{
            Lable.text =[lableArr objectAtIndex:i];
        }
        [self.view addSubview:Lable];
    }
}

- (void)drawNav
{
    UIButton *lButton =[[UIButton alloc] init];
    lButton =[UIButton buttonWithType:0];
    [lButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [lButton setFrame:CGRectMake(10, 11, 30, 30)];
    lButton.tag = 1;
    [lButton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:lButton];

    UILabel *exitLable = [[UILabel alloc] initWithFrame:CGRectMake(42, 15, 30, 20)];
    exitLable.text = @"退出";
    exitLable.textColor =[UIColor whiteColor];
    exitLable.font = [UIFont systemFontOfSize:12.];
    exitLable.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:exitLable];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -75, 15, 150, 20)];
    title.text = @"考试结果";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];

    UIButton *shareBt =[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 11, 30, 30)];
    [shareBt setImage:[UIImage imageNamed:@"public_share.png"] forState:UIControlStateNormal];
    [shareBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    shareBt.tag = 3;
    [backgroudView addSubview:shareBt];
    
}

-(void)drawTabar
{
    UIButton *shareBt =[[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-40, whiteView.frame.size.height/2+60, 80, 35)];
    [shareBt setImage:[UIImage imageNamed:@"result_share.png"] forState:UIControlStateNormal];
    shareBt.tag = 3;
    [shareBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:shareBt];
    
    
    UIButton *Lbutton = [[UIButton alloc] initWithFrame:CGRectMake(10, Main_Screen_Height-60, 50, 43)];
    [Lbutton setImage:[UIImage imageNamed:@"checkAnser.png"] forState:UIControlStateNormal];
    Lbutton.tag = 4;
    [Lbutton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:Lbutton];
    
    UIButton *Rbutton = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width-60 , Main_Screen_Height-60, 50, 43)];
    [Rbutton setImage:[UIImage imageNamed:@"PaiHang.png"] forState:UIControlStateNormal];
    Rbutton.tag = 5;
    [Rbutton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:Rbutton];
  
}


-(void)choose:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar showTabBar];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
          break;
        case 3:
        {
            // fenxiang
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到微信好友",@"分享到朋友圈", nil];
            [sheet showInView:self.view];
            
        }
            break;
        case 4://查看答案
        {
            Test_checkAnswerNumber_ViewController *check = [[Test_checkAnswerNumber_ViewController alloc] init];
            check.wrDic = checkDic;
            check.zhuangtaiDic = zhuangtai;
            [self.navigationController pushViewController:check animated:YES];
        }
            break;
        case 5:
        {
            M_paiHang_ViewController * pai = [[M_paiHang_ViewController alloc] init];
            pai.tag =1;
            pai.rank = rank;
            pai.avatarUrl =avatar;
            [self.navigationController pushViewController:pai animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * url = [[NSUserDefaults standardUserDefaults]objectForKey:@"avatar"];
    NSData * date = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString * strtitle;
    if (resultScore < 80) {
        strtitle =[NSString stringWithFormat:@"您的梦想已经折断了双翼，请继续战斗"];
    }else
    {
        strtitle =[NSString stringWithFormat:@"恭喜您，即将翱翔在蓝天之上，快去飞行吧！"];
    }
    if (buttonIndex == 0) {
        [Pulic_class sendLinkContent:0 title:strtitle image:[UIImage imageWithData:date] url:@"https://itunes.apple.com/us/app/mai-fei-ji/id920281189?l=zh&ls=1&mt=8"];
    }else if (buttonIndex == 1){
       [Pulic_class sendLinkContent:1 title:strtitle image:[UIImage imageWithData:date] url:@"https://itunes.apple.com/us/app/mai-fei-ji/id920281189?l=zh&ls=1&mt=8"];
    }
}

-(void)commitMyself
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
    NSDictionary * dic =[[NSDictionary alloc] initWithObjectsAndKeys:token,@"user_token", email,@"user_email",nil];
    NSString *str =[[NSString alloc] initWithFormat:@"http://api.mfeiji.com/v1/users/%@",userId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      
        NSDictionary * dic =responseObject;
        NSString * av = [NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
        if ([av isEqualToString:@"<null>"]) {
            av = @"";
        }
        avatar = av;
        rank = [dic objectForKey:@"rank"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"erro =%@",error);
    }];
}

@end
