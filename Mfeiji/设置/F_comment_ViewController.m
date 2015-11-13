//
//  F_comment_ViewController.m
//  Mfeiji
//
//  Created by susu on 14-12-3.
//  Copyright (c) 2014年 susu. All rights reserved.
//
#define maxLength  120
#import "F_comment_ViewController.h"
#import "AFURLRequestSerialization.h"

@interface F_comment_ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UIView *backgroudView;
    UITableView * commentTableView;
    NSMutableArray *allArr;
    int pageFlag;
    int height ;
    
    UIView *textbackView;
    UITextView * textView;
    
}
@property (nonatomic,assign) BOOL isChange;
@property (nonatomic,assign) BOOL reduce;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@end

@implementation F_comment_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    backgroudView = [[UIView alloc] init];
    backgroudView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:backgroudView];
    allArr = [[NSMutableArray alloc] init];
    [self drawNav];
    [self initTableView];
    [self initTextView];
    
}

-(void)initTableView
{
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, Main_Screen_Width, Main_Screen_Height -70-40)];
    commentTableView.delegate =self;
    commentTableView.dataSource =self;
    commentTableView.backgroundColor = [UIColor whiteColor];
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [commentTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [commentTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [backgroudView addSubview:commentTableView];
    UITapGestureRecognizer *pass1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yinCang)];
    [commentTableView addGestureRecognizer:pass1];
    [commentTableView headerBeginRefreshing];
}

-(void)yinCang
{
    [textView resignFirstResponder];
}

-(void)initTextView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    textbackView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-50, Main_Screen_Width, 50)];
    textbackView.backgroundColor = [UIColor colorWithRed:17/255. green:23/255. blue:41/255. alpha:1.];
    [self.view addSubview:textbackView];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, Main_Screen_Width-70, 30)];
    textView.backgroundColor = [UIColor colorWithRed:97/255. green:106/255. blue:130/255. alpha:1.];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:14.];
    [textView.layer setBorderWidth:1];
    textView.delegate = self;
    textView.text =@"请输入120字以内的评论";
    [textView.layer setBorderColor:[[UIColor whiteColor] CGColor]];  //设置边框为蓝色
    [textbackView addSubview:textView];
    
    
    UIButton * send = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width-40,17, 32, 15)];
    [send setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(findeChoose:) forControlEvents:UIControlEventTouchUpInside];
    send.tag = 101;
    [textbackView addSubview:send];

}

-(void)textViewDidChange:(UITextView *)ctextView
{
    NSString *content= ctextView.text;
    CGSize contentSize=[content sizeWithFont:[UIFont systemFontOfSize:14.0]];
    if(contentSize.width>textView.frame.size.height){
        if(!self.isChange){
            CGRect keyFrame= textbackView.frame;
            self.originalKey=keyFrame;
            keyFrame.size.height=keyFrame.size.height+20;
            keyFrame.origin.y-= keyFrame.size.height*0.25;
            textbackView.frame=keyFrame;
            
            CGRect textFrame= textView.frame;
            self.originalText=textFrame;
            textFrame.size.height+=textFrame.size.height*0.5+14*0.2;
            textView.frame=textFrame;
            self.isChange=YES;
            self.reduce=YES;
        }
    }
    
    if(contentSize.width<=Main_Screen_Width-70){
        
        if(self.reduce){
            textbackView.frame= self.originalKey;
            textView.frame=self.originalText;
            self.isChange=NO;
            self.reduce=NO;
        }
    }
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    if ( [textView.text isEqualToString:@"请输入120字以内的评论"]) {
                textView.text = @"";
            }
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = textbackView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    textbackView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}



- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    // 键盘的动画时间，设定与其完全保持一致
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 键盘的动画是变速的，设定与其完全保持一致
    NSValue *animationCurveObject =[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    CGRect newTextViewFrame = textbackView.frame;
    newTextViewFrame.origin.y = Main_Screen_Height - textbackView.frame.size.height;
    textbackView.frame = newTextViewFrame;
    [UIView commitAnimations];
}

-(void)textViewEditChanged:(NSNotification *)obj{
    
    UITextView *text = (UITextView *)obj.object;
    NSString *toBeString = text.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [text markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [text positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        
        if (!position) {
            
            if (toBeString.length > maxLength) {
                
                text.text = [toBeString substringToIndex:maxLength];
                
            }
            
        }
        
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        
        else{
            
            
            
        }
        
    }
    
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    
    else{
        
        if (toBeString.length > maxLength) {
            
            text.text = [toBeString substringToIndex:maxLength];
            
        }
        
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if(new.length > maxLength){
        
        if (![text isEqualToString:@""]) {
            
            return NO;
            
        }
    }
    return YES;
}


-(void)commitComment:(NSString *)text
{
    textView.frame = CGRectMake(20, 10, Main_Screen_Width-70, 30);
    textbackView.frame = CGRectMake(0, Main_Screen_Height-50, Main_Screen_Width, 50);
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (text.length <1 || [text isEqualToString:@"请输入120字以内的评论"]) {
       HUD.labelText = @"评论内容为空";
        [HUD hide:YES afterDelay:1.];
    }else
    {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
        NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
        NSString * textStr = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str =[[NSString alloc] initWithFormat:@"http://api.mfeiji.com/v1/comments?user_token=%@&user_email=%@&%@=%@&comment[comment]=%@",token,email,self.schoolOrFind,_scId,textStr];
        HUD.labelText = @"正在提交评论...";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
    //        NSLog(@"res =%@",responseObject);
            HUD.labelText = [NSString stringWithFormat:@"评论成功"];
            [HUD hide:YES afterDelay:1.];
            textView.text =@"";
            [commentTableView headerBeginRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"error =%@",error);
             HUD.labelText = @"提交失败,请检查网络链接";
             [HUD hide:YES afterDelay:1.];
         }];
    }
}

