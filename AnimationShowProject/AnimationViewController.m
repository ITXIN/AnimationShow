//
//  AnimationViewController.m
//  LoadingAnimation
//
//  Created by Bert on 16/7/19.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "AnimationViewController.h"
#import "ProgressAnimationView.h"
#import "FireworksView.h"
#import "CircleAnimationView.h"
#import "DrawLineAnimationView.h"
@implementation AnimationViewController
{
    ProgressAnimationView *loadingView ;
    NSTimer *timer;
    FireworksView *fireworkView;
    CircleAnimationView *cireView;
    DrawLineAnimationView *drwaLineAnimationView;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [startBtn addTarget:self action:@selector(startLoading:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:startBtn];
    [startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    switch (self.index) {
        case 0:
        {
            loadingView = [[ProgressAnimationView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400)];
            loadingView.center = self.view.center;
            [self.view addSubview:loadingView];
        }
            break;
        case 1:
        {
            startBtn.hidden = YES;
            fireworkView = [[FireworksView alloc]initWithFrame:self.view.bounds];
            [self.view addSubview:fireworkView];
        }
            break;
        case 2:
        {
            cireView  = [[CircleAnimationView alloc]initWithFrame:self.view.bounds];
            [self.view insertSubview:cireView belowSubview:startBtn];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            drwaLineAnimationView = [[DrawLineAnimationView alloc]initWithFrame:self.view.bounds];
            [self.view insertSubview:drwaLineAnimationView belowSubview:startBtn];
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
        default:
            break;
    }
    

}

#pragma mark -
#pragma mark --- startloding
- (void)startLoading:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        timer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loadingTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }else
    {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark -
#pragma mark --- LoadingTimer
- (void)loadingTimer
{
    if (loadingView) {
       [loadingView updateProgressViewConstraints];
    }
    if (drwaLineAnimationView) {
        [drwaLineAnimationView setNeedsDisplay];
    }
    NSLog(@"-----loadingTimer");
    
}
@end
