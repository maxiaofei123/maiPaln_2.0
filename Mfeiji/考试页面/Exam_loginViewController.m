//
//  Exam_loginViewController.m
//  Mfeiji
//
//  Created by susu on 14-11-26.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Exam_loginViewController.h"
#import "M_phoneReg_ViewController.h"
#import "Exam_sizhao_ViewController.h"
#import "user_forgetPwd_ViewController.h"
#import "JSONKit.h"

@interface Exam_loginViewController ()
{
    UIView * backgroudView;
    UITextField * userNameText;
    UITextField * pwdText;

}
@end

@implementation Exam_loginViewController
@synthesize flag;

- (void)viewWillAppear:(BOOL)animated
{
    userNameText.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pwdText.text = @"";
    if (flag == 111 || flag ==222) {
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        if ([str isEqualToString:@"麦飞机会员"]) {
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    UITapGestureRecognizer *textFeild = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldEditing)];
    [backgroudView addGestureRecognizer:textFeild];
    
    if (flag == 222) {
        
    }else {
        UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
        [backBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        backBt.tag = 1;
        [backgroudView addSubview:backBt];
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"用户登录";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
    [self drawLoginView];
}

-(void)drawLoginView
{
    //用户名、密码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:userNameText];
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-90, Main_Screen_Height/2 -180, 180, 35)];
    userImage.image = [UIImage imageNamed:@"exam_user.png"];
    userImage.userInteractionEnabled = YES;
    [backgroudView addSubview:userImage];
    userNameText = [[UITextField alloc] initWithFrame:CGRectMake(30, 3, 150, 30)];
    userNameText.placeholder = @"用户名/邮箱/手机号";
    [userNameText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [userNameText setValue:[UIFont boldSystemFontOfSize:11.] forKeyPath:@"_placeholderLabel.font"];
    userNameText.font = [UIFont systemFontOfSize:14.];
    userNameText.textColor = [UIColor whiteColor];
    [userImage addSubview:userNameText];
    
    UIImageView *pwdImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-90, Main_Screen_Height/2-140, 180, 35)];
    pwdImage.image = [UIImage imageNamed:@"exam_pwd.png"];
    pwdImage.userInteractionEnabled = YES;
    [backgroudView addSubview:pwdImage];
    pwdText = [[UITextField alloc] initWithFrame:CGRectMake(30, 3, 150, 30)];
    pwdText.placeholder = @"输入密码";
    [pwdText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [pwdText setValue:[UIFont boldSystemFontOfSize:11.] forKeyPath:@"_placeholderLabel.font"];
    pwdText.secureTextEntry = YES;
    pwdText.font = [UIFont systemFontOfSize:14.];
    pwdText.textColor = [UIColor whiteColor];
    [pwdImage addSubview:pwdText];
    
    //登陆
    
    UIButton *loginBt = [[UIButton alloc]initWithFrame: CGRectMake(Main_Screen_Width/2-60,Main_Screen_Height/2-90, 120, 30)];
    [loginBt setImage:[UIImage imageNamed:@"exam_loginBg.png"] forState:UIControlStateNormal];
    [loginBt addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBt.tag = 2;
    [backgroudView addSubview:loginBt];
    
    //忘记密码
    
    UIButton *lost = [UIButton buttonWithType:0];
    [lost setFrame:CGRectMake(Main_Screen_Width/2+20,Main_Screen_Height/2-45,80,20)];
    [lost setImage:[UIImage imageNamed:@"forgetPwd.png"] forState:UIControlStateNormal];
    lost.tag = 3;
    [lost addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:lost];
    
    //注册
    UIButton *zhuce = [UIButton buttonWithType:0];
    [zhuce setFrame:CGRectMake(Main_Screen_Width/2 -105,Main_Screen_Height/2 -45,80,20)];
    [zhuce setImage:[UIImage imageNamed:@"reg_name.png"] forState:UIControlStateNormal];
    zhuce.tag = 4;
    [zhuce addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:zhuce];
    //openid
    
//    //view  third
//    UIImageView *thirdView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-70, Main_Screen_Height/2 +85, 140, 15)];
//    thirdView.image = [UIImage imageNamed:@"thirdView.png"];
//    [backgroudView addSubview:thirdView];
//    
//    
//    UIButton *WxBT =[[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 -50, Main_Screen_Height/2+110,42 , 44)];
//    [WxBT setImage:[UIImage imageNamed:@"WX_login.png"] forState:UIControlStateNormal];
//    [WxBT addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
//    WxBT.tag = 5;
//    [backgroudView addSubview:WxBT];
//    
//    UIButton *WbBt =[[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 +8, Main_Screen_Height/2 +110, 42 , 44)];
//    [WbBt setImage:[UIImage imageNamed:@"WB_login.png"] forState:UIControlStateNormal];
//    [WbBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
//    WbBt.tag = 6;
//    [backgroudView addSubview:WbBt];

}

-(void) keyboardWillShow:(NSNotification *)note{
    if ( [userNameText.text isEqualToString:@"麦飞机会员"]) {
        userNameText.text = @"";
    }
}

-(void)choose:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 2://login
            break;
        case 3://lost passowrld
        {
            user_forgetPwd_ViewController *pwd = [[user_forgetPwd_ViewController alloc] init];
            [self.navigationController pushViewController:pwd animated:YES];
        }
            break;
  
        case 4://reg
        {
            flag = 108;
            M_phoneReg_ViewController *reg =[[M_phoneReg_ViewController  alloc]init];
            [self.navigationController pushViewController:reg animated:YES];
        }
            break;
            
        case 5://weiXin  login
            [self sendAuthRequest];

            break;

        case 6://weiBo  login
            break;
        default:
            break;
    }
}
#pragma mark -weiXinWeiBo

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = kAppDescription;
    [WXApi sendReq:req];
}
//使用RefreshToken刷新AccessToken
//该接口调用后，如果AccessToken未过期，则刷新有效期，如果已过期，更换AccessToken。
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWXAPP_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else{
                    //重新使用AccessToken获取信息
                }
            }
        });
    });
    
    
    /*
     "access_token" = “Oez****5tXA";
     "expires_in" = 7200;
     openid = ooV****p5cI;
     "refresh_token" = “Oez****QNFLcA";
     scope = "snsapi_userinfo,";
     */
    
    /*
     错误代码
     "errcode":40030,
     "errmsg":"invalid refresh_token"
     */
}