-(void)headerRefresh
{
    pageFlag = 1 ;
    [self getPage:pageFlag];
}

-(void)footerRefresh
{
    [self getPage:++pageFlag];
}


-(void)getPage:(int)num
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str =[NSString stringWithFormat:@"http://api.mfeiji.com/v1/comments?page=%d&%@=%@",pageFlag,self.schoolOrFind,_scId];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *arr=responseObject;
        NSLog(@"dic =%@",arr);
        if (pageFlag ==1) {
            [allArr removeAllObjects];
        }
        [allArr addObjectsFromArray:arr];
        [commentTableView footerEndRefreshing];
        [commentTableView headerEndRefreshing];
        [commentTableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [commentTableView footerEndRefreshing];
        [commentTableView headerEndRefreshing];
    }];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary * dic = [allArr objectAtIndex:indexPath.row];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:11.];
    CGSize size = CGSizeMake(Main_Screen_Width-80, 2000);
    CGSize labelsize =[[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment"]] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    float h ;
    h = labelsize.height>40?labelsize.height+5:40;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(15, 5, Main_Screen_Width-30, h+ 25)];
    view.backgroundColor = [UIColor colorWithRed:34/255. green:33/255. blue:43/255. alpha:1.];
    [cell.contentView addSubview:view];

    // heade
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10 , 42  , 42)];
    [headView setImageWithURL:[[allArr objectAtIndex:indexPath.row]objectForKey:@"avatar"] placeholderImage:nil];
    if (headView.image ==nil) {
        headView.image = [UIImage imageNamed:@"test.jpg"];
    }
    [view addSubview:headView];
    //圆角设置
    headView.layer.cornerRadius = 21;
    headView.layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [headView.layer setBorderWidth:1];
    [headView.layer setBorderColor:[[UIColor whiteColor] CGColor]];  //设置边框为蓝色
    //自动适应,保持图片宽高比
//    headView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 120, 12)];
    nameLable.text = [dic objectForKey:@"username"];
    nameLable.textColor = [UIColor whiteColor];
//    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = [UIFont systemFontOfSize:12.];
    [view addSubview:nameLable];
    
    UILabel * date = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2 +80, 5, 80, 15)];
    date.text = [[dic objectForKey:@"date"] substringToIndex:10];
    date.textColor = [UIColor whiteColor];
    date.font = [UIFont systemFontOfSize:9.];
    date.alpha = 0.3;
    [view addSubview:date];

    UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(53, 20, view.frame.size.width -55, h)];
    comment.textColor = [UIColor whiteColor];
    comment.text = [dic objectForKey:@"comment"];
    comment.lineBreakMode = NSLineBreakByWordWrapping;
    comment.numberOfLines = 0;
    comment.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.];
    [view addSubview:comment];

    if (indexPath.row%2 ==1) {
        headView.frame = CGRectMake(view.frame.size.width -48 , 10,42, 42);
        nameLable.frame = CGRectMake(view.frame.size.width-170, 8 ,120, 12);
        nameLable.textAlignment = NSTextAlignmentRight;
        date.frame = CGRectMake(10, 5, 80, 15);
        comment.frame = CGRectMake(3, 20, view.frame.size.width -55, h);
        comment.textAlignment = NSTextAlignmentRight;
    }
    return cell;
}

//改变行的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:11.];
    CGSize size = CGSizeMake(Main_Screen_Width-80, 2000);
    CGSize labelsize =[[NSString stringWithFormat:@"%@",[[allArr objectAtIndex:indexPath.row] objectForKey:@"comment"]] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    float h ;
    h = labelsize.height>40?labelsize.height+5:40;
    return  h + 40;
}

-(void)drawNav
{
    //nav
    UIButton *backBt =[[UIButton alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    [backBt setImage:[UIImage imageNamed:@"public_back.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(findeChoose:) forControlEvents:UIControlEventTouchUpInside];
    backBt.tag = 200;
    [backgroudView addSubview:backBt];
}

-(void)findeChoose:(UIButton *)sender
{
    if (sender.tag ==200) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (sender.tag == 101) {
        [textView resignFirstResponder];
        [self commitComment:textView.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
