//
//  M_myselfViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-20.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_myselfViewController.h"
#import "Exam_loginViewController.h"
#import "M_paiHang_ViewController.h"
#import "M_about_ViewController.h"
#import "M_order_ViewController.h"
#import "ImageSizeManager.h"
#import "M_phoneCode_ViewController.h"
#import "M_changePwd_ViewController.h"
#import "M_notification_ViewController.h"
#import "AppDelegate.h"

@interface M_myselfViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UIView *backgroudView;
    UITableView *myTableView;
    NSArray * allLableNameArr;
    NSArray * infoArr;
    NSDictionary  *allDic;
    
    UILabel * sexLable;
    UILabel * adrressLable;
    UILabel * phoneLable;
    NSArray * messegeArr;
    UIImageView * headView;
    int will;
    UIView * sexView ;
    UITableView * sextable;
     NSArray *notifArr;
    UIButton * notifiBt;
}

@end
@implementation M_myselfViewController

- (void)viewWillAppear:(BOOL)animated

{
    infoArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"myInfo"];
    if(will == 10)
    {
        [self request];
        [self requstNotif];
    }
    will = 10;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    allLableNameArr = [[NSArray alloc] initWithObjects:@"用户名",@"邮箱",@"性别",@"地区",@"手机",@"最好成绩",@"我的订单",@"安全设置",@"我的通知",@"关于我们", nil];
    messegeArr = [[NSArray alloc] initWithObjects:@"name",@"email",@"gender",@"address",@"cell",@"top_score", @"avatar",@"rank",nil];
    infoArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"myInfo"];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    if ([str isEqualToString:@"麦飞机会员"]) {
        Exam_loginViewController * sizhao = [[Exam_loginViewController alloc] init];
        sizhao.flag = 222;
        [self.navigationController pushViewController:sizhao animated:NO];
    }
    [self request];
    [self myDrawNav];
    [self initTableView];
    [self requstNotif];
}

-(void)requstNotif
{
    NSString * time = [[NSUserDefaults standardUserDefaults] objectForKey:@"notificationTime"];
    if (time ==nil) {
        NSString * strtimr = [Pulic_class getTime];
        time = strtimr;
    }
//    NSLog(@"time =%@",time);
    NSString *str =[[NSString alloc] initWithFormat:@"http://api.mfeiji.com/v1/notices?time=%@",time];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        notifArr = responseObject;
        //        NSLog(@"noti =%@",notifArr);
        [self drawNotification];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}
-(void)drawNotification
{
    if (notifArr.count>0) {
        notifiBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        notifiBt.frame = CGRectMake(70, 368, 12, 12);
        [notifiBt setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)notifArr.count] forState:UIControlStateNormal];
        [notifiBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        notifiBt.backgroundColor = [UIColor redColor];
        notifiBt.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8.];
        [notifiBt.layer setCornerRadius:6];
        [myTableView addSubview:notifiBt];
    }
}

-(void)request
{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    if (![str isEqualToString:@"麦飞机会员"]) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
        NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
        NSDictionary * dic =[[NSDictionary alloc] initWithObjectsAndKeys:token,@"user_token", email,@"user_email",nil];
        NSString *str =[[NSString alloc] initWithFormat:@"http://api.mfeiji.com/v1/users/%@",userId];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic =responseObject;
//            NSLog(@"dic =%@",dic);
            NSMutableArray * testinfoArr = [[NSMutableArray alloc] init];
            for (int i =0; i<messegeArr.count; i++) {
                NSString * str = [NSString stringWithFormat:@"%@",[dic objectForKey:[messegeArr objectAtIndex:i]]];
                if ([str isEqualToString:@"<null>"]||[str isEqualToString:@"(null)"]) {
                    str = @"";
                }
                [testinfoArr addObject:str];
            }
            infoArr = testinfoArr;
            [[NSUserDefaults standardUserDefaults] setObject:[infoArr objectAtIndex:6] forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults]setObject:[infoArr objectAtIndex:0 ]forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:infoArr forKey:@"myInfo"];
            [myTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"erro =%@",error.userInfo);
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"请求失败，请检查网络连接";
            [HUD hide:YES afterDelay:1.];
        }];
    }

}
-(void)myDrawNav
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"我的个人中心";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(8,40, Main_Screen_Width-16, Main_Screen_Height-70-49)style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [backgroudView addSubview:myTableView];
    
}
-(void)removeSex
{
    [sexView removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:sextable]) {
        
        return NO;
    }
    return YES;
}

