//
//  DrawLineAnimationView.m
//  AnimationShowProject
//
//  Created by Bert on 16/7/21.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "DrawLineAnimationView.h"

@implementation DrawLineAnimationView
{
    NSMutableArray *pointArr;//主干上的点
    NSMutableArray *branchLightningStartPointArr;
    NSMutableArray *bezierPathArr;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        pointArr = [NSMutableArray array];
        branchLightningStartPointArr = [NSMutableArray array];
        bezierPathArr = [NSMutableArray array];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self deleteLayers];
    
    
//    [self lineAnimationWithRect:rect];
   
    //闪电
    for (int i = 0; i < (arc4random()%1+ 5); i ++)
    {
        [self drawLigtning];
    }
}

#pragma mark -
#pragma mark --- 横向线动画
- (void)lineAnimationWithRect:(CGRect)rect
{
    CGPoint point ;
    [self setupPointArr];
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < pointArr.count; i ++)
    {
        point = CGPointFromString(pointArr[i]);
        if (i == 0)
        {
            //画线,设置起点
            [path moveToPoint:point];
        }else
        {
            //设置第二个条线的终点,会自动把上一个终点当做起点
            [path addLineToPoint:point];
        }
    }
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = rect;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor whiteColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinMiter;
    [self.layer addSublayer:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.2;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.repeatCount = 1;
    
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

#pragma mark -
#pragma mark ---  绘制闪电
- (void)drawLigtning
{
    [self setupLightPointArrWithStartPoint:CGPointMake(arc4random()%300 + 50,arc4random()%100 + 50) endPoint:CGPointMake(arc4random()%230 + 100,arc4random()%100 + 500) displace:3 ];
    [self setupBranchLightningPoint];
    [self setupLightningPath];
    [self setupLightningAnimation];
}




#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

/**
 *  删除 子layer
 */
- (void)deleteLayers
{
    if (self.layer.sublayers.count > 0)
    {
        NSArray *tempArray = [self.layer.sublayers copy];
        for (id layer in tempArray)
        {
            if ([layer isKindOfClass:[CAShapeLayer class]])
            {
                CAShapeLayer *tempLay = (CAShapeLayer*)layer;
                [tempLay removeFromSuperlayer];
                tempLay = nil;
            }
        }
    }
    [bezierPathArr removeAllObjects];
}


/**
 *  设置 point
 */
- (void)setupPointArr
{
    [pointArr removeAllObjects];
    NSInteger space = 0;
    for (int i = 0; i < 1000; i ++)
    {
        CGPoint point = CGPointMake(50+ (space += 1), arc4random()%5+150);
        [pointArr addObject:NSStringFromCGPoint(point)];
    }
}

/**
 *  设置闪电的主干的点
 */
- (void)setupLightPointArrWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint displace:(CGFloat)displace
{
    CGFloat midX = startPoint.x;
    CGFloat midY = startPoint.y;
    [pointArr removeAllObjects];
    [pointArr addObject:NSStringFromCGPoint(startPoint)];
//     NSLog(@"-----create first point  %@",NSStringFromCGPoint(CGPointMake(midX, midY)));
    while (midY < endPoint.y)
    {
        
        if (startPoint.x <  kScreenWidth/2 )
        {
            
            midX += (arc4random()%3 - 0.5)*displace;
            midY += (arc4random()%5 - 0.5)*displace;
        }else
        {
            midX -= (arc4random()%3 - 0.5)*displace;
            midY += (arc4random()%5 - 0.5)*displace;
        }
       
        
//        NSLog(@"-----create point  %@",NSStringFromCGPoint(CGPointMake(midX, midY)));
        [pointArr addObject:NSStringFromCGPoint(CGPointMake(midX, midY))];
    }
}

/**
 *  设置闪电分支的起点
 */

- (void)setupBranchLightningPoint
{
    NSInteger numberLight = arc4random()%2+5;
    do {
        
        CGPoint tempPoint = CGPointFromString(pointArr[arc4random()%pointArr.count]);
        if ([branchLightningStartPointArr containsObject:NSStringFromCGPoint(tempPoint)])
        {
            continue;
        }else
        {
            [branchLightningStartPointArr addObject:NSStringFromCGPoint(tempPoint)];
        }
    } while (branchLightningStartPointArr.count < numberLight);
}

/**
 *  设置闪电分支的点
 */

- (NSMutableArray *)setupBranchLightningPathPointWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint displace:(CGFloat)displace
{

    CGFloat midX = startPoint.x;
    CGFloat midY = startPoint.y;
    NSMutableArray *pathPointArr = [NSMutableArray array];

    //第一个起点
    [pathPointArr addObject:NSStringFromCGPoint(startPoint)];
    NSInteger numPathPoint = arc4random()%20+50;
    
    for (int i = 0; i < numPathPoint; i ++)
    {
        if (startPoint.x <  kScreenWidth/2 )
        {
            midX += (arc4random()%3 - 0.5)*displace;
            midY += (arc4random()%5 - 0.5)*displace;
        }else
        {
            midX -= (arc4random()%3 - 0.5)*displace;
            midY += (arc4random()%5 - 0.5)*displace;
        }
        [pathPointArr addObject:NSStringFromCGPoint(CGPointMake(midX, midY))];
    }
    return pathPointArr;
}

/**
 *  设置闪电的路径
 */
- (void)setupLightningPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [bezierPathArr addObject:path];
    CGPoint point ;
    for (int i = 0; i < pointArr.count; i ++)
    {
        point = CGPointFromString(pointArr[i]);
        
        if (i == 0)
        {
            //画线,设置起点
            [path moveToPoint:point];
        }else
        {
            //设置第二个条线的终点,会自动把上一个终点当做起点
            [path addLineToPoint:point];
        }
        
         NSLog(@"-----point%@ ",NSStringFromCGPoint(point));
        if ([branchLightningStartPointArr containsObject:NSStringFromCGPoint(point)])
        {
            NSMutableArray *branchPointArr = [self setupBranchLightningPathPointWithStartPoint:CGPointMake(point.x, point.y) endPoint:CGPointMake(point.x + 100, point.y + 100) displace:1];
            
            UIBezierPath *branchPath = [UIBezierPath bezierPath];
            CGPoint branchPoint;
            for (int j = 0; j < branchPointArr.count; j ++)
            {
                branchPoint = CGPointFromString(branchPointArr[j]);
                if (j == 0)
                {
                    //画线,设置起点
                    [branchPath moveToPoint:branchPoint];
                }else
                {
                    //设置第二个条线的终点,会自动把上一个终点当做起点
                    [branchPath addLineToPoint:branchPoint];
                }
            }
      
            [bezierPathArr addObject:branchPath];
          
        }
    }

}


