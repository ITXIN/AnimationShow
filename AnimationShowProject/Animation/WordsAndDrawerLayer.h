//
//  WordsAndDrawerLayer.h
//  AnimationShowProject
//
//  Created by Bert on 16/7/20.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface WordsAndDrawerLayer : CALayer
+(void)createAnimationLayerWithWordsStr:(NSString*)wordsStr rect:(CGRect)rect view:(UIView *)view font:(UIFont*)font strokeColor:(UIColor*)strokeColor;
@end
