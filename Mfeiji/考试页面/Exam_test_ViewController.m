//
//  Exam_test_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-21.
//  Copyright (c) 2014年 susu. All rights reserved.
//
#import "Exam_test_ViewController.h"
#import "MainViewController.h"
#import "Exam_result_ViewController.h"
#import "CycleScrollView.h"
#import "Test_noAnswer_ViewController.h"


@interface Exam_test_ViewController ()<UIScrollViewDelegate,WTwoViewControllerDelegate>
{ 
    UIView * backgroudView;
    UIView *huiBg;
    UILabel *timeLable;
    UIInterfaceOrientation _orientation;
   
    int currentPage ;
    NSArray *labarArr;
    NSMutableArray *btImageArr;
    NSMutableArray *btCheckArr;
    NSMutableArray *tableArr;
    NSArray * abcArr;
    
    NSTimer * timer;
    int timeDate;
    float  score;
    int imin ;
    int isec ;
    int page ;
    
    NSArray *allQuestion;
    NSMutableArray *anwserR;
    NSMutableDictionary *zhuangTaiDic;
    NSMutableArray *yidaArr;
    NSMutableArray *weidaArr;
    NSMutableArray *yidaId;
    NSMutableArray * yidaArrId;
    
    UIImageView *BgView;
    NSArray * testArr;
    
}
@property (nonatomic , retain) CycleScrollView *mainScorllView;

@end

@implementation Exam_test_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, Main_Screen_Width,Main_Screen_Height-20);
    backgroudView.backgroundColor = [UIColor colorWithRed:35./255 green:41./255 blue:70./255 alpha:1.];
    [self.view addSubview:backgroudView];
    huiBg = [[UIView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height-70-58)];
    huiBg.backgroundColor = [UIColor colorWithRed:239./255 green:239./255 blue:239./255 alpha:1.];
    [backgroudView addSubview:huiBg];

    zhuangTaiDic = [[NSMutableDictionary alloc] init];
    yidaArr = [[NSMutableArray alloc] init];
    weidaArr  = [[NSMutableArray alloc] init];
    labarArr = [[NSArray alloc]initWithObjects:@"上一题",@"未做",@"考试倒计时",@"交卷",@"下一题", nil ];
    btImageArr = [[NSMutableArray alloc] init];
    anwserR = [[NSMutableArray alloc] init];
    abcArr = [[NSArray alloc] initWithObjects:@"A、",@"B、",@"C、", nil];
    yidaArrId = [[NSMutableArray alloc] init];
    currentPage =0;
    
    [self requestQuestions];
    [self drawNav];
    [self drawTabbar];

}
-(void)requestQuestions
{
    NSArray * classArr = [[NSArray alloc] initWithObjects:@"rotor_craft_personal",@"rotor_craft_commercial",@"fixed_wing_jet_personal",@"fixed_wing_jet_commercial", nil];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
    NSString * classStr = [classArr objectAtIndex:_classFlag-1];
    NSDictionary * dic =[[NSDictionary alloc] initWithObjectsAndKeys:email,@"user_email",token,@"user_token",@"zh-CN",@"question[lang]",self.pending,@"question[group]",classStr,@"question[plane_type]",nil];
//    NSLog(@"dic =%@",dic);
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在请求...";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.mfeiji.com/v1/questions/question_group" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         allQuestion=responseObject;
         if (allQuestion.count < 1) {
             [HUD hide:YES ];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"此类试题为空,请选择其他类型试题"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil,nil];
             alertView.tag = 11111;
             [alertView show];
             
             return ;
         }
         yidaId = [[NSMutableArray alloc] init];
         //   比较每道题的答案是否为1，如果为1，则保存此序号到数组;
         for (int i=0; i<allQuestion.count; i++) {
             NSArray * arr = [[allQuestion objectAtIndex:i] objectForKey:@"options"];
             for (int j=0; j<arr.count; j++) {
                 NSString *str = [[arr objectAtIndex:j] objectForKey:@"correct"];
                 int num = [str intValue];
                 if (num ==1) {
                     [anwserR addObject:[NSString stringWithFormat:@"%d",j]];
                 }
             }
//             NSLog(@"anser =%@",anwserR);
             [yidaId addObject:[[allQuestion objectAtIndex:i] objectForKey:@"id"]];
         }
