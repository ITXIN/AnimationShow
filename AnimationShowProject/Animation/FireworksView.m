//
//  FireworksView.m
//  AnimationShowProject
//
//  Created by Bert on 16/7/20.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "FireworksView.h"
#import "WordsAndDrawerLayer.h"
#import "DrawLineAnimationView.h"
@implementation FireworksView
{
    NSInteger index;
    DrawLineAnimationView *ligthningView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        index = (NSInteger)arc4random()%3 + 1;
        NSLog(@"-----index %ld",index);
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:frame];
        bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"SH-night-%ld",index]];
        [self addSubview:bgImageView];

        [self setupFireworks];//烟花
        [self setupRain];//雨
        [self setupFire];//火
        [self setupSnow];//雪
        //闪电
        ligthningView = [[DrawLineAnimationView alloc]initWithFrame:frame];
        ligthningView.alpha = 0.5;
        [self addSubview:ligthningView];
       NSTimer* timer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(drawLighningTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)drawLighningTimer
{
    if (ligthningView)
    {
        [ligthningView setNeedsDisplay];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (id layer in self.layer.sublayers) {
        if([layer isKindOfClass:[WordsAndDrawerLayer  class]])
        {
            [layer removeFromSuperlayer];
        }
    }
    [WordsAndDrawerLayer createAnimationLayerWithWordsStr:@"Cool" rect:CGRectMake(0, 200, self.frame.size.width, self.frame.size.width) view:self font:[UIFont systemFontOfSize:40] strokeColor:[UIColor purpleColor]];
}



- (void)setupFireworks
{
    
    CAEmitterLayer *fireworksEmitterLay = [CAEmitterLayer layer];
    CGRect viewBounds = self.layer.bounds;
    fireworksEmitterLay.emitterPosition = CGPointMake(CGRectGetWidth(viewBounds)/2, CGRectGetHeight(viewBounds));//发射位置
//    if (index == 4 || index == 5)
//    {
//       fireworksEmitterLay.emitterPosition = CGPointMake(-10, CGRectGetHeight(viewBounds));
//    }

    fireworksEmitterLay.emitterSize = CGSizeMake(1.0, 0.0);//发射源的尺寸大
    fireworksEmitterLay.emitterMode = kCAEmitterLayerOutline;////发射模式
    fireworksEmitterLay.emitterShape = kCAEmitterLayerLine;//发射源的形状
    fireworksEmitterLay.renderMode = kCAEmitterLayerAdditive;//renderMode:渲染模式：
//    fireworksEmitterLay.emitterDepth = nil;//决定粒子形状的深度联系：emittershape
    //emitterZposition:发射源的z坐标位置；
    
    //发射粒子
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];//粒子发射的粒子
    rocket.birthRate = 6.0;//.birthRate 顾名思义没有这个也就没有effectCell，这个必须要设置，具体含义是每秒某个点产生的effectCell数量,粒子参数的速度乘数因子
    rocket.emissionRange = 0.12*M_PI;//周围发射角度
    rocket.velocity = 500;//velocity & velocityRange & emissionRange 表示cell向屏幕右边飞行的速度 & 在右边什么范围内飞行& ＋－角度扩散
    rocket.velocityRange = 150;
    rocket.yAcceleration = 0;//粒子y方向的加速度分量;zAcceleration:粒子z方向的加速度分量;xAcceleration:粒子x方向的加速度分量
    rocket.lifetime = 2.03;//当 birthrate < 1.0 时设置这个属性无效,.lifetime & lifetimeRange 表示effectCell的生命周期，既在屏幕上的显示时间要多长。
    rocket.contents = (id)[[UIImage imageNamed:@"ball"] CGImage];//这个和CALayer一样，只是用来设置图片
    rocket.scale = 0.2;//缩放比例,scaleRange：缩放比例范围； scaleSpeed：缩放比例速度：
    rocket.greenRange = 255.0;//
    rocket.redRange = 255.0;
    rocket.blueRange = 255.0;//一个粒子的颜色blue 能改变的范围；
//    rocket.blueSpeed = 0.0;//粒子blue在生命周期内的改变速度
    rocket.spinRange = M_PI;//slow spin
    
//    rocket.name = @"";//name 这个是当effectCell存在caeEmitter 的emitterCells中用来辨认的。用到setValue forKeyPath比较有用
//    rocket.alphaRange = 1;// 一个粒子的颜色alpha能改变的范围；
//    rocket.alphaSpeed = 2;//粒子透明度在生命周期内的改变速度；
//    rocket.color = RGB(arc4random()%255, arc4random()%255, arc4random()%255).CGColor;
//    rocket.contentsRect = nil;//应该画在contents里的子rectangle：
//    rocket.emissionLatitude = 0;//发射的z轴方向的角度
//    rocket.emissionLongitude = 0;//x-y平面的发射方向
//    rocket.enabled = YES;//粒子是否被渲染
//    rocket.magnificationFilter = nil;//不是很清楚好像增加自己的大小
//    rocket.minificationFilter = nil;//减小自己的大小
//    rocket.minificationFilterBias = 2;//减小大小的因子
    rocket.style = nil;//应该是样式
    
    //爆炸粒子
    CAEmitterCell *burst = [CAEmitterCell emitterCell];
    burst.birthRate = 1.0;
    burst.velocity = 0;
    burst.scale = 2.5;
    burst.redSpeed = -1.5;
    burst.blueSpeed = +1.5;
    burst.greenSpeed = +1.0;
    burst.lifetime = 0.35;
    
    //火花粒子
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    spark.birthRate = 666;
    spark.velocity = 125;
    spark.emissionRange = 2*M_PI;//角度扩散
    spark.yAcceleration = 75;
    spark.lifetime = 3;
    spark.contents = (id)[[UIImage imageNamed:@"fire"] CGImage];
    spark.scale = 0.5;
    spark.scaleSpeed = -0.2;
    spark.greenSpeed = -0.1;
    spark.redSpeed = 0.4;
    spark.blueSpeed = -0.1;
    spark.alphaSpeed = -0.5;
    spark.spin = 2*M_PI;//子旋转角度
    spark.spinRange = 2*M_PI;//子旋转角度范围
    
    fireworksEmitterLay.emitterCells = [NSArray arrayWithObject:rocket];
    rocket.emitterCells = [NSArray arrayWithObject:burst];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    [self.layer addSublayer:fireworksEmitterLay];
    
}
/**
 *  CA_EXTERN NSString * const kCAEmitterLayerPoints
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器中发出
 CA_EXTERN NSString * const kCAEmitterLayerOutline
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器边缘发出
 CA_EXTERN NSString * const kCAEmitterLayerSurface
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器表面发出
 CA_EXTERN NSString * const kCAEmitterLayerVolume
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//从发射器中点发出
 */
