//
//  Test_checkAnswer_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-7.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Test_checkAnswer_ViewController.h"
#import "CycleScrollView.h"

@interface Test_checkAnswer_ViewController ()<UIScrollViewDelegate>
{
    UIView * backgroudView;
    UIView *huiBg;

    NSArray * abcArr;
    int page;
    UILabel * numberLable;
}

@property (nonatomic , retain) CycleScrollView *mainScorllView;

@end

@implementation Test_checkAnswer_ViewController

@synthesize showDic , textId,ztDic;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, Main_Screen_Width,Main_Screen_Height-20);
    backgroudView.backgroundColor = [UIColor colorWithRed:35./255 green:41./255 blue:70./255 alpha:1.];
    [self.view addSubview:backgroudView];
    
    huiBg = [[UIView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height-70-58)];
    huiBg.backgroundColor = [UIColor colorWithRed:239./255 green:239./255 blue:239./255 alpha:1.];
    [backgroudView addSubview:huiBg];
    abcArr = [[NSArray alloc] initWithObjects:@"A、",@"B、",@"C、", nil];
    NSLog(@"dic =%@",ztDic);
    [self drawView];
    [self drawNav];
    [self drawTabbar];
}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 1;
    [backgroudView addSubview:backBt];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"查看答案";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
}

-(void)drawView
{
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i<80; i++) {
        
        UIScrollView * testScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height-70-58)];
        testScrollView.backgroundColor = [UIColor clearColor];
        testScrollView.delegate = self ;
        [viewsArray addObject:testScrollView];
        
        // test
        NSDictionary * dic = [[showDic objectForKey:@"textName"] objectAtIndex:i];
      
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
        UIImageView* tempView = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-image.size.width/2, titleLable.frame.origin.y+lableH, image.size.width, image.size.height)];
        NSArray * urlArr = [dic objectForKey:@"attachments"];
        if (urlArr.count>0) {
            NSString * urlStr = [[[[urlArr objectAtIndex:0] objectForKey:@"image"] objectForKey:@"thumb"] objectForKey:@"url"];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            image = [UIImage imageWithData:data];
            tempView.frame =CGRectMake(Main_Screen_Width/2-image.size.width/2, titleLable.frame.origin.y+lableH+5, image.size.width, image.size.height);
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

        //设置之前的选中状态
        NSString * valueStr = [[NSString alloc] init];
        valueStr =[ztDic objectForKey:[NSString stringWithFormat:@"%d",i]];
        int tag = [valueStr  intValue];
        NSString *queStr =[[showDic objectForKey:@"answer"] objectAtIndex:i];//此试题的答案序号
        int queValue = [queStr intValue];
        
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
            //选项
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, h+20+j*10, Main_Screen_Width, contentH)];
            view.backgroundColor = [UIColor clearColor];
            view.tag = i;
            [testScrollView addSubview:view];
            
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
            
            //判断是否正确 给出不同的显示
            if (tag == j) {
                NSLog(@"test");
                contentImage.image=[UIImage imageNamed:@"test_xuan2.png"];
                if (tag ==queValue) {
                    lable.textColor = [UIColor greenColor];
                }else
                {
                    lable.textColor = [UIColor redColor];
                }
            }else if(j == queValue)
            {
                lable.textColor = [UIColor greenColor];
            }
            float linshiH = h;
            h = linshiH+contentH;
            if ((h+100)>Main_Screen_Height-58) {
                testScrollView.contentSize = CGSizeMake(Main_Screen_Width,h+50);
            }else
            {
                testScrollView.contentSize =CGSizeMake(Main_Screen_Width,Main_Screen_Height-70-58);
            }
        }
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
        numberLable.text = [NSString stringWithFormat:@"%d /80",page+1];
    };
    [self.view addSubview:self.mainScorllView];
    [self.mainScorllView weiZuo:self.textId];
}

-(void)drawTabbar
{
    //--------tabbar按钮--------
    static UIView *viewTab;
    viewTab = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 64)];
    viewTab.backgroundColor = [UIColor colorWithRed:35./255 green:41./255 blue:70./255 alpha:1.];
    [self.view addSubview:viewTab];
    
    UIButton *Lbutton = [[UIButton alloc] initWithFrame:CGRectMake(15, 2, 35, 30)];
    [Lbutton setImage:[UIImage imageNamed:@"test_left.png"] forState:UIControlStateNormal];
    Lbutton.tag = 2;
    [Lbutton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:Lbutton];
    
    UIButton *Rbutton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-53, 2, 35, 30)];
    [Rbutton setImage:[UIImage imageNamed:@"test_next.png"] forState:UIControlStateNormal];
    Rbutton.tag = 3;
    [Rbutton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:Rbutton];
    
    //----tabarlable
    UILabel *lableName1 = [[UILabel alloc] initWithFrame:CGRectMake(13  ,35, 50, 15)];
    lableName1.text = @"上一题";
    lableName1.textColor = [UIColor whiteColor];
    lableName1.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableName1];
    
    UILabel *lableName5 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60  ,35, 50, 15)];
    lableName5.text = @"下一题";
    lableName5.textColor = [UIColor whiteColor];
    lableName5.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableName5];
  
    numberLable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-30  ,18,60, 20)];
    numberLable.text = [NSString stringWithFormat:@"%d /80",page+1];
    numberLable.textColor = [UIColor whiteColor];
    numberLable.textAlignment = NSTextAlignmentCenter;
    numberLable.font = [UIFont systemFontOfSize:18];
    [viewTab addSubview:numberLable];
    
}


-(void)choose:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {

            [self.navigationController popViewControllerAnimated:YES ];
        }
            break;
        case 2:
        {
            //上一题
            [self.mainScorllView changePage:page-1 nextOrago:0];
        }
            break;
        case 3:
        {
            // next text
            [self.mainScorllView changePage:page+1 nextOrago:1];
        }
            break;

        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