-(void)login
{
    NSString * msg = @"ok";
    if (!([userNameText.text length]>0)) {
        msg =@"请输入用户名";
    }
    else if(pwdText.text.length <6 || pwdText.text.length >20)
    {
        NSLog(@"ped =%@",pwdText.text);
        msg =@"请输入6-20位密码";
        
    }
    if ([msg isEqualToString:@"ok"]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在登录...";
        
        NSDictionary * dic =[[NSDictionary alloc] initWithObjectsAndKeys:pwdText.text,@"password", userNameText.text,@"login",nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/user_tokens?"] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
//            NSLog(@"res =%@",responseObject);
            NSDictionary * res = responseObject;
            [[NSUserDefaults standardUserDefaults] setObject:[res objectForKey:@"authentication_token"] forKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults] setObject:[res objectForKey:@"id"] forKey:@"userId"];
            //email
            [[NSUserDefaults standardUserDefaults] setObject:[res objectForKey:@"email"] forKey:@"user_email"];
            //username
            
            NSArray *  messegeArr = [[NSArray alloc] initWithObjects:@"name",@"email",@"gender",@"address",@"cell",@"top_score", @"avatar",@"rank",nil];
            NSMutableArray * infoArr = [[NSMutableArray alloc] init];
            for (int i =0; i<messegeArr.count; i++) {
                NSString * str = [NSString stringWithFormat:@"%@",[res objectForKey:[messegeArr objectAtIndex:i]]];
//                NSLog(@"str =%@",str);
                if ([str isEqualToString:@"(null)" ] || [str isEqualToString:@"<null>"])
                {
                    str = @"";
                }
                [infoArr addObject:str];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[infoArr objectAtIndex:6] forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults]setObject:[infoArr objectAtIndex:0 ]forKey:@"userName"];

            [[NSUserDefaults standardUserDefaults] setObject:infoArr forKey:@"myInfo"];
            HUD.labelText = [NSString stringWithFormat:@"登陆成功"];
            [HUD hide:YES afterDelay:1.];
            [[NSUserDefaults standardUserDefaults] setObject:[Pulic_class getTime] forKey:@"notificationTime"];
            //跳转到私照考试页
            if (flag ==111 || flag ==222 ||flag==108) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                Exam_sizhao_ViewController * sizhao = [[Exam_sizhao_ViewController alloc] init];
                sizhao.classflag = self.classflag;
                sizhao.flag = self.testflag;
                [self.navigationController pushViewController:sizhao animated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError* error) {
            NSDictionary *  dic = error.userInfo;
            NSData * data = [dic objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary * strDic =  [str objectFromJSONString];
             NSString * msg1= [strDic objectForKey:@"error"];
            if (msg1.length<1) {
                msg1 = @"登陆失败,请检查网络链接";
            }
            HUD.labelText = msg1;
            [HUD hide:YES afterDelay:1.5];
        }];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

//隐藏键盘
-(void)textFieldEditing
{
    [userNameText resignFirstResponder];
    [pwdText resignFirstResponder];
}

@end
