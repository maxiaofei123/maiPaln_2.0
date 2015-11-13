//
//  M_phoneReg_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-11-21.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_phoneReg_ViewController.h"
#import "JSONKit.h"
@interface M_phoneReg_ViewController ()<UITextFieldDelegate>
{
    NSArray *nameArr;
    NSMutableArray *textNameArr;
    UITextField *userName;
    UITextField *passWorld;
    UITextField *email;
    MBProgressHUD *HUD;
}
@end

@implementation M_phoneReg_ViewController
@synthesize regScroll;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    regScroll = [[UIView alloc] initWithFrame:CGRectMake(0, 20, Main_Screen_Width, Main_Screen_Height)];
    regScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:regScroll];
    UITapGestureRecognizer *textFeild = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldEditing)];
    [regScroll addGestureRecognizer:textFeild];
    
    nameArr = [[NSArray alloc] initWithObjects:@"用户名:",@"邮   箱:",@"密   码:", nil];
    textNameArr = [[NSMutableArray alloc] init];
    [self regDrawNav];
    [self regView];
    
}

-(void)regDrawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(regChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 1;
    [regScroll addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"用户注册";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [regScroll addSubview:title];
}

-(void)regView
{
   //输入框
    for (int i=0; i<3; i++) {
        UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-110, Main_Screen_Height/2-180 + i*50, 100, 25)];
        l.text = [nameArr objectAtIndex:i];
        l.font = [UIFont systemFontOfSize:13.];
        l.textColor = [UIColor colorWithRed:68./255 green:103./255 blue:169./255 alpha:1.];
        [regScroll addSubview:l];
        
        UIImageView *vi = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-60 , Main_Screen_Height/2-180+i*50, 180, 28)];
        vi.userInteractionEnabled = YES;
        vi.image = [UIImage imageNamed:@"chnagePwdText.png"];
        [regScroll addSubview:vi];
        
        UITextField * text = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 160, 28)];
        text.placeholder = @"请输入6-15个字符";
        text.delegate = self;
        text.returnKeyType = UIReturnKeyNext;
        text.font = [UIFont systemFontOfSize:14];
        text.textColor = [UIColor whiteColor];
        [text setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [text setValue:[UIFont boldSystemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
        [vi addSubview:text];
        if (i ==1 ) {
            text.placeholder = @"请输入一个常用邮箱地址";
        }else if(i ==2)
        {
            text.placeholder = @"请输入6-20位密码";
            text.secureTextEntry = YES;
        }
        [textNameArr addObject:text];
    }

    userName = [textNameArr objectAtIndex:0];
    email = [textNameArr objectAtIndex:1];
    passWorld = [textNameArr objectAtIndex:2];

//同意协议
    UIButton * agreeBt = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 -75, Main_Screen_Height/2 -35, 15, 15)];
    [agreeBt setImage:[UIImage imageNamed:@"agree.png"] forState:UIControlStateNormal];
    [regScroll addSubview:agreeBt];
    
    UILabel *agreeLable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 -53, Main_Screen_Height/2 -35, 150, 15)];
    agreeLable.text = @"同意麦飞机注册会员协议";
    agreeLable.textColor = [UIColor whiteColor];
    agreeLable.font = [UIFont systemFontOfSize:11.];
    [regScroll addSubview:agreeLable];
    
 //注册
    UIButton *regBt = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 -50, Main_Screen_Height/2, 100, 27)];
    [regBt setImage:[UIImage imageNamed:@"regCommit.png"] forState:UIControlStateNormal];
    [regBt addTarget:self action:@selector(reg) forControlEvents:UIControlEventTouchUpInside];
    [regScroll addSubview:regBt];
    
}
- (int)getToInt:(NSString*)strtemp

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}
-(void)reg
{
    int lenghth  = [self getToInt:userName.text];
    NSString *msg=@"ok";
    if(userName.text.length==0)
    {
        msg=@"请输入用户名";
        
    }else if(lenghth<6||lenghth>15)
    {
        msg=@"请输入6~15个字符";
    }else if(![self CheckInput:email.text]){
        msg = @"您的邮箱格式不正确，请检查";
    }
    else if(passWorld.text.length==0)
    {
        msg=@"请输入密码";
    }
    else if(passWorld.text.length<6||passWorld.text.length>20)
    {
        msg=@"请输入6－20位密码";
        
    }
     HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([msg isEqualToString:@"ok"]) {
        
        //zhuce
        HUD.labelText = @"正在注册中...";
        
        NSDictionary * dic =[[NSDictionary alloc] initWithObjectsAndKeys:userName.text,@"user[name]",passWorld.text,@"user[password]",email.text,@"user[email]", nil];
//        NSLog(@"reg dic =%@",dic);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users?"] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * res =[[NSDictionary alloc] init];
            res = responseObject;
            HUD.labelText = [NSString stringWithFormat:@"注册成功"];
            [HUD hide:YES afterDelay:1.];
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar showTabBar];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSDictionary *  dic = error.userInfo;
            NSData * data = [dic objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary * strDic =  [str objectFromJSONString];//返回的错误信息
            NSArray * arr = [strDic allKeys];
            NSString * msg1;
            if (arr.count>0) {
                NSString *test = [strDic objectForKey:[arr objectAtIndex:0]];
                if ([[arr objectAtIndex:0] isEqualToString:@"email"]) {
                    msg1 =@"邮箱已经被使用";
                }else if([[arr objectAtIndex:0] isEqualToString:@"name"]) {
                    msg1 = @"用户名已经被使用";
                }else
                {
                    msg1 = test;
                }
            }
            if (msg1.length<1) {
                msg1 = @"登陆失败,请检查网络链接";
            }
            HUD.labelText = msg1;
            [HUD hide:YES afterDelay:1];
        }];
        
    }else
    {
        HUD.labelText = [NSString stringWithFormat:@"%@",msg];
        [HUD hide:YES afterDelay:1.];
    }
}


-(void)regChoose:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar showTabBar];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(BOOL)CheckInput:(NSString *)_text{
    NSString *Regex=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [emailTest evaluateWithObject:_text];
}

//隐藏键盘
-(void)textFieldEditing
{
    [userName resignFirstResponder];
    [passWorld resignFirstResponder];
    [email resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


@end
