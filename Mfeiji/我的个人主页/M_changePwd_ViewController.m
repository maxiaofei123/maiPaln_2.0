//
//  M_changePwd_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-12.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_changePwd_ViewController.h"

@interface M_changePwd_ViewController ()<UITextFieldDelegate>
{
    UIView *backgroudView;
    UITextField *pwd;
    UITextField *changePwd;
}
@end

@implementation M_changePwd_ViewController

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
    title.text = @"修改密码";
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
    UILabel *l =[[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-100, Main_Screen_Height/2-180, 50, 25)];
    l.text = @"原密码:";
    l.font = [UIFont systemFontOfSize:13.];
    l.textColor = [UIColor colorWithRed:68./255 green:103./255 blue:169./255 alpha:1.];
    [backgroudView addSubview:l];
    
    UIImageView *vi = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-50 , Main_Screen_Height/2-180, 140, 28)];
    vi.userInteractionEnabled = YES;
    vi.image = [UIImage imageNamed:@"chnagePwdText.png"];
    [backgroudView addSubview:vi];
    
    pwd = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 130, 28)];
    pwd.placeholder = @"请输入原密码";
    pwd.delegate = self;
    pwd.returnKeyType = UIReturnKeyNext;
    pwd.font = [UIFont systemFontOfSize:14];
    pwd.textColor = [UIColor whiteColor];
    [pwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [pwd setValue:[UIFont boldSystemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
    [vi addSubview:pwd];
    
    UILabel *code =[[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-100, Main_Screen_Height/2-130, 50, 25)];
    code.text = @"新密码:";
    code.font = [UIFont systemFontOfSize:13.];
    code.textColor = [UIColor colorWithRed:68./255 green:103./255 blue:169./255 alpha:1.];
    [backgroudView addSubview:code];
    
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-50 , Main_Screen_Height/2-130, 140, 28)];
    codeView.userInteractionEnabled = YES;
    codeView.image = [UIImage imageNamed:@"chnagePwdText.png"];
    [backgroudView addSubview:codeView];
    
    changePwd = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 130, 28)];
    changePwd.placeholder = @"请输入6-20位密码";
    changePwd.delegate = self;
    changePwd.font = [UIFont systemFontOfSize:14];
    changePwd.textColor = [UIColor whiteColor];
    [changePwd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [changePwd setValue:[UIFont boldSystemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
    [codeView addSubview:changePwd];

    UIButton * commitBt =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    commitBt.frame = CGRectMake(Main_Screen_Width/2-45, Main_Screen_Height/2-60, 90, 30);
    [commitBt setTitle:@"确认修改" forState:UIControlStateNormal];
    [commitBt setTitleColor: [UIColor whiteColor]forState:UIControlStateNormal];
    commitBt.titleLabel.font = [UIFont systemFontOfSize:13.];
    [commitBt setBackgroundColor:[UIColor colorWithRed:48/255. green:178/255. blue:150/255. alpha:1.]];
    [commitBt.layer setCornerRadius:5.0];
    [commitBt addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:commitBt];
}

-(void)commit
{
    [self textFieldEditing];
    NSString *strPwd = [pwd.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cPwd = [changePwd.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strPwd.length < 6 || cPwd.length< 6 || strPwd.length > 20 || cPwd.length>20) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入的密码不符合规范" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        return;
    }else{
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在提交...";
        NSString *str=[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/%@/update_password?user[current_password]=%@&user[password]=%@&user[password_confirmation]=%@",userId,strPwd,cPwd,cPwd];
        NSLog(@" str = %@ ",str);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager PUT:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/%@/update_password?user[current_password]=%@&user[password]=%@&user[password_confirmation]=%@",userId,strPwd,cPwd,cPwd] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            
             [HUD hide:YES ];
            UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alView.tag = 100;
            [alView show];

         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"reg error =%@",error);
             HUD.labelText = [NSString stringWithFormat:@"修改失败，请检查网络是否链接。"];
             [HUD hide:YES afterDelay:1.];
         }];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //注销用户
    [[NSUserDefaults standardUserDefaults] setObject:@"麦飞机会员" forKey:@"userName"];
    //            //清楚头像缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"avatar"];
    //            UIButton *bt ;
    //            bt.tag =2;
    [Pulic_class loginOut];
    MainViewController * tabbar = (MainViewController *)self.tabBarController;
    [tabbar loadViewControllers];

}
-(void)textFieldEditing
{
    [pwd resignFirstResponder];
    [changePwd resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
