//
//  BasicAnimationVC.m
//  AnimationShowProject
//
//  Created by Bert on 16/7/20. 动画代码忘记从哪个网友上面拷贝的了,感谢...
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "BasicAnimationVC.h"
@interface BasicAnimationVC ()
@property(nonatomic, strong)UILabel  *label;

@end
@implementation BasicAnimationVC
{
    NSArray *nameArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    nameArr = @[@"比例",@"移动",@"翻滚",@"组合动画",@"通明度",@"闪烁"];
    for (int i = 0; i <  nameArr.count; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 100;
        [btn setFrame:CGRectMake(50, 100 + i*50, 100, 30)];
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
    }
    
    [self SetupLayer];
}


- (void)SetupLayer{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(200, 100, 100, 30)];
    label.text = @"测试动画";
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    _label = label;
   
    
}

#pragma mark -
#pragma mark --- 
- (void)startAnimation:(UIButton*)sender
{
    [_label.layer removeAllAnimations];
    _label.text = nameArr[sender.tag-100];
    switch (sender.tag) {
        case 100:
        {
            //比例
            [_label.layer addAnimation:[self SetupScaleAnimation] forKey:@"scale"];
        }
         break;
         
        case 101:
        {
            //移动
            [_label.layer addAnimation:[self SetupMoveAnimation] forKey:@"scale"];

        }
            break;
        case 102:
        {
            //翻滚
            [_label.layer addAnimation:[self SetupRotationAnimation] forKey:@"scale"];
            
        }
            break;
        case 103:
        {
            //组合动画
            [_label.layer addAnimation:[self SetupGroupAnimation] forKey:@"scale"];
            
        }
            break;
        case 104:
        {
            //闪
            [_label.layer addAnimation:[self opacityTimes_Animation:3 durTimes:2] forKey:@"scale"];
        }
            break;
            case 105:
        {
           
            //通明度
            [_label.layer addAnimation:[self SetupOpacityAnimation] forKey:@"scale"];
        }
            break;
          
            case 106:
        {

            [_label.layer addAnimation:[self moveX:3 X:@300] forKey:@"scale"];
        }
            break;
            
        default:
            break;
    }
  
   
    
}

- (CAAnimation *)SetupScaleAnimation{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 3.0;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:3.0];
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    
    return scaleAnimation;
}


- (CAAnimation *)SetupMoveAnimation{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:_label.layer.position];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_label.layer.position.x, 667-60)];
    moveAnimation.autoreverses = YES;
    moveAnimation.duration = 3.0;
    return moveAnimation;
}

- (CAAnimation *)SetupRotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotationAnimation.duration = 1.5;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    rotationAnimation.fillMode = kCAFillModeBoth;
    return rotationAnimation;
}


- (CAAnimation *)SetupGroupAnimation{
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 3.0;
    groupAnimation.animations = @[[self SetupScaleAnimation], [self SetupMoveAnimation], [self SetupRotationAnimation]];
    groupAnimation.autoreverses = YES;
    groupAnimation.repeatCount = MAXFLOAT;
    return groupAnimation;
}

- (CABasicAnimation *)SetupOpacityAnimation

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    
    animation.toValue = [NSNumber numberWithFloat:0.0];
    
    animation.autoreverses = YES;
    
    animation.duration = 0.3;
    
    animation.repeatCount = FLT_MAX;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}

- (CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time; //有闪烁次数的动画

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    
    animation.toValue=[NSNumber numberWithFloat:0.4];
    
    animation.repeatCount=repeatTimes;
    
    animation.duration=time;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.autoreverses=YES;
    
    return  animation;
    
}


- (CABasicAnimation *)moveX:(float)time X:(NSNumber *)x //横向移动

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.toValue=x;
    
    animation.duration=time;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



- (CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y //纵向移动

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animation.toValue=y;
    
    animation.duration=time;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



- (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes //缩放

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue=orginMultiple;
    
    animation.toValue=Multiple;
    
    animation.duration=time;
    
    animation.autoreverses=YES;
    
    animation.repeatCount=repeatTimes;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



- (CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes //组合动画

{
    
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    
    animation.animations=animationAry;
    
    animation.duration=time;
    
    animation.repeatCount=repeatTimes;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



- (CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes //路径动画

{
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path=path;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.autoreverses=NO;
    
    animation.duration=time;
    
    animation.repeatCount=repeatTimes;
    
    return animation;
    
}



- (CABasicAnimation *)movepoint:(CGPoint )point //点移动

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
    animation.toValue=[NSValue valueWithCGPoint:point];
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



- (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount //旋转

{
    
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);
    
    CABasicAnimation* animation;
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    
    animation.duration= dur;
    
    animation.autoreverses= NO;
    
    animation.cumulative= YES;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    animation.repeatCount= repeatCount;
    
    animation.delegate= self;
    return animation;
    
}


@end