//         NSLog(@"quseton =%@",allQuestion);
         HUD.labelText = @"开始答题。。。";
         [HUD hide:YES afterDelay:1.];
         [self drawView];
         timeDate =120*60;
         timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"erro =%@",error);
         HUD.labelText = @"请求失败,请检查网络链接";
         [HUD hide:YES afterDelay:1.];
         if (self.flag !=1) {
             MainViewController * tabbar = (MainViewController *)self.tabBarController;
             [tabbar showTabBar];
         }
         [self.navigationController popViewControllerAnimated:NO];


     }];
    
}
-(void)drawTabbar
{
    //--------tabbar按钮--------
    //实现倒计时
    timeDate =120*60;
    static UIView *viewTab;
    viewTab = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 64)];
    viewTab.backgroundColor = [UIColor colorWithRed:35./255 green:41./255 blue:70./255 alpha:1.];
    [self.view addSubview:viewTab];
    
    UIButton *Lbutton = [[UIButton alloc] initWithFrame:CGRectMake(15, 2, 35, 30)];
    [Lbutton setImage:[UIImage imageNamed:@"test_left.png"] forState:UIControlStateNormal];
    Lbutton.tag = 243;
    [Lbutton addTarget:self action:@selector(testChoose:) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:Lbutton];
    
    UIButton *Tbt = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -90, 2, 35, 30)];
    [Tbt setImage:[UIImage imageNamed:@"test_weizuo.png"] forState:UIControlStateNormal];
    Tbt.tag = 244;
    [Tbt addTarget:self action:@selector(testChoose:) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:Tbt];
    //------commit
    UIButton *commitBt = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+61, 2, 35, 30)];
    [commitBt setImage:[UIImage imageNamed:@"test_commit.png"] forState:UIControlStateNormal];
    commitBt.tag = 245;
    [commitBt addTarget:self action:@selector(testChoose:) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:commitBt];
    
    UIButton *Rbutton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-53, 2, 35, 30)];
    [Rbutton setImage:[UIImage imageNamed:@"test_next.png"] forState:UIControlStateNormal];
    Rbutton.tag = 246;
    [Rbutton addTarget:self action:@selector(testChoose:) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:Rbutton];
    
    //----tabarlable
    UILabel *lableName1 = [[UILabel alloc] initWithFrame:CGRectMake(13  ,35, 50, 15)];
    lableName1.text = [labarArr objectAtIndex:0];
    lableName1.textColor = [UIColor whiteColor];
    lableName1.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableName1];
    
    UILabel *lableName2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -88  ,35, 40, 15)];
    lableName2.text = [labarArr objectAtIndex:1];
    lableName2.textColor = [UIColor whiteColor];
    lableName2.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableName2];
    
    UILabel *lableName3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50  ,35, 100, 15)];
    lableName3.text = [labarArr objectAtIndex:2];
    lableName3.textColor = [UIColor whiteColor];
    lableName3.font = [UIFont systemFontOfSize:14];
    lableName3.textAlignment = NSTextAlignmentCenter;
    [viewTab addSubview:lableName3];
    
    UILabel *lableName4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+61  ,35, 40, 15)];
    lableName4.text = [labarArr objectAtIndex:3];
    lableName4.textColor = [UIColor whiteColor];
    lableName4.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableName4];
    
    UILabel *lableName5 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60  ,35, 50, 15)];
    lableName5.text = [labarArr objectAtIndex:4];
    lableName5.textColor = [UIColor whiteColor];
    lableName5.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableName5];
    
    //显示时间
    timeLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -40, 5, 80, 20)];
    timeLable.text = @"00:00";
    timeLable.textColor = [UIColor whiteColor];
    timeLable.textAlignment = NSTextAlignmentCenter;
    [viewTab addSubview:timeLable];
    
}

