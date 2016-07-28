//
//  LoadingAnimationView.h
//  LoadingAnimation
//
//  Created by Bert on 16/7/19.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressAnimationView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *trackView;
@property (nonatomic,strong) UIImageView *progressView;
@property (nonatomic,strong) UILabel *desLab;

@property (nonatomic,strong) UIImageView *downingView;

- (void)updateProgressViewConstraints;
- (void)beginAnimation;
@end
