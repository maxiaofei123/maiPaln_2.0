//
//  Test_noAnswer_ViewController.h
//  Mfeiji
//
//  Created by susu on 14-12-7.
//  Copyright (c) 2014年 susu. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WTwoViewControllerDelegate <NSObject>

-(void)setQuestionTest:(int)number;

@end

@interface Test_noAnswer_ViewController : UIViewController

@property (strong,nonatomic)NSArray * weidaArry;

@property (nonatomic, unsafe_unretained) id<WTwoViewControllerDelegate> delegate;

@end

