//
//  CircleAnimationView.m
//  AnimationShowProject
//
//  Created by Bert on 16/7/21.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "CircleAnimationView.h"

@implementation CircleAnimationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.satelliteImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        self.satelliteImageView.image = [UIImage imageNamed:@"satellite"];
//        self.satelliteImageView.backgroundColor = [UIColor redColor];
        self.satelliteImageView.layer.cornerRadius = CGRectGetWidth(self.satelliteImageView.frame)/2;
        [self addSubview:self.satelliteImageView];
    }
    return self;
}



-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    
    CGRect boundingRect = CGRectMake(100, 300, 200-32, 200-32);
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = CFAutorelease(CGPathCreateWithEllipseInRect(boundingRect, NULL));
    orbit.duration = 4;
    orbit.additive = YES;
    orbit.repeatCount = HUGE_VALF;
    orbit.calculationMode = kCAAnimationPaced;
//    orbit.rotationMode = kCAAnimationRotateAuto;
    orbit.rotationMode = nil;
    
    //图片的尺寸会影响圆周运动的效果.
    [self.satelliteImageView.layer addAnimation:orbit forKey:@"orbit"];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 33, 43, 23, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddArc(context, 200, 400, 70, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextAddRect(context, boundingRect);
    CGContextAddEllipseInRect(context, boundingRect); //椭圆
    CGContextDrawPath(context, kCGPathStroke);

}
/**
 http://www.cnblogs.com/wengzilin/p/4256468.html
 http://my.oschina.net/cao6793569/blog/505046
 *  - IOS 核心动画之CAKeyframeAnimation
 
 - 简单介绍
 
 是CApropertyAnimation的子类，跟CABasicAnimation的区别是：CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue)，而CAKeyframeAnimation会使用一个NSArray保存这些数值
 
 - 属性解析：
 
 - values：就是上述的NSArray对象。里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧
 
 - path：可以设置一个CGPathRef\CGMutablePathRef,让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略
 
 - keyTimes：可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的
 
 - 说明：CABasicAnimation可看做是最多只有2个关键帧的CAKeyframeAnimation
 */





@end
