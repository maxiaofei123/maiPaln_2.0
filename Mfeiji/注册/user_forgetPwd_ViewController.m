//
//  user_forgetPwd_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-11-28.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "user_forgetPwd_ViewController.h"
#import "JSONKit.h"
@interface user_forgetPwd_ViewController ()<UITextFieldDelegate>
{
    UIView *backgroudView;
    UITextField *emailText;
}
@end

@implementation user_forgetPwd_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    
    UITapGestureRecognizer *textFeild = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldEditing)];
    [backgroudView addGestureRecognizer:textFeild];

    
    [self drawNav];
    [self drawView];
    
}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(Choose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 200;
    [backgroudView addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -75, 15, 150, 20)];
    title.text = @"忘记密码";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
    
}

-(void)drawView
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-90,Main_Screen_Height/2-150, 180, 36)];
    image.userInteractionEnabled  = YES;
    image.image = [UIImage imageNamed:@"chnagePwdText.png"];
    [backgroudView addSubview:image];
    
    emailText = [[UITextField alloc] initWithFrame:CGRectMake(10, 5 , 160, 30)];
    emailText.placeholder = @"请输入注册填写的邮箱";
    emailText.delegate = self;
    emailText.font = [UIFont systemFontOfSize:14];
    emailText.textColor = [UIColor whiteColor];
    [emailText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [emailText setValue:[UIFont boldSystemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
    [image addSubview:emailText];
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-50, Main_Screen_Height/2-90, 100, 28)];
    [bt addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    [bt setImage:[UIImage imageNamed:@"commit.png"] forState:UIControlStateNormal];
    [backgroudView addSubview:bt];
    
}

-(void)request
{
    [emailText resignFirstResponder];
    if(![self CheckInput:emailText.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您的邮箱格式不正确，请检查" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在提交...";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/reset_password?user_email=%@",emailText.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            HUD.labelText = [NSString stringWithFormat:@"提交成功,密码已发至邮箱"];
            [HUD hide:YES afterDelay:1.];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSDictionary *  dic = error.userInfo;
            NSData * data = [dic objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary * strDic =  [str objectFromJSONString];
            NSString * msg1= [strDic objectForKey:@"error"];
            if (msg1.length<1) {
                msg1 = @"提交失败,请检查网络链接";
            }
            HUD.labelText = msg1;
            [HUD hide:YES afterDelay:1.5];
        }];
    }
}

-(BOOL)CheckInput:(NSString *)_text{
    NSString *Regex=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [emailTest evaluateWithObject:_text];
    
}

-(void)Choose:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}

-(void)textFieldEditing
{
    [emailText resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