//fireworksEmitterLay.emitterShape = kCAEmitterLayerPoint;//发射源的形状
/**
 *  CA_EXTERN NSString * const kCAEmitterLayerPoint
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0); //点的形状，粒子从一个点发出
 CA_EXTERN NSString * const kCAEmitterLayerLine
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//线的形状，粒子从一条线发出
 CA_EXTERN NSString * const kCAEmitterLayerRectangle
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//矩形形状，粒子从一个矩形中发出
 CA_EXTERN NSString * const kCAEmitterLayerCuboid
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//立方体形状，会影响Z平面的效果
 CA_EXTERN NSString * const kCAEmitterLayerCircle
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//圆形，粒子会在圆形范围发射
 CA_EXTERN NSString * const kCAEmitterLayerSphere
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//球型
 */
//fireworksEmitterLay.renderMode = kCAEmitterLayerOldestLast;//renderMode:渲染模式：
/**
 *  CA_EXTERN NSString * const kCAEmitterLayerUnordered
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，粒子是无序出现的，多个发射源将混合
 CA_EXTERN NSString * const kCAEmitterLayerOldestFirst
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，声明久的粒子会被渲染在最上层
 CA_EXTERN NSString * const kCAEmitterLayerOldestLast
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，年轻的粒子会被渲染在最上层
 CA_EXTERN NSString * const kCAEmitterLayerBackToFront
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式下，粒子的渲染按照Z轴的前后顺序进行
 CA_EXTERN NSString * const kCAEmitterLayerAdditive
 __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);//这种模式会进行粒子混合
 */

