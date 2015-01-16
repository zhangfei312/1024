//
//  mainViewController.h
//  1024
//
//  Created by froda on 15/1/16.
//  Copyright (c) 2015年 froda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define kOneLabelwidth 70  //宏定义，方块的宽
#define kOneLabelHeight 100 //方块的高
#define kPlaceX @"X"
#define kPlaceY @"Y"
#define kHaveSameNumberLabel 10
#define kHaveNoLabel 20
#define kHaveDifferentLabel 30

#define kRight 1  //右面用1表示
#define kLeft 2
#define kUp 3
#define kDown 4

@interface mainViewController : UIViewController

@property(nonatomic,retain)NSMutableArray *currentExistArray;
@property(nonatomic,retain)NSMutableArray *emptyPlaceArray;
@property(nonatomic,retain)NSArray *labelArray;
@property(nonatomic,retain)NSArray *testArray;

@property(nonatomic)BOOL  R_1;//行
@property(nonatomic)BOOL  R_2;
@property(nonatomic)BOOL  R_3;
@property(nonatomic)BOOL  R_4;

@property(nonatomic)BOOL  C_1;//列
@property(nonatomic)BOOL  C_2;
@property(nonatomic)BOOL  C_3;
@property(nonatomic)BOOL  C_4;

@property(nonatomic)BOOL canBornNewLabel;
@property(nonatomic)BOOL isOver;

@end