#pragma mark -tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableSampleIdentifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    
    if (cell ==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    else
    {
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
        
    }
    cell.backgroundColor = [UIColor colorWithRed:56/255. green:66/255. blue:95/255. alpha:1.];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 29.5, Main_Screen_Width-30-16, 0.5)];
    line.backgroundColor = [UIColor blackColor];
    line.alpha = 0.1;
    if (tableView.tag ==1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, 190, 0.5)];
        lineView.backgroundColor = [UIColor blueColor];
        lineView.alpha = 0.5;
        cell.backgroundColor = [UIColor whiteColor];
        switch (indexPath.row ) {
            case 0:
                cell.textLabel.text = @"选择性别";
                [cell.contentView addSubview:lineView];
                break;
            case 1:
                cell.textLabel.text =@"男";
                [cell.contentView addSubview:lineView];
                break;
            case 2:
                cell.textLabel.text =@"女";
                break;
                
            default:
                break;
        }
    }else
    {
        if (indexPath.section ==0) {//显示头像
            NSString * url = [[NSUserDefaults standardUserDefaults]objectForKey:@"avatar"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
             headView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-30, 10 , 60  , 60)];
            headView.userInteractionEnabled = YES;
            if (linshiImage == nil) {
                if (url.length > 0) {
                    [headView setImageWithURL:[NSURL URLWithString:url]];
                }else{
                    headView.image = [UIImage imageNamed:@"test.jpg"];
                }
            }else
            {
                headView.image = linshiImage;
            }
            if (headView.image ==nil) {
                 headView.image = [UIImage imageNamed:@"test.jpg"];
            }
            [cell.contentView addSubview:headView];
            UITapGestureRecognizer *pass1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoad)];
            [headView addGestureRecognizer:pass1];
            //圆角设置
            headView.layer.cornerRadius = 30;
            headView.layer.masksToBounds = YES;
            //边框宽度及颜色设置
            [headView.layer setBorderWidth:2];
            [headView.layer setBorderColor:[[UIColor colorWithRed:50./255 green:71./255 blue:121./255 alpha:1.] CGColor]];  //设置边框为蓝色
            //自动适应,保持图片宽高比