/**
 *  设置闪电的动画效果
 */
- (void)setupLightningAnimation
{
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.2;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.repeatCount = 1;

    //透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 1.0;
    groupAnimation.animations = @[[self opacityForever_Animation:0.1], pathAnimation,opacityAnimation];
    groupAnimation.autoreverses = YES;
    groupAnimation.repeatCount = 1;
    
    for (int i = 0; i < bezierPathArr.count; i ++)
    {
        UIBezierPath *path = bezierPathArr[i];
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [[UIColor whiteColor] CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = (i == 0?1.0f:0.5);
        pathLayer.lineJoin = kCALineJoinMiter;
        [self.layer addSublayer:pathLayer];
        [pathLayer addAnimation:groupAnimation forKey:@"xxx"];
    }
}

/**
 http://blog.csdn.net/yongyinmg/article/details/38755955
 *  普通CALayer在被初始化时是需要给一个frame值的,这个frame值一般都与给定view的bounds值一致,它本身是有形状的,而且是矩形.
 
 CAShapeLayer在初始化时也需要给一个frame值,但是,它本身没有形状,它的形状来源于你给定的一个path,然后它去取CGPath值,它与CALayer有着很大的区别
 CAShapeLayer有着几点很重要:
 
 1. 它依附于一个给定的path,必须给与path,而且,即使path不完整也会自动首尾相接
 
 2. strokeStart以及strokeEnd代表着在这个path中所占用的百分比
 
 3. CAShapeLayer动画仅仅限于沿着边缘的动画效果,它实现不了填充效果
 */


@end
