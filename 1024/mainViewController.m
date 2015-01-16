//
//  mainViewController.m
//  1024
//
//  Created by froda on 15/1/16.
//  Copyright (c) 2015年 froda. All rights reserved.
//

#import "mainViewController.h"
#import "LuckyLabel.h"

@interface mainViewController ()<UIAlertViewDelegate,AVAudioPlayerDelegate>{
    int score;
    UILabel *scoreLable;
    AVAudioPlayer *bgMusic;
}

@end

@implementation mainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"执行了viewDidLoad方法！");
    [super viewDidLoad];
    [self addGesture];
    [self addBackGround];
    
    [self initData];
    [self firstBornLabel];
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reset.frame = CGRectMake(20,20,40,40);
    [reset setTitle:@"重玩" forState:UIControlStateNormal];
    reset.backgroundColor = [UIColor clearColor];
    [reset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(resetPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reset];
    
    score = 0;
    scoreLable = [[UILabel alloc]initWithFrame:CGRectMake(180, 20, 150, 40)];
    scoreLable.text = [NSString stringWithFormat:@"分数：%i",score];
    scoreLable.font = [UIFont systemFontOfSize:22];
    scoreLable.textColor = [UIColor orangeColor];
    [self.view addSubview:scoreLable];
    
    [self initBackgroundMusic];
    
}
#pragma mark 初始化背景音乐
-(void)initBackgroundMusic{
    NSString *soundName = @"BGM";
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
    NSURL *musicUrl = [NSURL fileURLWithPath:soundFilePath];
    bgMusic = [[AVAudioPlayer alloc]initWithContentsOfURL:musicUrl error:nil];
    bgMusic.delegate = self;
    bgMusic.numberOfLoops = 100;
    bgMusic.volume = 0.9 ;
    [bgMusic play];
}
#pragma mark 初始化数据
-(void)initData
{
    NSLog(@"执行了initData方法！");
    self.emptyPlaceArray =  [NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInt:11],
                             [NSNumber numberWithInt:21],
                             [NSNumber numberWithInt:31],
                             [NSNumber numberWithInt:41],
                             [NSNumber numberWithInt:12],
                             [NSNumber numberWithInt:22],
                             [NSNumber numberWithInt:32],
                             [NSNumber numberWithInt:42],
                             [NSNumber numberWithInt:13],
                             [NSNumber numberWithInt:23],
                             [NSNumber numberWithInt:33],
                             [NSNumber numberWithInt:43],
                             [NSNumber numberWithInt:14],
                             [NSNumber numberWithInt:24],
                             [NSNumber numberWithInt:34],
                             [NSNumber numberWithInt:44],
                             
                             nil];
    
    self.currentExistArray = [NSMutableArray arrayWithCapacity:16];
    self.labelArray = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:4],
                       nil];
    
    [self resetGameState];
    
}
#pragma mark 重置游戏状态
-(void)resetGameState
{
    NSLog(@"执行了resetGameState方法！");
    self.canBornNewLabel = NO;
    self.isOver = NO;
    self.R_1 = YES;
    self.R_2 = YES;
    self.R_3 = YES;
    self.R_4 = YES;
    self.C_1 = YES;
    self.C_2 = YES;
    self.C_3 = YES;
    self.C_4 = YES;
    
}
#pragma mark 初始化方块
-(void)firstBornLabel
{
    NSLog(@"执行了firstBornLabel方法！");
    int random;
    for (int i=0; i<2; i++) {
        random = arc4random()%(self.emptyPlaceArray.count-1);
        
        NSNumber *place = [self.emptyPlaceArray objectAtIndex:random];
        [self.emptyPlaceArray removeObject:place];
        LuckyLabel *label = [[LuckyLabel alloc]init];
        label.placeTag = [place intValue];
        //        label.backgroundColor = [UIColor greenColor];
        //        label.tintColor = [UIColor blackColor];
        //        label.textAlignment = NSTextAlignmentCenter;
        NSDictionary *dic =  [self caculatePosition:place];
        
        int random2 = arc4random()%2;//随机数
        //        label.numberTag = random2;
        NSNumber *textNumber = [self.labelArray objectAtIndex:random2];
        label.numberTag = textNumber.intValue;
        label.text =[NSString stringWithFormat:@"%@",textNumber];
        NSLog(@"----------%i",label.numberTag);
        [self choseColor:label.numberTag andLable:label];
        CGRect frame =  CGRectMake([[dic objectForKey:kPlaceX] intValue]+1, [[dic objectForKey:kPlaceY] intValue]+1, kOneLabelwidth-2, kOneLabelHeight-2);
        
        label.frame = frame;
        //        label.placeTag = [place intValue];
        [self.currentExistArray addObject:label];
        [self.view addSubview:label];
    }
    
}
#pragma mark 计算位置
-(NSDictionary *)caculatePosition:(NSNumber *)placeNumber
{
    NSLog(@"执行了caculatePosition方法！");
    int place = [placeNumber intValue];
    int x = 20+kOneLabelwidth/2+kOneLabelwidth*(place/10-1);
    int y = 60+kOneLabelHeight/2+kOneLabelHeight*(place%10-1);
    x = x-kOneLabelwidth/2;
    y = y-kOneLabelHeight/2;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [NSNumber numberWithInt:x],kPlaceX,
                         [NSNumber numberWithInt:y],kPlaceY,
                         nil];
    
    return dic;
    
}
#pragma mark 计分的方法
-(void)countScore{
    scoreLable.text = [NSString stringWithFormat:@"分数：%i",score];
}
#pragma mark 选择颜色的方法
-(void)choseColor:(int)tag andLable:(UILabel *)lable{
    switch (tag) {
        case 2:
            lable.backgroundColor = [UIColor colorWithRed:0.825 green:0.846 blue:0.875 alpha:1.000];
            break;
        case 4:
            lable.backgroundColor = [UIColor colorWithRed:0.869 green:0.906 blue:0.464 alpha:1.000];
            break;
        case 8:
            lable.backgroundColor = [UIColor colorWithRed:0.558 green:0.852 blue:0.887 alpha:1.000];
            break;
        case 16:
            lable.backgroundColor = [UIColor colorWithRed:0.286 green:0.532 blue:0.592 alpha:1.000];
            break;
        case 32:
            lable.backgroundColor = [UIColor colorWithRed:0.578 green:0.772 blue:0.420 alpha:1.000];
            break;
        case 64:
            lable.backgroundColor = [UIColor colorWithRed:0.626 green:0.633 blue:0.936 alpha:1.000];
            break;
        case 128:
            lable.backgroundColor = [UIColor colorWithRed:0.951 green:0.650 blue:0.861 alpha:1.000];
            break;
        case 256:
            lable.backgroundColor = [UIColor colorWithRed:1.000 green:0.482 blue:0.053 alpha:1.000];
            break;
        case 512:
            lable.backgroundColor = [UIColor colorWithRed:0.848 green:0.730 blue:0.154 alpha:1.000];
            break;
        case 1024:
            lable.backgroundColor = [UIColor colorWithRed:0.801 green:0.356 blue:0.553 alpha:1.000];
            break;
        default:
            break;
    }
}
#pragma mark 合并方块，并产生方块
-(void)bornNewLabel
{
    NSLog(@"执行了bornNewLabel方法！");
    [self.emptyPlaceArray removeAllObjects];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:11]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:21]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:31]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:41]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:12]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:22]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:32]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:42]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:13]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:23]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:33]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:43]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:14]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:24]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:34]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInt:44]];
    for (LuckyLabel *label in self.currentExistArray) {
        [self.emptyPlaceArray removeObject:[NSNumber numberWithInt:label.placeTag]];
    }
    int random;
    
    if (self.emptyPlaceArray.count>1) {
        random = arc4random()%(self.emptyPlaceArray.count-1);
    }else
    {
        random = 0;
    }
    NSNumber *place = [self.emptyPlaceArray objectAtIndex:random];
    LuckyLabel *label = [[LuckyLabel alloc]init];
    label.placeTag = [place intValue];
    NSDictionary *dic =  [self caculatePosition:place];
    int random2 = arc4random()%2;
    //    label.numberTag = random2;
    NSNumber *textNumber = [self.labelArray objectAtIndex:random2];
    label.numberTag = textNumber.intValue;
    label.text =[NSString stringWithFormat:@"%@",textNumber];
    [self countScore];
    [self choseColor:label.numberTag andLable:label];
    CGRect frame =  CGRectMake([[dic objectForKey:kPlaceX] intValue]+1, [[dic objectForKey:kPlaceY] intValue]+1, kOneLabelwidth-2, kOneLabelHeight-2);
    label.frame = frame;
    
    [self.currentExistArray addObject:label];
    [self.view addSubview:label];
    
    
}
-(void)setStateFlagDirection:(int)direction andPlace:(int) rORc
{
    NSLog(@"执行了setStateFlagDirection方法！");
    if ((direction == kRight ) || (direction == kLeft)) {
        
        switch (rORc) {
            case 1:
                self.R_1 = NO;
                break;
            case 2:
                self.R_2 = NO;
                break;
            case 3:
                self.R_3 = NO;
                break;
            case 4:
                self.R_4 = NO;
                break;
                
            default:
                break;
        }
        
        
    }else if ((direction == kUp ) || (direction == kDown))
    {
        switch (rORc) {
            case 1:
                self.C_1 = NO;
                break;
            case 2:
                self.C_2 = NO;
                break;
            case 3:
                self.C_3 = NO;
                break;
            case 4:
                self.C_4 = NO;
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    
}
-(BOOL)selfStateIsValid:(LuckyLabel *)label andDirection:(int)direction
{
    NSLog(@"执行了selfStateIsValid方法！");
    if ((direction == kRight ) || (direction == kLeft))
    {
        switch (label.placeTag%10) {
            case 1:
                return self.R_1;
                break;
            case 2:
                return self.R_2;
                break;
            case 3:
                return self.R_3;
                break;
            case 4:
                return self.R_4;
                break;
            default:
                break;
        }
        
    }else if ((direction == kUp ) || (direction == kDown))
    {
        
        switch (label.placeTag/10) {
            case 1:
                return self.C_1;
                break;
            case 2:
                return self.C_2;
                break;
            case 3:
                return self.C_3;
                break;
            case 4:
                return self.C_4;
                break;
            default:
                break;
        }
        
    }
    
    return NO;
    
}
#pragma mark 合并方块算分
-(BOOL)isFrontLabelEmpty:(LuckyLabel *)label andDirection:(int) direction
{
    NSLog(@"执行了isFrontLabelEmpty方法！");
    
    switch (direction) {
        case kRight:
            for (LuckyLabel *childLabel in self.currentExistArray) {
                
                if ((label.placeTag+10) == childLabel.placeTag) {
                    return NO;
                }
            }
            break;
        case kLeft:
            for (LuckyLabel *childLabel in self.currentExistArray) {
                
                if ((label.placeTag-10) == childLabel.placeTag) {
                    return NO;
                }
            }
            break;
        case kUp:
            for (LuckyLabel *childLabel in self.currentExistArray) {
                
                if ((label.placeTag-1) == childLabel.placeTag) {
                    return NO;
                }
            }
            break;
        case kDown:
            for (LuckyLabel *childLabel in self.currentExistArray) {
                
                if ((label.placeTag+1) == childLabel.placeTag) {
                    return NO;
                }
            }
            break;
            
        default:
            break;
    }
    
    
    return YES;
}
#pragma mark 判断游戏是否结束
-(void)isGameOver
{
    NSLog(@"执行了isGameOver方法！");
    self.isOver = YES;
    [self moveLabel:1];
    [self moveLabel:2];
    [self moveLabel:3];
    [self moveLabel:4];
    
    if (self.isOver == YES) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"游戏结束啦！" message:@"Game Over!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重玩", nil];
        [alter show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"-----%d",buttonIndex);
    [self resetPlay];
    
}
#pragma mark 重玩的方法
-(void)resetPlay{
    NSLog(@"执行了resetPlay方法！");
    for (int i = 0; i < [self.currentExistArray count]; i++) {
        [self.currentExistArray[i] setHidden:YES];
    }
    [self.currentExistArray removeAllObjects];
    score = 0;
    scoreLable.text = @"";
    [bgMusic stop];
    [self viewDidLoad];
}

#pragma mark 产生新的方块
-(int)checkFrontLabel:(LuckyLabel *)label andDirection:(int) direction
{
    NSLog(@"执行了checkFrontLabelf方法！");
    switch (direction) {
        case 1: //right
            for (LuckyLabel *childLabel in self.currentExistArray) {
                if ((label.placeTag + 10 == childLabel.placeTag) && (label.numberTag == childLabel.numberTag)) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        CGRect frame2 = label.frame;
                        frame2.origin.x += 70;
                        label.placeTag += 10;
                        label.frame = frame2;
                        label.numberTag = label.numberTag*2;
                        label.text = [NSString stringWithFormat:@"%d",label.numberTag];
                    }];
                    [self choseColor:label.numberTag andLable:label];
                    [self setStateFlagDirection:1 andPlace:label.placeTag%10];
                    [self.currentExistArray removeObject:childLabel];
                    [childLabel removeFromSuperview];
                    NSLog(@"+%i",label.numberTag);
                    score += label.numberTag;
                    NSLog(@"分数：%i",score);
                    [self countScore];
                    self.canBornNewLabel = YES;
                    self.isOver = NO;
                    return kHaveSameNumberLabel;
                }else if ((label.placeTag + 10 == childLabel.placeTag) && (label.numberTag!=childLabel.numberTag))
                {
                    return kHaveDifferentLabel;
                    
                }
            }
            
            if ((label.placeTag + 10)/10 == 4) {
                label.placeTag += 10;
                CGRect frame2 = label.frame;
                frame2.origin.x += 70;
                
                label.frame = frame2;
                self.canBornNewLabel =YES;
                return kHaveNoLabel;
                
            }
            else
            {
                label.placeTag += 10;
                CGRect frame2 = label.frame;
                frame2.origin.x += 70;
                label.frame = frame2;
                self.canBornNewLabel = YES;
                if ([self selfStateIsValid:label andDirection:2] || [self  isFrontLabelEmpty:label andDirection:1]) {
                    [self checkFrontLabel:label andDirection:1];
                    
                }
            }
            
            
            break;
        case 2: // left
            for (LuckyLabel *childLabel in self.currentExistArray) {
                if ((label.placeTag - 10 == childLabel.placeTag) && (label.numberTag == childLabel.numberTag)) {
                    [UIView animateWithDuration:0.3 animations:^{
                        CGRect frame2 = label.frame;
                        frame2.origin.x -= 70;
                        label.placeTag -= 10;
                        label.frame = frame2;
                        label.numberTag = label.numberTag*2;
                        label.text = [NSString stringWithFormat:@"%d",label.numberTag];
                    }];
                    [self choseColor:label.numberTag andLable:label];
                    [self setStateFlagDirection:2 andPlace:label.placeTag%10];
                    [self.currentExistArray removeObject:childLabel];
                    [childLabel removeFromSuperview];
                    score += label.numberTag;
                    [self countScore];
                    self.canBornNewLabel = YES;
                    self.isOver = NO;
                    return kHaveSameNumberLabel;
                }else if ((label.placeTag - 10 == childLabel.placeTag) && (label.numberTag!=childLabel.numberTag))
                {
                    
                    return kHaveDifferentLabel;
                }
            }
            //            label.placeTag += 10;
            if ((label.placeTag - 10)/10 == 1) {
                label.placeTag -= 10;
                CGRect frame2 = label.frame;
                frame2.origin.x -= 70;
                
                label.frame = frame2;
                self.canBornNewLabel = YES;
                return kHaveNoLabel;
            }else
            {
                label.placeTag -= 10;
                CGRect frame2 = label.frame;
                frame2.origin.x -= 70;
                label.frame = frame2;
                self.canBornNewLabel = YES;
                if ([self selfStateIsValid:label andDirection:2]) {
                    [self checkFrontLabel:label andDirection:2];
                }
                
            }
            break;
        case 3: // up
            for (LuckyLabel *childLabel in self.currentExistArray) {
                if ((label.placeTag - 1 == childLabel.placeTag) && (label.numberTag == childLabel.numberTag)) {
                    [UIView animateWithDuration:0.3 animations:^{
                        CGRect frame3 = label.frame;
                        frame3.origin.y -= 100;
                        label.placeTag -= 1;
                        label.frame = frame3;
                        label.numberTag = label.numberTag*2;
                        label.text = [NSString stringWithFormat:@"%d",label.numberTag];
                    }];
                    [self choseColor:label.numberTag andLable:label];
                    [self setStateFlagDirection:3  andPlace:label.placeTag/10];
                    [self.currentExistArray removeObject:childLabel];
                    [childLabel removeFromSuperview];
                    score += label.numberTag;
                    [self countScore];
                    self.canBornNewLabel = YES;
                    self.isOver = NO;
                    return kHaveSameNumberLabel;
                    
                }else if ((label.placeTag - 1 == childLabel.placeTag) && (label.numberTag!=childLabel.numberTag))
                {
                    return kHaveDifferentLabel;
                }
            }
            if ((label.placeTag - 1)%10 == 1) {
                label.placeTag -= 1;
                CGRect frame3 = label.frame;
                frame3.origin.y -= 100;
                
                label.frame = frame3;
                self.canBornNewLabel = YES;
                return kHaveNoLabel;
            }else
            {
                label.placeTag -= 1;
                CGRect frame3 = label.frame;
                frame3.origin.y -= 100;
                label.frame = frame3;
                self.canBornNewLabel = YES;
                if ([self selfStateIsValid:label andDirection:3]) {
                    [self checkFrontLabel:label andDirection:3];
                }
                
            }
            
            
            break;
        case 4: // down
            for (LuckyLabel *childLabel in self.currentExistArray) {
                if ((label.placeTag + 1 == childLabel.placeTag) && (label.numberTag == childLabel.numberTag)) {
                    [UIView animateWithDuration:0.3 animations:^{
                        CGRect frame4 = label.frame;
                        frame4.origin.y += 100;
                        label.placeTag += 1;
                        label.frame = frame4;
                        label.numberTag = label.numberTag*2;
                        label.text = [NSString stringWithFormat:@"%d",label.numberTag];
                    }];
                    [self choseColor:label.numberTag andLable:label];
                    [self setStateFlagDirection:3  andPlace:label.placeTag/10];
                    [self.currentExistArray removeObject:childLabel];
                    [childLabel removeFromSuperview];
                    score += label.numberTag;
                    [self countScore];
                    self.canBornNewLabel = YES;
                    self.isOver = NO;
                    return kHaveSameNumberLabel;
                    
                }else if ((label.placeTag +1 == childLabel.placeTag) && (label.numberTag!=childLabel.numberTag))
                {
                    return kHaveDifferentLabel;
                }
            }
            if ((label.placeTag + 1)%10 == 4) {
                label.placeTag += 1;
                CGRect frame4 = label.frame;
                frame4.origin.y += 100;
                
                label.frame = frame4;
                self.canBornNewLabel = YES;
                return kHaveNoLabel;
            }else
            {
                label.placeTag += 1;
                CGRect frame4 = label.frame;
                frame4.origin.y += 100;
                label.frame = frame4;
                self.canBornNewLabel = YES;
                if ([self selfStateIsValid:label andDirection:4]) {
                    [self checkFrontLabel:label andDirection:4];
                }
                
            }
            
            break;
            
        default:
            break;
    }
    
    return 0;
    
}

