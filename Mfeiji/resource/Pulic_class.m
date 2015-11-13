//
//  Pulic_class.m
//  Mfeiji
//
//  Created by susu on 14-10-20.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "Pulic_class.h"
#import "CommonCrypto/CommonDigest.h"

@implementation Pulic_class


+ (void)sendLinkContent:(int)type title:(NSString *)strTitle image:(UIImage *)image url:(NSString *)url
{
//    NSLog(@"str =%@ ，imge ＝%@  , url =%@",strTitle,image,url);
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = strTitle;
        if (strTitle == nil) {
            strTitle = @"麦飞机";
        }
        message.description = @"麦飞机精彩分享";
        if (image ==nil) {
            image = [UIImage imageNamed:@"test.jpg"];
        }
        [message setThumbImage:image];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        message.mediaObject = ext;
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (type == 0) {
            req.scene = WXSceneSession;
        }else
            req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
    }else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你的iPhone上还没有安装微信,无法使用此功能，去下载微信。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
        alView.tag = 100;
        [alView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100){
        if (buttonIndex == 1) {
            NSLog(@"wei xin ");
            NSString *weiXinLink = @"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weiXinLink]];
        }
    }
}

+(void)commitMySelfAvatar:(UIImage *)imageView
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"user_token",email,@"user_email", nil];
    NSData *imageData = UIImageJPEGRepresentation(imageView, 0.5);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/%@/updateavatar",userId]  parameters:dic constructingBodyWithBlock:^(id <AFMultipartFormData>formData){
     [formData appendPartWithFileData:imageData name:@"user[avatar]" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic =responseObject;
        NSLog(@"dic =%@",dic);
        HUD.labelText = @"提交成功。。。";
        [HUD hide:YES afterDelay:1.];
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error =%@",error);
        HUD.labelText = @"请求失败,请检查网络链接";
        [HUD hide:YES afterDelay:1.];
    }];
    
}

+(void)commitMySelfmessage:(NSString *)canshu canshuZhi:(NSString *)params
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
    NSDictionary *dicManager = [[NSDictionary alloc]initWithObjectsAndKeys:token,@"user_token",email,@"user_email",canshu,params, nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/users/%@?",userId] parameters:dicManager success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary * dic =responseObject;
//        NSLog(@"dic =%@",dic);
        HUD.labelText = @"提交成功。。。";
        [HUD hide:YES afterDelay:1.];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error =%@",error);
        HUD.labelText = @"请求失败,请检查网络链接";
        [HUD hide:YES afterDelay:1.];
    }];


}


+(NSString *)getTime
{
    NSDate*date = [NSDate date];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    
    NSDateComponents*comps;
    
    // 年月日获得
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
            
                       fromDate:date];
    
    NSInteger year = [comps year];
    
    NSInteger month = [comps month];
    
    NSInteger day = [comps day];
    
    //    NSLog(@"year:%ld month: %ld, day: %ld", (long)year, (long)month, (long)day);
    
    //当前的时分秒获得
    
    comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)
            
                       fromDate:date];
    NSInteger hour = [comps hour]-8;
    NSString * strHour = [NSString stringWithFormat:@"%ld",(long)hour];
    if (hour<10) {
        strHour = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    NSInteger minute = [comps minute];
    NSString * strMinute = [NSString stringWithFormat:@"%ld",(long)minute];
    if (minute<10) {
        strMinute = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    NSInteger second = [comps second];
    NSString * strSecond = [NSString stringWithFormat:@"%ld",(long)second];
    if (second<10) {
        strSecond = [NSString stringWithFormat:@"0%ld",(long)second];
    }
    NSString * time = [NSString stringWithFormat:@"%ld-%ld-%ldT%@:%@:%@",year,month,day,strHour,strMinute,strSecond];
//    NSLog(@"time =%@",time);
    return time;
}



+(void)loginOut
{
   
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSString *email =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"];
    NSLog(@"%@",[NSString stringWithFormat:@"http://api.mfeiji.com/v1/user_tokens/%@?user_email=%@&user_token=%@",token,email,token] );
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:[NSString stringWithFormat:@"http://api.mfeiji.com/v1/user_tokens/%@?user_email=%@&user_token=%@",token,email,token]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic =responseObject;
//        NSLog(@"dic =%@",dic);
  
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error =%@",error);
        NSDictionary *  dic = error.userInfo;
        NSData * data = [dic objectForKey:@"com.alamofire.serialization.response.error.data"];
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str =%@",str);
       
    }];

    
   }

@end
