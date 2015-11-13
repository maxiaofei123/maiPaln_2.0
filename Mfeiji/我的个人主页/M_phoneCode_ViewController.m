//
//  M_phoneCode_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-12.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_phoneCode_ViewController.h"

@interface M_phoneCode_ViewController ()<UITextFieldDelegate>
{
    UIView *backgroudView;
    UITextField * phoneText;
    UITextField * codeText;
    UIButton *getVer;
    NSString *batch_code;
}
@end

@implementation M_phoneCode_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    UITapGestureRecognizer *textFeild = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldEditing)];
    [backgroudView addGestureRecognizer:textFeild];
    [self regDrawNav];
    [self drawView];
}

-(void)regDrawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 1;
    [backgroudView addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"绑定手机号";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
    
}
-(void)choose
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)drawView
{
    UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-110, Main_Screen_Height/2-180, 50, 25)];
    l.text = @"手机号:";
    l.font = [UIFont systemFontOfSize:13.];
    l.textColor = [UIColor colorWithRed:68./255 green:103./255 blue:169./255 alpha:1.];
    [backgroudView addSubview:l];
    
    UIImageView *vi = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-60 , Main_Screen_Height/2-180, 180, 28)];
    vi.userInteractionEnabled = YES;
    vi.image = [UIImage imageNamed:@"chnagePwdText.png"];
    [backgroudView addSubview:vi];
    
    phoneText = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 160, 28)];
    phoneText.placeholder = @"请输入11位手机号码";
    phoneText.delegate = self;
    phoneText.returnKeyType = UIReturnKeyNext;
    phoneText.font = [UIFont systemFontOfSize:14];
    phoneText.textColor = [UIColor whiteColor];
     phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [phoneText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [phoneText setValue:[UIFont boldSystemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
    [vi addSubview:phoneText];
    
    UILabel *code =[[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-110, Main_Screen_Height/2-130, 50, 25)];
    code.text = @"验证码:";
    code.font = [UIFont systemFontOfSize:13.];
    code.textColor = [UIColor colorWithRed:68./255 green:103./255 blue:169./255 alpha:1.];
    [backgroudView addSubview:code];
    
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-60 , Main_Screen_Height/2-130, 100, 28)];
    codeView.userInteractionEnabled = YES;
    codeView.image = [UIImage imageNamed:@"chnagePwdText.png"];
    [backgroudView addSubview:codeView];
    
    codeText = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 90, 28)];
    codeText.placeholder = @"请输入6位验证码";
    codeText.delegate = self;
    codeText.font = [UIFont systemFontOfSize:14];
    codeText.textColor = [UIColor whiteColor];
    codeText.keyboardType = UIKeyboardTypeNumberPad;
    [codeText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [codeText setValue:[UIFont boldSystemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
    [codeView addSubview:codeText];
    
    getVer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getVer setFrame:CGRectMake(Main_Screen_Width/2+50 , Main_Screen_Height/2-129, 68, 25)];
    [getVer setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVer setTitleColor: [UIColor whiteColor]forState:UIControlStateNormal];
    [getVer setBackgroundColor:[UIColor colorWithRed:48/255. green:178/255. blue:150/255. alpha:1.]];
    [getVer.layer setCornerRadius:5.0];
    getVer.titleLabel.font = [UIFont systemFontOfSize:11.];
    [getVer addTarget:self action:@selector(reSend) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:getVer];
    //绑定
    UIButton * commitBt = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-45, Main_Screen_Height/2-60, 90, 40)];
    [commitBt setImage:[UIImage imageNamed:@"phoneCommit.png"] forState:UIControlStateNormal];
    [commitBt addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:commitBt];
}

-(void)commit
{
    NSString *phone = [phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone.length == 0 || phone.length != 11) {
    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码不符合规定，请填写手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alt show];
    return;
    }
    if(codeText.text.length == 6)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager PUT:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/%@/update_cell?user[cell]=%@&user[batch_code]=%@&user[code]=%@",userId,phoneText.text,batch_code,codeText.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD hide:YES];
            NSDictionary *dic =responseObject;
//            NSLog(@"dic =%@",dic);
            if ([[dic objectForKey:@"error"] isEqualToString:@"invalid code"]) {
                HUD.labelText = [NSString stringWithFormat:@"提交失败"];
                [HUD hide:YES afterDelay:1.];
            }else{
                 HUD.labelText = [NSString stringWithFormat:@"验证成功"];
                [HUD hide:YES afterDelay:1.];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HUD.labelText = [NSString stringWithFormat:@"请求失败,请检查网络连接"];
            [HUD hide:YES afterDelay:1.];
            NSLog(@"Error: %@", error);
        }];
    }else
    {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入6位验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }
}

- (void)reSend
{
    [phoneText resignFirstResponder];
    [codeText resignFirstResponder];
    NSString *phone = [phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone.length == 0 || phone.length != 11) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码不符合规定，请填写手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        return;
    }else{
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        getVer.enabled = NO;
        [self timeFireMethod];
//        NSLog(@"request = %@",[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/%@/send_code?cell=%@",userId,phone]);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/%@/send_code?cell=%@",userId,phone] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD hide:YES];
            NSDictionary *dic = responseObject;
//            NSLog(@"dic =%@",dic);
            if ([[dic objectForKey:@"error"] isEqualToString:@"failed"]) {
                HUD.labelText = [NSString stringWithFormat:@"验证失败，请检查号码是否可用"];
                [HUD hide:YES afterDelay:1.];
            }else{
                batch_code =  [[dic objectForKey:@"user"] objectForKey:@"batch_code"];
                HUD.labelText = [NSString stringWithFormat:@"验证码已经发送到您填写的手机号码，请确认查收"];
                [HUD hide:YES afterDelay:1.];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HUD.labelText = [NSString stringWithFormat:@"请求失败,请检查网络连接"];
            [HUD hide:YES afterDelay:1.];
            NSLog(@"Error: %@", error);
        }];
    }
}

-(void)timeFireMethod{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [getVer setTitle:@"重新获取" forState:UIControlStateNormal];
                getVer.enabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [getVer setTitle:strTime forState:UIControlStateNormal];
                getVer.titleLabel.textAlignment = NSTextAlignmentCenter;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void)textFieldEditing
{
    [phoneText resignFirstResponder];
    [codeText resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