-(void)setQuestionTest:(int)number
{
    //跳转到number页
    [self.mainScorllView weiZuo:number];
}

-(void)drawView
{
    NSMutableArray *viewsArray = [@[] mutableCopy];
    tableArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<allQuestion.count; i++) {
        UIScrollView * testScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height-70-58)];
        testScrollView.backgroundColor = [UIColor clearColor];
        testScrollView.delegate = self ;
        [viewsArray addObject:testScrollView];

        // test
        NSDictionary * dic = [allQuestion objectAtIndex:i];
        //适应高度
        UIFont *font = [UIFont systemFontOfSize:16.0];
        CGSize size = CGSizeMake(Main_Screen_Width-40, 2000);
        CGSize labelsize =[[NSString stringWithFormat:@"%d、%@",page,[dic objectForKey:@"subject"]] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];;
        float lableH;
        lableH = labelsize.height>20?labelsize.height:20;
        UILabel * titleLable =[[UILabel alloc] initWithFrame:CGRectMake(20, 20, Main_Screen_Width-40, lableH)];
        titleLable.font = [UIFont systemFontOfSize:16.];
        titleLable.text = [NSString stringWithFormat:@"%d、%@",i+1,[dic objectForKey:@"subject"]];
        titleLable.lineBreakMode = NSLineBreakByWordWrapping;
        titleLable.numberOfLines = 0;
        [testScrollView addSubview:titleLable];
        // image
        UIImage *image = nil;
        UIImageView* tempView = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-image.size.width/2, titleLable.frame.origin.y+lableH+5, image.size.width, image.size.height)];
        NSArray * urlArr = [dic objectForKey:@"attachments"];
        if (urlArr.count>0) {
            NSString * urlStr = [[[[urlArr objectAtIndex:0] objectForKey:@"image"] objectForKey:@"thumb"] objectForKey:@"url"];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            image = [UIImage imageWithData:data];
            tempView.frame =CGRectMake(Main_Screen_Width/2-image.size.width/2, titleLable.frame.origin.y+lableH, image.size.width, image.size.height);
            if (image.size.width > Main_Screen_Width) {
                tempView.frame = CGRectMake(0, titleLable.frame.origin.y+lableH+5, Main_Screen_Width, Main_Screen_Width/image.size.width*image.size.height);
            }
            if(image.size.height > 300)
            {
               tempView.frame = CGRectMake(Main_Screen_Width/2-(300/image.size.width*image.size.height)/2, titleLable.frame.origin.y+lableH+5,300/image.size.width*image.size.height, 300);
            }
            [tempView setImage:image];
            tempView.contentMode = UIViewContentModeScaleAspectFit;
            [testScrollView addSubview:tempView];
        }
      //  选项
        float h = tempView.frame.origin.y+tempView.frame.size.height;
        NSArray *optionsArr = [dic objectForKey:@"options"];
        NSMutableArray * btArr = [[NSMutableArray alloc] init];
        for (int j=0; j<3; j++) {
            //获取lable大小
            UIFont *font = [UIFont systemFontOfSize:14.0];
            CGSize size = CGSizeMake(Main_Screen_Width-78, 2000);
            CGSize labelsize =[[NSString stringWithFormat:@"%@ %@",[abcArr objectAtIndex:j],[[optionsArr objectAtIndex:j] objectForKey:@"content"]] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
            float contentH;
            contentH = labelsize.height>30?labelsize.height+5:30;
//            NSLog(@"lableh=%f",contentH);
        //选项

            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, h+20+10*j, Main_Screen_Width, contentH)];
            view.backgroundColor = [UIColor clearColor];
            view.tag = i;
            [testScrollView addSubview:view];
            if (j==0) {
                UITapGestureRecognizer *choose = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentChooseA)];
                [view addGestureRecognizer:choose];
            }else if(j==1){
                UITapGestureRecognizer *choose = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentChooseB)];
                [view addGestureRecognizer:choose];
            }else if(j==2){
                UITapGestureRecognizer *choose = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentChooseC)];
                [view addGestureRecognizer:choose];
            }

         //按钮
            UIImageView *contentImage =[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 11, 11)];
            contentImage.userInteractionEnabled = YES;
            contentImage.image=[UIImage imageNamed:@"test_xuan1.png"];
            [view addSubview:contentImage];
            [btArr addObject:contentImage];
            
          //内容
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, Main_Screen_Width-78, contentH)];
            lable.font = [UIFont systemFontOfSize:16.];
            lable.text = [NSString stringWithFormat:@"%@ %@",[abcArr objectAtIndex:j],[[optionsArr objectAtIndex:j] objectForKey:@"content"]];
            lable.lineBreakMode = NSLineBreakByWordWrapping;
            lable.numberOfLines = 0;
            [view addSubview:lable];
            
            float linshiH = h;
            h = linshiH+contentH;
            
        }
       
        if ((h+100)>Main_Screen_Height-58) {
            testScrollView.contentSize = CGSizeMake(Main_Screen_Width,h+50);
        }else
        {
            testScrollView.contentSize =CGSizeMake(Main_Screen_Width,Main_Screen_Height-70-58);
        }
        [btImageArr addObject:btArr];
    }
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width, Main_Screen_Height-70-58) animationDuration:0];
    
    self.mainScorllView.backgroundColor = [[UIColor colorWithRed:239/255. green:239/255. blue:239/255. alpha:1.] colorWithAlphaComponent:1.];

    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.onePage =  ^(NSInteger pageIndex)
    {
//        NSLog(@" pageIndec =%d",pageIndex);
        page = pageIndex ;
    };
    [self.view addSubview:self.mainScorllView];
    [self.mainScorllView weiZuo:0];

}

