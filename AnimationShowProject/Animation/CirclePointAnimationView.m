//
//  CirclePointAnimationView.m
//  LoadingAnimation
//
//  Created by Bert on 16/7/19.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "CirclePointAnimationView.h"

@implementation CirclePointAnimationView
{
    CALayer *bigCircleLayer;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        
    }
    return self;
}

- (void)initRectLayer
{
    bigCircleLayer = [[CALayer alloc] init];
    bigCircleLayer.frame = CGRectMake(15, 200, 30, 30);
    bigCircleLayer.cornerRadius = 15;
    
    
    
    
    
    
    
    
    
}

@end
