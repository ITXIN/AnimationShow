//
//  WordsAndDrawerLayer.m
//  AnimationShowProject
//
//  Created by Bert on 16/7/20.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "WordsAndDrawerLayer.h"
@interface WordsAndDrawerLayer()
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@property (nonatomic, retain) CAShapeLayer *heartpPathLayer;
@property (nonatomic, retain) CALayer *penLayer;
@end

@implementation WordsAndDrawerLayer

+(void)createAnimationLayerWithWordsStr:(NSString*)wordsStr rect:(CGRect)rect view:(UIView *)view font:(UIFont*)font strokeColor:(UIColor*)strokeColor
{
    
    WordsAndDrawerLayer *animationLayer = [WordsAndDrawerLayer layer];
    animationLayer.frame = rect;
    [view.layer addSublayer:animationLayer];
    
    if (animationLayer.pathLayer != nil)
    {
        [animationLayer.penLayer removeFromSuperlayer];
        [animationLayer.pathLayer removeFromSuperlayer];
        [animationLayer.heartpPathLayer removeFromSuperlayer];
        animationLayer.penLayer = nil;
        animationLayer.pathLayer = nil;
        animationLayer.heartpPathLayer = nil;
        
    }
    
    CTFontRef wordsFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    CGMutablePathRef letters = CGPathCreateMutable();
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)wordsFont,kCTFontAttributeName, nil];
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:wordsStr attributes:attrs];
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attStr);
    CFArrayRef runArr = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArr);runIndex ++)
    {
        
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArr, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex ++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph ;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y
                                                                       );
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
        
        
    }
    
    CFRelease(line);
    
    
    
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(wordsFont);
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height - 230);
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [strokeColor CGColor];
//    pathLayer.fillColor = [UIColor whiteColor].CGColor;//填充字体颜色,如果设置了就会提前出现
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    [animationLayer addSublayer:pathLayer];
    animationLayer.pathLayer = pathLayer;
    
    UIImage *penImage = [UIImage imageNamed:@"pen"];
    CALayer *penLayer = [CALayer layer];
    penLayer.contents = (id)penImage.CGImage;
    penLayer.anchorPoint = CGPointZero;
    penLayer.frame = CGRectMake(0, 0, penImage.size.width, penImage.size.height);
    [pathLayer addSublayer:penLayer];
    animationLayer.penLayer = penLayer;
    
    [animationLayer.pathLayer removeAllAnimations];
    [animationLayer.penLayer removeAllAnimations];
    
    animationLayer.penLayer.hidden = NO;
    
    CGFloat spaceWidth = 20;
    CGFloat radius = MIN((CGRectGetWidth(rect) - spaceWidth*2)/4, (CGRectGetHeight(rect) - spaceWidth*2)/4);
    
    CGFloat heartLineW = 5.0;
    CGColorRef heartColor = HEX_ARGB(@"#e11cda").CGColor;//心的颜色

    //左侧圆心 位于左侧边距＋半径宽度
    CGPoint leftCenter = CGPointMake(spaceWidth+radius, radius/2);
    //右侧圆心 位于左侧圆心的右侧 距离为两倍半径
    CGPoint rightCenter = CGPointMake(spaceWidth+radius*3, radius/2);
    
    //左侧半圆
    UIBezierPath *heartLine = [UIBezierPath bezierPath];
    //[heartLine moveToPoint:CGPointMake(spaceWidth + 2*radius, spaceWidth+radius)];
    [heartLine addArcWithCenter:leftCenter radius:radius startAngle:0 endAngle:M_PI clockwise:NO];
    //曲线连接到新的底部顶点 为了弧线的效果，控制点，坐标x为总宽度减spaceWidth，刚好可以相切，平滑过度 y可以根据需要进行调整，y越大，所画出来的线越接近内切圆弧
    [heartLine addQuadCurveToPoint:CGPointMake((rect.size.width/2), rect.size.height-spaceWidth*6) controlPoint:CGPointMake(spaceWidth, rect.size.height*0.3)];
    
    CAShapeLayer *heartpathLayer = [CAShapeLayer layer];
    heartpathLayer.path = heartLine.CGPath;
    heartpathLayer.strokeColor = heartColor;//心的颜色
    heartpathLayer.fillColor = nil;//必须设置 nil
    heartpathLayer.lineWidth = heartLineW;
    heartpathLayer.lineJoin = kCALineJoinRound;
    [animationLayer addSublayer:heartpathLayer];
    
    CABasicAnimation *heartPathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    heartPathAnimation.duration = 5.0;
    heartPathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    heartPathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [heartpathLayer addAnimation:heartPathAnimation forKey:@"strokeEnd"];
    
    //右侧半圆
    UIBezierPath *heartRightLine = [UIBezierPath bezierPath];
    [heartRightLine addArcWithCenter:rightCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    [heartRightLine addQuadCurveToPoint:CGPointMake((rect.size.width/2), rect.size.height-spaceWidth*6) controlPoint:CGPointMake(rect.size.width - spaceWidth, rect.size.height*0.3)];
    
    CAShapeLayer *heartRightLayer = [CAShapeLayer layer];
    heartRightLayer.path = heartRightLine.CGPath;
    heartRightLayer.strokeColor = heartColor;
    heartRightLayer.fillColor = nil;
    heartRightLayer.lineWidth = heartLineW;
    heartRightLayer.lineJoin = kCALineJoinRound;
    [animationLayer addSublayer:heartRightLayer];
    
    CABasicAnimation *heartRigthAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    heartRigthAnimation.duration = 5.0;
    heartRigthAnimation.fromValue = @(0);
    heartRigthAnimation.toValue = @(1.0);
    [heartRightLayer addAnimation:heartRigthAnimation forKey:@"strokeEnd"];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [animationLayer.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = 5.0;
    penAnimation.path = animationLayer.pathLayer.path;
    penAnimation.calculationMode = kCAAnimationPaced;
    penAnimation.delegate = animationLayer;
    [animationLayer.penLayer addAnimation:penAnimation forKey:@"position"];
}

    
    

@end