-(void)showPic:(UIButton*)sender
{
    BgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, Main_Screen_Width, Main_Screen_Height -70-60)];
//    BgView.backgroundColor = [UIColor ];
    [self.view addSubview:BgView];
    NSDictionary * dic = [allQuestion objectAtIndex:sender.tag];
    NSArray * urlArr = [dic objectForKey:@"attachments"];
    NSString * urlStr = [[[urlArr objectAtIndex:0] objectForKey:@"image"] objectForKey:@"url"];
    UIImage *image;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    image = [UIImage imageWithData:data];
    UIImageView * showPicImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - image.size.width/2, Main_Screen_Height/2 - image.size.height/2,image.size.width,image.size.height)];
    if (image.size.height>(Main_Screen_Height-70-60)) {
        showPicImage.frame = CGRectMake(Main_Screen_Width/2 - image.size.width/2, 70, Main_Screen_Width/image.size.height*image.size.width, Main_Screen_Height-70-60);
    }
    else if(image.size.width>Main_Screen_Width)
    {
        showPicImage.frame = CGRectMake(0,  Main_Screen_Height/2 - image.size.height/2, Main_Screen_Width, Main_Screen_Height/image.size.height*image.size.width);
    }
    
    BgView.image = [UIImage imageNamed:image];
    BgView.contentMode = UIViewContentModeScaleAspectFit;
    
}

