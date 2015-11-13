//
//  AppDelegate.m
//  Mfeiji
//
//  Created by susu on 14-10-20.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Exam_loginViewController.h"

@interface AppDelegate ()<UIScrollViewDelegate>
{
    UIScrollView* scrollView;
    UIPageControl *pageControl;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 启动页 2秒后消失
    [NSThread sleepForTimeInterval:2.0];
    self.window.backgroundColor = [UIColor blackColor];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //判断程序是不是第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        //初始化用户名
        [[NSUserDefaults standardUserDefaults] setObject:@"麦飞机会员" forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"无" forKey:@"avatar"];
        //显示引导页
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, screenHeight)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(self.window.frame.size.width *4, screenHeight);
        scrollView.bounces = NO;
        scrollView.delegate =self;
        scrollView.pagingEnabled = YES;
        [self.window addSubview:scrollView];
        
        for (int i=0; i<4; i++) {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.window.frame.size.width, 0, self.window.frame.size.width, screenHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.jpg",i+1]];
            [scrollView addSubview:imageView];
            if (i ==3) {
                
                UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
                start.frame = CGRectMake(0, 0, 80, 34);
                [start setCenter:CGPointMake(self.window.frame.size.width*3 +(self.window.frame.size.width/2),self.window.frame.size.height-100)];
                [start addTarget:self action:@selector(intoNext) forControlEvents:UIControlEventTouchUpInside];
                [start setImage:[UIImage imageNamed:@"tiYan.png"] forState:UIControlStateNormal];
                [scrollView addSubview:start];
            }
        }
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, self.window.frame.size.height-160, self.window.frame.size.width, 3)];
        pageControl.backgroundColor=[UIColor clearColor];
        pageControl.currentPage = 0;
        pageControl.numberOfPages = 4;
        pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:56./255 green:66./255 blue:96./255 alpha:1.];
        [self.window addSubview:pageControl];
        
    }else
    {
        [self intoNext];
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    // 后台间隔请求
    
    //向微信注册
    [WXApi registerApp:kWXAPP_ID];
    [WXApi registerApp:kWXAPP_ID withDescription:@"weixin"];
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    [WeiboSDK handleOpenURL:url delegate:self] ;
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

////授权后回调 WXApiDelegate
//-(void)onResp:(BaseReq *)resp
//{
//    SendAuthResp *aresp = (SendAuthResp *)resp;
//    if (aresp.errCode== 0) {
//        NSString *code = aresp.code;
////        NSDictionary *dic = @{@"code":code};
//        [self getAccess_token:aresp.code];
//    }
//}
-(void)getAccess_token:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWeiXinAppSecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic =%@",dic);
                
                //                self.access_token.text = [dic objectForKey:@"access_token"];
                //                self.openid.text = [dic objectForKey:@"openid"];
                [self getUserInfo:[dic objectForKey:@"access_token"] openId:[dic objectForKey:@"openid"]];
                
            }
        });
    });
}
-(void)getUserInfo:(NSString *)accessToken openId:(NSString *)open_id
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,open_id];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"nike dic =%@",dic);
                //                self.nickname.text = [dic objectForKey:@"nickname"];
                //                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                //
            }
        });
        
    });
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView{
    int x = ascrollView.contentOffset.x/Main_Screen_Width;
    pageControl.currentPage=x;
}

-(void)intoNext
{
    [scrollView removeFromSuperview];
    MainViewController  * mainView = [[MainViewController alloc] init];
    self.window.rootViewController = mainView;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "fanChen.com.Mfeiji" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mfeiji" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mfeiji.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
