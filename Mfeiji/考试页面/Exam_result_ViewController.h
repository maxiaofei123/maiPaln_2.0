//
//  Exam_result_ViewController.h
//  Mfeiji
//
//  Created by susu on 14-12-1.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Exam_result_ViewController : UIViewController
@property (strong ,nonatomic) M_examViewController *examView;
@property (nonatomic) int useTime;
@property (nonatomic) int useSec;
@property (nonatomic) float  resultScore;
@property (strong ,nonatomic)NSDictionary *checkDic;
@property (strong,nonatomic)NSDictionary *zhuangtai;
@end