-(void)contentChooseA
{
    for (int i=0; i<3; i++) {
        UIImageView * image = [[btImageArr objectAtIndex:page] objectAtIndex:i];
        if (0 == i) {
            image.image =[UIImage imageNamed:@"test_xuan2.png"];
            [zhuangTaiDic setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",page]];
            [self save];
        }
        else
        {
             image.image =[UIImage imageNamed:@"test_xuan1.png"];
        }
    }
}

-(void)contentChooseB
{
    for (int i=0; i<3; i++) {
        UIImageView * image = [[btImageArr objectAtIndex:page] objectAtIndex:i];
        if (1== i) {
            image.image =[UIImage imageNamed:@"test_xuan2.png"];
            [zhuangTaiDic setObject:[NSString stringWithFormat:@"%d",1] forKey:[NSString stringWithFormat:@"%d",page]];
            [self save];
        }
        else
        {
            image.image =[UIImage imageNamed:@"test_xuan1.png"];
        }
    }
}

-(void)contentChooseC
{
    for (int i=0; i<3; i++) {
        UIImageView * image = [[btImageArr objectAtIndex:page] objectAtIndex:i];
        if (2 == i) {
            image.image =[UIImage imageNamed:@"test_xuan2.png"];
            [zhuangTaiDic setObject:[NSString stringWithFormat:@"%d",2] forKey:[NSString stringWithFormat:@"%d",page]];
            [self save];
        }
        else
        {
            image.image =[UIImage imageNamed:@"test_xuan1.png"];
        }
    }
}

-(void)save
{
    if (yidaArr.count == 0) {
        [yidaArr addObject:[NSString stringWithFormat:@"%d",page]];
    }else{
        int con =0;
        for (int i=0; i<yidaArr.count; i++) {
            NSString * yida = [yidaArr objectAtIndex:i];
            NSString *test = [NSString stringWithFormat:@"%d",page];
            if ([yida isEqualToString:test]) {
                con =1;
                break;
            }
        }
        if (con ==0 ) {
            [yidaArr addObject:[NSString stringWithFormat:@"%d",page]];
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:[yidaId objectAtIndex:page],@"question_id",@"true",@"correct", nil];
            [yidaArrId addObject:dic];
//            NSLog(@"b不相等 %d",page);
        }
    }
}

-(void)testChoose:(UIButton*)sender
{

    switch (sender.tag) {
        case 241:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"你还没有做题目哦~"
                                                               delegate:self
                                                      cancelButtonTitle:@"退出"
                                                      otherButtonTitles:@"继续做题",nil];
            alertView.tag = 9501;
            [alertView show];

        }
            break;
        case 242:
            
            break;
        case 243:
            //上一题
             [self.mainScorllView changePage:page-1 nextOrago:0];
            break;
        case 244:
            //未做
        {
//            NSLog(@"已答题 =%@ ",yidaArr);
            weidaArr = [[NSMutableArray alloc] init];
            
                for (int  i= 0; i<80; i++) {
                if (yidaArr.count>0) {
                    int p =0;
                    for (int j =0; j<yidaArr.count; j++) {
                        NSString *str =[[NSString alloc]initWithFormat:@"%@",[yidaArr objectAtIndex:j]];
                        if ([str isEqualToString:[NSString stringWithFormat:@"%d",i]]) {
                            p=1;
                            break;
                        }
                    }
                    if (p == 0) {
                    [weidaArr addObject:[NSString stringWithFormat:@"%d",i+1]];
                }
                }else
                {
                    [weidaArr addObject:[NSString stringWithFormat:@"%d",i+1]];
                }
 
            }
            Test_noAnswer_ViewController * no = [[Test_noAnswer_ViewController alloc] init];
            no.weidaArry = weidaArr;
            no.delegate = self;
            [self.navigationController pushViewController:no animated:YES];
        }
            break;
        case 245:
        {
            //提交考试
            if (zhuangTaiDic.count <allQuestion.count) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"你还没有做题目哦~"
                                                                   delegate:self
                                                          cancelButtonTitle:@"提交"
                                                          otherButtonTitles:@"继续做题",nil];
                alertView.tag = 9503;
                [alertView show];
            }else{
                [self toResultView];
                
            }
        }
            break;
        case 246:
        {
            // next text
             [self.mainScorllView changePage:page+1 nextOrago:1];
            
        }
            break;
            
        default:
            break;
    }
}