//            headView.contentMode = UIViewContentModeScaleAspectFit;
            UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-60, 70, 120, 20)];
            nameLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
            nameLable.textColor = [UIColor whiteColor];
            nameLable.textAlignment = NSTextAlignmentCenter;
            nameLable.font = [UIFont systemFontOfSize:13.];
            [cell.contentView addSubview:nameLable];
            
        }
        else{
            cell.textLabel.text = [allLableNameArr objectAtIndex:indexPath.row ];
            cell.textLabel.font = [UIFont systemFontOfSize:12.];
            cell.textLabel.textColor = [UIColor colorWithRed:108/255. green:141/255. blue:189/255. alpha:1.];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/2-20-16, 30)];
            lable.textColor = [UIColor blackColor];
            lable.alpha = 0.5;
            lable.font = [UIFont systemFontOfSize:11.];
            lable.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:lable];
            [cell.contentView addSubview:line];
            
            if(indexPath.section ==1)//个人信息
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                lable.text = [infoArr objectAtIndex:indexPath.row ];
                lable.textColor = [UIColor colorWithRed:144/255. green:147/255. blue:154/255. alpha:1.];
            }else if(indexPath.section ==2)
            {//性别 地址 电话
                cell.textLabel.text = [allLableNameArr objectAtIndex:indexPath.row +2];
                if (indexPath.row ==0) {
                 //性别
                    sexLable = lable;
                    sexLable.text = [infoArr objectAtIndex:2];
                }else if(indexPath.row ==1)
                {
                    adrressLable = lable;
                    adrressLable.text = [infoArr objectAtIndex:3];
                }else if(indexPath.row ==2)
                {
                    phoneLable = lable;
                    phoneLable.text = [infoArr objectAtIndex:4];
                }
            }else if(indexPath.section ==3){
                //top_score
               cell.textLabel.text = [allLableNameArr objectAtIndex:indexPath.row+5 ];
                if (!([[infoArr objectAtIndex:5] isEqual:@""]||[[infoArr objectAtIndex:5] isEqual:@"(null)"])) {
                    lable.text = [NSString stringWithFormat:@"%@分  查看排行",[infoArr objectAtIndex:5]];
              }else
              {
                  lable.text = @"查看排行";
              }
            
            }
            else if(indexPath.section ==4)
            {
                cell.textLabel.text = [allLableNameArr objectAtIndex:indexPath.row+6 ];
            }
            else if(indexPath.section ==5)
            {
                cell.textLabel.text =@"注销用户";
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==2) {
        switch (indexPath.row) {
            case 0:
            {
                sexView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width, Main_Screen_Height-70)];
                sexView.backgroundColor = [UIColor clearColor];
                [self.view addSubview:sexView];
                UITapGestureRecognizer *textFeild = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSex)];
                textFeild.delegate = self;
                [sexView addGestureRecognizer:textFeild];
                
                sextable = [[UITableView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 -110, Main_Screen_Height/2 -100, 220, 150)];
                sextable.delegate = self;
                sextable.dataSource =self;
                sextable.backgroundColor =[UIColor whiteColor];
                sextable.tag = 1;
                sextable.separatorStyle = UITableViewCellSeparatorStyleNone;
                [sexView addSubview:sextable];
                
            }
                break;
            case 1:
            {
                sexView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width, Main_Screen_Height-70-49)];
                sexView.backgroundColor = [UIColor clearColor];
                [self.view addSubview:sexView];
                
                UITapGestureRecognizer *textFeild = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSex)];
                [sexView addGestureRecognizer:textFeild];
                TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
                [locateView showInView:sexView];
            }
                break;
                
            case 2:
            {
                //绑定手机
                M_phoneCode_ViewController * phone = [[M_phoneCode_ViewController alloc] init];
                [self.navigationController pushViewController:phone animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section ==3) {
        MainViewController * tabbar = (MainViewController *)self.tabBarController;
        [tabbar hiddenTabBar];
        M_paiHang_ViewController * pai = [[M_paiHang_ViewController alloc] init];
        pai.tag =0;
        pai.rank = [infoArr objectAtIndex:7];
        [self.navigationController pushViewController:pai animated:YES];
    }else if(indexPath.section==4)
    {
        switch (indexPath.row) {
            case 0:
            {
                MainViewController * tabbar = (MainViewController *)self.tabBarController;
                [tabbar hiddenTabBar];
                M_order_ViewController * order = [[M_order_ViewController alloc] init];
                [self.navigationController pushViewController:order animated:YES];
            }
                break;
            case 1:
            {
                M_changePwd_ViewController * change = [[M_changePwd_ViewController alloc] init];
                [self.navigationController  pushViewController:change animated:YES];
            }
                break;
            case 2:
            {
                MainViewController * tabbar = (MainViewController *)self.tabBarController;
                [tabbar hiddenTabBar];
                [notifiBt removeFromSuperview];
                M_notification_ViewController * order = [[M_notification_ViewController alloc] init];
                [self.navigationController pushViewController:order animated:YES];

            }
                
                break;
            case 3:
            {
                MainViewController * tabbar = (MainViewController *)self.tabBarController;
                [tabbar hiddenTabBar];
                M_about_ViewController *about = [[M_about_ViewController alloc]init];
                [self.navigationController pushViewController:about animated:YES];
            }
                
                break;
            default:
                break;
        }
    }else if(indexPath.section ==5)
    {   //注销用户
        [[NSUserDefaults standardUserDefaults] setObject:@"麦飞机会员" forKey:@"userName"];
        //清楚头像缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[SDImageCache sharedImageCache] clearMemory];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"avatar"];
        
        //回到主页
        UIButton *bt ;
        bt.tag =0;
        [Pulic_class loginOut];
        MainViewController * tabbar = (MainViewController *)self.tabBarController;
        [tabbar loadViewControllers];
        [tabbar changeViewController:bt];
    }
    if (tableView.tag ==1) {
        if (indexPath.row ==1) {
            [sexView removeFromSuperview];
            sexLable.text = @"男";
            [Pulic_class commitMySelfmessage:@"男" canshuZhi:@"user[gender]"];
        }else if(indexPath.row ==2)
        {
            sexLable.text = @"女";
            [sexView removeFromSuperview];
            [Pulic_class commitMySelfmessage:@"女" canshuZhi:@"user[gender]"];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag ==1) {
        return 3;
    }
    if (section ==0 ||section ==3) {
        return 1;
    }
    else if(section ==1)
        return 2;
    else if(section ==2)
        return 3;
    else if(section ==5)
        return 1;
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag ==1) {
        return 1;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1) {
        return 50;
    }
    if (indexPath.section == 0) {
        return 100;
    }
    return 30.0;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{  if(section ==0 ||section ==1)
    return 0;
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//提交修改后的个人信息
-(void)commitMessege:(int)number
{
    if (number ==1) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在提交...";
        [Pulic_class commitMySelfAvatar:headView.image];
        [self request];
    }
}

- (void)upLoad
{
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"摄像头拍摄",@"取消", nil];
    sheet.tag =101;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag ==101) {
        
    switch (buttonIndex) {
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                
                UIImagePickerController *imgPicker = [UIImagePickerController new];
                imgPicker.delegate = self;
                imgPicker.allowsEditing= YES;
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imgPicker animated:YES completion:nil];
                return;
            }
            else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"该设备没有摄像头"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"好", nil];
                [alertView show];
                
            }
            
        }
            break;
        case 0:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 2:
            
            break;
        default:
            break;
    }
    }
    else{
        TSLocateView *locateView = (TSLocateView *)actionSheet;
        TSLocation *location = locateView.locate;
        if(buttonIndex == 0) {
            
        }else {
            adrressLable.text = [NSString stringWithFormat:@"%@  %@",location.state,location.city];
            [Pulic_class commitMySelfmessage:adrressLable.text canshuZhi:@"user[address]"];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    linshiImage = [ImageSizeManager getSmallImageWithOldImage:info[UIImagePickerControllerEditedImage]];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        headView.image = linshiImage;
        [self commitMessege:1];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
