//
//  UIColor+MyColor.h
//  LoadingAnimation
//
//  Created by Bert on 16/7/19.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import <UIKit/UIKit.h>
// 颜色的宏定义方式
#undef	RGB
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	RGBA
#define RGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#undef	HEX_RGB
#define HEX_RGB(V)		[UIColor fromHexValue:V]

#undef	HEX_RGBA
#define HEX_RGBA(V, A)	[UIColor fromHexValue:V alpha:A]

#undef	SHORT_RGB
#define SHORT_RGB(V)	[UIColor fromShortHexValue:V]

#undef	HEX_ARGB
#define HEX_ARGB(V) 	[UIColor colorWithHexString:V]

#undef  RANDOM_COLOR
#define RANDOM_COLOR    [UIColor randomColor]
@interface UIColor (MyColor)
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)fromHexValue:(NSUInteger)hex;
+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)fromShortHexValue:(NSUInteger)hex;
+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithString:(NSString *)string;  // {#FFF|#FFFFFF|#FFFFFFFF}{,0.6}

+ (UIColor *)randomColor;
@end