-(void)toResultView
{
    NSMutableArray *daduiArr = [[NSMutableArray alloc] init];
    NSMutableArray *wrongArr = [[NSMutableArray alloc] init];
    for (int i=0; i<anwserR.count; i++) {
        NSString *str = [[NSString alloc] init];
        NSString *str1 =[[NSString alloc] init];
        str = [anwserR objectAtIndex:i];
        str1 = [zhuangTaiDic objectForKey:[ NSString stringWithFormat:@"%d",i]];
        if (str1.length != 0) {
            if ([str isEqualToString:str1]) {
                float x ;
                x=score;
                score = x+1.25;
                [daduiArr addObject:[NSString stringWithFormat:@"%d",i]];
            }else
                [wrongArr addObject:[NSString stringWithFormat:@"%d",i]];
            
        }else
        {
            [zhuangTaiDic setObject:@"4" forKey:[NSString stringWithFormat:@"%d",i]];

        }
        
    }
    NSDictionary * checkDic = [[NSDictionary alloc] initWithObjectsAndKeys:wrongArr,@"wrongArr", daduiArr,@"weidaArr" ,allQuestion,@"textName",anwserR,@"answer",yidaArrId,@"testYiDaId",nil, nil];
    
    [timer invalidate];
    timer = nil;
    Exam_result_ViewController *result = [[Exam_result_ViewController alloc] init];
    if (isec != 0) {
        result.useTime = 120-imin-1;
        result.useSec = 60-isec ;
    }else
    {
        result.useTime = 120-imin;
        result.useSec = 0 ;
    }
    result.resultScore = score;
    result.checkDic = checkDic;
    result.zhuangtai = zhuangTaiDic;
    result.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:result animated:YES];

}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(testChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 241;
    [backgroudView addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, self.view.frame.size.width-80, 20)];
    title.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"title"];
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
}

#pragma mark -更新时间
-(void)updateTime
{
    if (timeDate == 0) {
        [timer invalidate];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"时间已到"
                                                           delegate:self
                                                  cancelButtonTitle:@"提交"
                                                  otherButtonTitles:@"不提交退出答题",nil];
        alertView.tag = 9502;
        [alertView show];
        
    }else{
        
        timeDate = timeDate - 1 > 0 ? timeDate - 1 : 0;
        timeLable.text = [self getTime];
    }
}

-(NSString*)getTime {
    
    imin = (int)(timeDate / 60);
    isec = (int)(timeDate % 60);
    
    NSString *min = [NSString stringWithFormat:@"%@%d", imin < 10 ? @"0" : @"", imin];
    NSString *sec = [NSString stringWithFormat:@"%@%d", isec < 10 ? @"0" : @"", isec];
    NSString *addTime = [NSString stringWithFormat:@"%@:%@", min, sec];
    return addTime;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==9501) {
        if (buttonIndex ==0) {
            if (self.flag !=1) {
                MainViewController * tabbar = (MainViewController *)self.tabBarController;
                [tabbar showTabBar];
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else if (alertView.tag ==9502) {//倒计时为0
        if (buttonIndex ==0) {
            //提交试卷
            [self toResultView];
        }else//退出答题
        {   [timer invalidate];
            if (self.flag !=1) {
                MainViewController * tabbar = (MainViewController *)self.tabBarController;
                [tabbar showTabBar];
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else if (alertView.tag ==9503) {
        if (buttonIndex == 0) {
            [self toResultView];
        }
    }else if(alertView.tag ==11111)
    {
//        NSLog(@"test flag =%d",self.flag);
        if (self.flag !=1) {
            MainViewController * tabbar = (MainViewController *)self.tabBarController;
            [tabbar showTabBar];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

