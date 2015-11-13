//
//  M_schoolViewController.m
//  Mfeiji
//
//  Created by susu on 14-10-20.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "M_schoolViewController.h"
#import "SchoolDetail_ViewController.h"

@interface M_schoolViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *backgroudView;
    UITableView *findeTableView;
    NSMutableArray *allArr;
    NSArray * topImageArr;
    UIView * whiteView;
    UIPageControl *pageControl;
    
    int pageFlag;
    int page;
    int requePage ;
}
@property (nonatomic , retain) cyCleScroll *mainScorllView;

@end

@implementation M_schoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    allArr = [[NSMutableArray alloc] init];
    [self myDrawNav];
    [self initTableView];
}

-(void)myDrawNav
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-100, 20)];
    title.text = @"我的航校";
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [backgroudView addSubview:title];
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, Main_Screen_Width, Main_Screen_Height -49 -70)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backgroudView addSubview:whiteView];
    if (self.flag ==1) {
        UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
        [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
        [backBt addTarget:self action:@selector(findeChoose:) forControlEvents:UIControlEventTouchUpInside];
        backBt.tag = 200;
        [backgroudView addSubview:backBt];
    }
}

-(void)findeChoose:(UIButton *)sender
{
    MainViewController * tabbar = (MainViewController *)self.tabBarController;
    [tabbar showTabBar];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)initTableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    findeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,Main_Screen_Height/2-13, Main_Screen_Width, Main_Screen_Height/2-35)];
    findeTableView.delegate =self;
    findeTableView.dataSource =self;
     [findeTableView setTableFooterView:view];
    [findeTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [findeTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview:findeTableView];
    if (self.flag ==1) {
        findeTableView.frame =CGRectMake(0,Main_Screen_Height/2-13, Main_Screen_Width, Main_Screen_Height/2+13);
    }
    [findeTableView headerBeginRefreshing];
}

-(void)initPage{
    NSMutableArray *viewsArray = [@[] mutableCopy];
    if (topImageArr.count>0) {
        for (int i=0; i<topImageArr.count; i++) {
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(i*Main_Screen_Width, 0, Main_Screen_Width, Main_Screen_Height/2-100)];
            [image setImageWithURL:topImageArr[i][@"image"] placeholderImage:[UIImage imageNamed:@"introduce_zhanwei.png"]];
            image.userInteractionEnabled=YES;

            [viewsArray addObject:image];
        }
        
        UILabel * labelText=[[UILabel alloc]initWithFrame:CGRectMake(10, Main_Screen_Height/2-33, Main_Screen_Width-30, 20)];
        labelText.backgroundColor=[UIColor clearColor];
        labelText.font=[UIFont boldSystemFontOfSize:13];
        labelText.text= topImageArr[page][@"title"];
        labelText.textColor=[UIColor blackColor];
        labelText.alpha = 0.6;
        [self.view addSubview:labelText];
        self.mainScorllView = [[cyCleScroll alloc] initWithFrame:CGRectMake(0, 68, Main_Screen_Width, Main_Screen_Height/2-100) animationDuration:5];
        
        self.mainScorllView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.];
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return viewsArray.count;
        };
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            [self handleGer:pageIndex];
        };
        self.mainScorllView.onePage =  ^(NSInteger pageIndex)
        {
            page = pageIndex ;
            pageControl.currentPage= page;
            labelText.text= topImageArr[page][@"title"];
        };
        [self.view addSubview:self.mainScorllView];
        [self.mainScorllView firstPage:0];
        
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0*Main_Screen_Width*topImageArr.count, Main_Screen_Height/2-110, Main_Screen_Width, 5)];
        pageControl.backgroundColor=[UIColor clearColor];
        pageControl.currentPage= 0;
        pageControl.numberOfPages= topImageArr.count;
        pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        [self.mainScorllView addSubview:pageControl];
        
    }else
    {
        UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, Main_Screen_Width-30, Main_Screen_Height/2-110)];
        topImage.image = [UIImage imageNamed:@"picture.png"];
        [whiteView addSubview:topImage];
    }
}

-(void)handleGer:(int)index{
    if ([[topImageArr objectAtIndex:index]objectForKey:@"id"]!=nil) {
        NSURL * url = [NSURL URLWithString:topImageArr[index][@"image"]];
        NSData * data = [NSData dataWithContentsOfURL:url];
        MainViewController * tabbar = (MainViewController *)self.tabBarController;
        [tabbar hiddenTabBarYes];
        SchoolDetail_ViewController * detail  = [[SchoolDetail_ViewController alloc] init];
        detail.schoolId = [[topImageArr objectAtIndex:index]objectForKey:@"id"];
        detail.shareTitle =[[topImageArr objectAtIndex:index] objectForKey:@"title"];
        detail.shareImage = [ImageSizeManager getSmallImageWithOldImage:[UIImage imageWithData:data]];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

-(void)getPage:(int)num
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str =[NSString stringWithFormat:@"http://api.mfeiji.com/v1/schools?page=%d",pageFlag];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dic = responseObject;
        topImageArr = [dic objectForKey:@"images"];
        if (pageFlag == 1) {
            [allArr removeAllObjects];
        }
        [allArr addObjectsFromArray:[dic objectForKey:@"schools"]];
        [findeTableView footerEndRefreshing];
        [findeTableView headerEndRefreshing];
        [findeTableView reloadData];
        if (requePage != 1) {
            [self initPage];
        }
        requePage =1;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [findeTableView footerEndRefreshing];
        [findeTableView headerEndRefreshing];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = [NSString stringWithFormat:@"请求失败，请检查网络是否链接。"];
        [HUD hide:YES afterDelay:1.];
        if (requePage != 1) {
            [self initPage];
        }
    }];
}
-(void)headerRefresh
{
    pageFlag = 1;
    [self getPage:pageFlag];
}

-(void)footerRefresh
{
    [self getPage:++pageFlag];
}

#pragma mark -tableView

//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allArr.count;
}

//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }else{
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
    }
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 60 ,44)];
    [image setImageWithURL:[[allArr objectAtIndex:indexPath.row]objectForKey:@"first_image"] placeholderImage:nil];
    [cell.contentView addSubview:image];
    
    //zhu biao ti
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, Main_Screen_Width-90, 20)];
    titleLable.text = [[allArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    titleLable.font = [UIFont systemFontOfSize:14.];
    [cell.contentView addSubview:titleLable];
    
    //fu biao ti
    UILabel *contenLable =[[UILabel alloc] initWithFrame:CGRectMake(80, 27, Main_Screen_Width-90, 30)];
    contenLable.text =[[allArr objectAtIndex:indexPath.row] objectForKey:@"abstract"];
    contenLable.font = [UIFont systemFontOfSize:12.];
    contenLable.lineBreakMode = NSLineBreakByWordWrapping;
    contenLable.numberOfLines = 0;
      contenLable.alpha = 0.5;
    [cell.contentView addSubview:contenLable];
    
    return cell;
}

//改变行的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSURL * url = [NSURL URLWithString:[[allArr objectAtIndex:indexPath.row]objectForKey:@"first_image"]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    MainViewController * tabbar = (MainViewController *)self.tabBarController;
    [tabbar hiddenTabBarYes];
    SchoolDetail_ViewController * detail  = [[SchoolDetail_ViewController alloc] init];
    detail.schoolId = [[allArr objectAtIndex:indexPath.row]objectForKey:@"id"];
    detail.shareTitle =[[allArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    detail.shareImage = [ImageSizeManager getSmallImageWithOldImage:[UIImage imageWithData:data]];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
