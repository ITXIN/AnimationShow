//
//  LoadingAnimationView.m
//  LoadingAnimation
//
//  Created by Bert on 16/7/19.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "ProgressAnimationView.h"

@implementation ProgressAnimationView
{
    CGFloat trackW;
    CGFloat trackH;
    CGFloat progressW;
    CGFloat progressH;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bgView = [[UIView alloc]initWithFrame:self.bounds];
        self.downingView = [[UIImageView alloc]init];
        self.trackView = [[UIImageView alloc]init];
        self.progressView = [[UIImageView alloc]init];
        self.desLab = [[UILabel alloc]init];
        
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.downingView];
        [self.bgView addSubview:self.trackView];
        [self.bgView addSubview:self.progressView];
        [self.bgView addSubview:self.desLab];
        
        
        trackW = 200;
        trackH = 3;
        progressW = 10;
        progressH = 7;
        
        self.downingView.image = [UIImage imageNamed:@"rocket"];
        self.trackView.layer.cornerRadius = trackH/2;
        self.progressView.layer.cornerRadius = progressH/2;
        self.desLab.text = @"0%";
        self.desLab.textColor = [UIColor whiteColor];
        self.desLab.font = [UIFont systemFontOfSize:13.0];
        self.desLab.textAlignment = NSTextAlignmentCenter;
        
        self.bgView.backgroundColor = [UIColor blackColor];
        self.trackView.backgroundColor =  HEX_ARGB(@"#11cd6e");
        self.progressView.backgroundColor = HEX_ARGB(@"#11cd6e");
//        self.desLab.backgroundColor = [UIColor cyanColor];
        [self setupConstrainsts];
    }
    return self;
}



- (void)setupConstrainsts
{
    
    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView).offset(-100);
        make.centerX.mas_equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(trackW, trackH));
    }];

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.trackView);
        make.size.mas_equalTo(CGSizeMake(progressW, progressH));
        make.left.equalTo(self.trackView);
    }];
    [self.downingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.trackView.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.trackView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.trackView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.trackView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}
- (void)beginAnimation
{
    progressW = 10;
    self.downingView.image = [UIImage imageNamed:@"rocket"];
    [self setupConstrainsts];
}


- (void)updateProgressViewConstraints
{
    if (progressW == 10)
    {
        progressW += arc4random()%5;
            [UIView animateWithDuration:1.5 // 动画时长
                                  delay:0.0 // 动画延迟
                 usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1
                  initialSpringVelocity:1 // 初始速度
                                options:0 // 动画过渡效果
                             animations:^{
                                 // code...
                                 self.downingView.frame = CGRectMake(CGRectGetWidth(self.bgView.frame)/2-32/2,(trackW - progressW), 32, 32);
                                 self.downingView.alpha = 0.1;
//                                 [self.downingView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                     make.bottom.mas_equalTo(self.trackView.mas_top).offset(-(trackW - progressW));
//                                 }];
                             } completion:^(BOOL finished) {
                                 // 动画完成后执行
                                 // code...
                                 //动画执行完毕后的首位操作
                                 [self.downingView mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.bottom.mas_equalTo(self.trackView.mas_top).offset(-(trackW - progressW));
                                 }];
                                 self.downingView.alpha = 1.0;
                                 self.downingView.image = [UIImage imageNamed:@"loading"];
                                 [self layerTransformRotationZ];
                             }];

        
    }else
    {
        progressW += arc4random()%5;
        if (progressW  > trackW)
        {
            [self removeDowningViewAnimation];
            
            [UIView animateWithDuration:2 animations:^{
                self.downingView.image = [UIImage imageNamed:@"finish"];
                self.trackView.hidden = YES;
                self.progressView.hidden = YES;
                self.desLab.hidden = YES;
                [self.downingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.bgView);
                    make.size.mas_equalTo(CGSizeMake(32, 32));
                }];
            }completion:^(BOOL finished) {
                
            }];
        }else
        {
            [self.downingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.trackView.mas_top).offset(-(trackW - progressW));
            }];
            self.desLab.text = [NSString stringWithFormat:@"%.0f%%",progressW/trackW*100];
            [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(progressW, progressH));
            }];
            
        }
        
    }
    
    
}

- (void)layerTransformRotationZ
{
    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    momAnimation.fromValue = [NSNumber numberWithFloat:-0.3];
    momAnimation.toValue = [NSNumber numberWithFloat:0.3];
    momAnimation.duration = 0.5;
    momAnimation.repeatCount = CGFLOAT_MAX;
    momAnimation.autoreverses = YES;
    momAnimation.delegate = self;
    [self.downingView.layer addAnimation:momAnimation forKey:@"animateLayerZ"];
}

- (void)layerTransformRotationY
{
    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    momAnimation.fromValue = [NSNumber numberWithFloat:-0.3];
    momAnimation.toValue = [NSNumber numberWithFloat:0.3];
    momAnimation.duration = 0.5;
    momAnimation.repeatCount = CGFLOAT_MAX;
    momAnimation.autoreverses = YES;
    momAnimation.delegate = self;
    [self.downingView.layer addAnimation:momAnimation forKey:@"animateLayerY"];
}
- (void)updateLayerTransformRotationYWithFromValue:(NSInteger)fromValue toValue:(NSInteger)toValue
{
//   CABasicAnimation *momAnimation = (CABasicAnimation*)[self.downingView.layer animationForKey:@"animateLayerY"];
//    momAnimation.fromValue = [NSNumber numberWithInteger:fromValue];
//    momAnimation.toValue = [NSNumber numberWithInteger:toValue];
    
}
- (void)removeDowningViewAnimation
{
    [self.downingView.layer removeAllAnimations];
}

@end