#pragma mark 移动方块
-(void)moveLabel:(int) directionFlag
{
    NSLog(@"执行了moveLabel方法！");
    NSMutableArray *array1 = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *array2 = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *array3 = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *array4 = [[NSMutableArray alloc]initWithCapacity:4];
    
    switch (directionFlag)
    {
        case 1: //right
            for (LuckyLabel *label in self.currentExistArray) {
                switch (label.placeTag/10) {
                    case 4:
                        [array1 addObject:label];
                        break;
                    case 3:
                        [array2 addObject:label];
                        break;
                    case 2:
                        [array3 addObject:label];
                        break;
                    case 1:
                        [array4 addObject:label];
                        break;
                    default:
                        break;
                }
            }
            for (LuckyLabel *childLabel in array2) {
                
                [self checkFrontLabel:childLabel andDirection:1];
            }
            for (LuckyLabel *childLabel in array3) {
                
                [self checkFrontLabel:childLabel andDirection:1];
            }
            for (LuckyLabel *childLabel in array4) {
                [self checkFrontLabel:childLabel andDirection:1];
            }
            break;
        case 2: //left
            for (LuckyLabel *label in self.currentExistArray) {
                switch (label.placeTag/10) {
                    case 1:
                        [array1 addObject:label];
                        break;
                    case 2:
                        [array2 addObject:label];
                        break;
                    case 3:
                        [array3 addObject:label];
                        break;
                    case 4:
                        [array4 addObject:label];
                        break;
                    default:
                        break;
                }
            }
            for (LuckyLabel *childLabel in array2) {
                [self checkFrontLabel:childLabel andDirection:2];
                
            }
            for (LuckyLabel *childLabel in array3) {
                [self checkFrontLabel:childLabel andDirection:2];
                
            }
            for (LuckyLabel *childLabel in array4) {
                [self checkFrontLabel:childLabel andDirection:2];
                
            }
            break;
        case 3: // up
            for (LuckyLabel *label in self.currentExistArray) {
                switch (label.placeTag%10) {
                    case 1:
                        [array1 addObject:label];
                        break;
                    case 2:
                        [array2 addObject:label];
                        break;
                    case 3:
                        [array3 addObject:label];
                        break;
                    case 4:
                        [array4 addObject:label];
                        break;
                    default:
                        break;
                }
            }
            for (LuckyLabel *childLabel in array2) {
                [self checkFrontLabel:childLabel andDirection:3];
            }
            for (LuckyLabel *childLabel in array3) {
                [self checkFrontLabel:childLabel andDirection:3];
            }
            for (LuckyLabel *childLabel in array4) {
                [self checkFrontLabel:childLabel andDirection:3];
            }
            break;
        case 4: // down
            for (LuckyLabel *label in self.currentExistArray) {
                switch (label.placeTag%10) {
                    case 4:
                        [array1 addObject:label];
                        break;
                    case 3:
                        [array2 addObject:label];
                        break;
                    case 2:
                        [array3 addObject:label];
                        break;
                    case 1:
                        [array4 addObject:label];
                        break;
                    default:
                        break;
                }
            }
            
            for (LuckyLabel *childLabel in array2) {
                [self checkFrontLabel:childLabel andDirection:4];
            }
            for (LuckyLabel *childLabel in array3) {
                [self checkFrontLabel:childLabel andDirection:4];
            }
            for (LuckyLabel *childLabel in array4) {
                [self checkFrontLabel:childLabel andDirection:4];
            }
            break;
        default:
            break;
    }
    
}