- (void)setupSnow
{
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition =  CGPointMake(CGRectGetWidth(self.frame)/2, -30);
    snowEmitter.emitterSize = CGSizeMake(CGRectGetWidth(self.frame)*2, 0.0);
    snowEmitter.emitterMode = kCAEmitterLayerOutline;
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    
    CAEmitterCell *snowFlake = [CAEmitterCell emitterCell];
    snowFlake.scale = 0.2;
    snowFlake.scaleRange = 0.5;
    snowFlake.birthRate = 20.0;
    snowFlake.lifetime = 60.0;
    snowFlake.velocity = 20;
    snowFlake.velocityRange = 10;
    snowFlake.yAcceleration = 2;
    snowFlake.emissionRange = 0.5*M_PI;
    snowFlake.spinRange = 0.25*M_PI;
    snowFlake.contents = (id)[[UIImage imageNamed:@"fire"] CGImage];
    snowFlake.color = [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius = 0.0;
    snowEmitter.shadowOffset = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor = [[UIColor whiteColor]CGColor];
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowFlake];
    [self.layer addSublayer:snowEmitter];
    
}



- (void)setupRain
{
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition =  CGPointMake(CGRectGetWidth(self.frame)/2, -30);
    snowEmitter.emitterSize = CGSizeMake(CGRectGetWidth(self.frame)*2, 0.0);
    snowEmitter.emitterMode = kCAEmitterLayerOutline;
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    
    CAEmitterCell *snowFlake = [CAEmitterCell emitterCell];
    snowFlake.scale = 0.2;
    snowFlake.scaleRange = 0.5;
    snowFlake.birthRate = 500.0;
    snowFlake.lifetime = 60.0;
    snowFlake.velocity = 20;
    snowFlake.velocityRange = 10;
    snowFlake.yAcceleration = 1500;
    snowFlake.emissionRange = 0.5*M_PI;
    snowFlake.spinRange = 0.25*M_PI;
    
    snowFlake.contents = (id)[[UIImage imageNamed:@"fire"] CGImage];
    snowFlake.color = [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius = 0.0;
    snowEmitter.shadowOffset = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor = [[UIColor whiteColor]CGColor];
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowFlake];
    [self.layer addSublayer:snowEmitter];
    
    
}

- (void)setupFire
{
    //设置发射器
    CAEmitterLayer * _fireEmitter=[[CAEmitterLayer alloc]init];
    _fireEmitter.emitterPosition=CGPointMake(self.frame.size.width/2,self.frame.size.height-20);
    _fireEmitter.emitterSize=CGSizeMake(self.frame.size.width-100, 20);
    _fireEmitter.renderMode = kCAEmitterLayerAdditive;
    //发射单元
    //火焰
    CAEmitterCell * fire = [CAEmitterCell emitterCell];
    fire.birthRate=800;
    fire.lifetime=2.0;
    fire.lifetimeRange=1.5;
    fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
    fire.contents=(id)[[UIImage imageNamed:@"fire"]CGImage];
    [fire setName:@"fire"];
    
    fire.velocity=160;
    fire.velocityRange=80;
    fire.emissionLongitude=M_PI+M_PI_2;
    fire.emissionRange=M_PI_2;
    fire.scaleSpeed=0.3;
    fire.spin=0.2;
    
    //烟雾
    CAEmitterCell * smoke = [CAEmitterCell emitterCell];
    smoke.birthRate=400;
    smoke.lifetime=3.0;
    smoke.lifetimeRange=1.5;
    smoke.color=[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05]CGColor];
    smoke.contents=(id)[[UIImage imageNamed:@"fire"]CGImage];
    [fire setName:@"smoke"];
    
    smoke.velocity=250;
    smoke.velocityRange=100;
    smoke.emissionLongitude=M_PI+M_PI_2;
    smoke.emissionRange=M_PI_2;
    
    _fireEmitter.emitterCells=[NSArray arrayWithObjects:smoke,fire,nil];
    [self.layer addSublayer:_fireEmitter];
    
}




@end