#pragma mark 画框框，添加背景，更改背景
-(void)addBackGround
{
    NSLog(@"执行了addBackGround方法！");
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageView];
    
    //self.view.backgroundColor=[UIColor whiteColor];
    //更改背景图片
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpeg"]];
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);//更改线条的粗细
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.710, 0.672, 0.621, 1);//更改线的颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    //0.825 green:0.846 blue:0.875 alpha:1.000]
    [UIColor colorWithRed:0.710 green:0.672 blue:0.621 alpha:1.000];
    // 边框
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 20, 60);//（20，60）是画线的起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 300, 60);//300是边框的横着的长度，60是画线终止是
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 300, 460);//（300, 460)是结束的坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 20, 460);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 20, 60);
    
    // 竖线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 90, 60);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 90, 460);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 160, 60);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 160, 460);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 230, 60);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 230, 460);
    
    // 横线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 20, 160);//第二根横线
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 300, 160);//第二根横线
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 20, 260);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 300, 260);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 20, 360);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 300, 360);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
}
#pragma mark 添加手势
-(void)addGesture
{
    NSLog(@"执行了addGesture方法！");
    UISwipeGestureRecognizer *swip;
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipFrom:)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipFrom:)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swip];
    
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipFrom:)];
    swip.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swip];
    
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipFrom:)];
    swip.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swip];
    
}
//手势所触发的方法
-(void)swipFrom:(UISwipeGestureRecognizer *)swip
{
    NSLog(@"执行了swipFrom方法！");
    [self resetGameState];
    self.view.userInteractionEnabled = NO;//设置当前视图不接收事件消息
    switch (swip.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"right");
            
            [self moveLabel:1];
            
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"left");
            
            [self moveLabel:2];
            
            break;
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"up");
            [self moveLabel:3];
            
            
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"down");
            [self moveLabel:4];
            
            break;
        default:
            break;
    }
    
    if (self.currentExistArray.count < 16 && self.canBornNewLabel) {
        [self bornNewLabel];
    }else if (self.currentExistArray.count == 16)
    {
        [self isGameOver];
    }
    
    
    [self.view performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithInt:1] afterDelay:0.4f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
