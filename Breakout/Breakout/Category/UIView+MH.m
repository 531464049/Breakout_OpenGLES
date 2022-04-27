//
//  UIView+MH.m
//  LS
//
//  Created by mahao on 2020/1/3.
//  Copyright © 2020 Xrobot. All rights reserved.
//

#import "UIView+MH.h"

#define IPHONE_H [UIScreen mainScreen].bounds.size.height //屏幕的高度
#define IPHONE_W [UIScreen mainScreen].bounds.size.width // 屏幕的宽度

@implementation UIView (MH)

-(void)mh_alertShowAnimation
{
    CAAnimationGroup * group = [CAAnimationGroup animation];
    
    CABasicAnimation * ani1 = [CABasicAnimation animationWithKeyPath:@"uiFractionalProgress"];
    ani1.removedOnCompletion = 0;
    ani1.fillMode = kCAFillModeBoth;
    ani1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani1.duration = 0.404;
    ani1.toValue = @(100);
    ani1.fromValue = @(0.0);
    
    CASpringAnimation * ani2 = [CASpringAnimation animationWithKeyPath:@"transform"];
    ani2.removedOnCompletion = 0;
    ani2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0f)];
    ani2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0f)];
    ani2.additive = 1;
    ani2.fillMode = kCAFillModeBoth;
    ani2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    ani2.duration = 0.404;
    ani2.initialVelocity = 0.0;
    ani2.damping = 45.71;
    ani2.stiffness = 522.35;
    ani2.mass = 1.0;
    
    CAKeyframeAnimation * ani22 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    ani22.values =   @[@0.0,@1.2,@1.0];
    ani22.keyTimes = @[@0.0,@0.75,@1.0];
    ani22.duration = 0.404;
    ani22.removedOnCompletion = 0;
    
    CASpringAnimation * ani3 = [CASpringAnimation animationWithKeyPath:@"opacity"];
    ani3.removedOnCompletion = 0;
    ani3.fromValue = @(0.0);
    ani3.toValue = @(1.0);
    ani3.fillMode = kCAFillModeBoth;
    ani3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    ani3.duration = 0.404;
    ani3.initialVelocity = 0.0;
    ani3.damping = 45.71;
    ani3.stiffness = 522.35;
    ani3.mass = 1.0;
    
    group.animations = @[ani1,ani22,ani3];
    [self.layer addAnimation:group forKey:nil];
}
-(void)setGradientColors:(NSArray<UIColor *> *)colors startPoint:(CGPoint)start end:(CGPoint)end
{
    if (!colors || colors.count == 0) {
        return;
    }
    if (colors.count == 1) {
        self.backgroundColor = (UIColor *)colors[0];
    }
    NSMutableArray * cols = [NSMutableArray array];
    for (int i = 0; i < colors.count; i ++) {
        UIColor * color = (UIColor *)colors[i];
        [cols addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = cols;
    gradientLayer.startPoint = start;
    gradientLayer.endPoint = end;
    gradientLayer.locations = @[@0,@1];
    [self.layer addSublayer:gradientLayer];
}
-(BOOL)isDisplayedInScreen
{
    if (!self) {
        return NO;
    }
    // 若view 隐藏
    if (self.hidden) {
        return NO;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return NO;
    }
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    return YES;
}
@end



@implementation UIScrollView (MH)
+ (void)load {
    if (@available(iOS 11.0, *)){
        //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
//        [[self appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}
#pragma mark - iOS 11 开启/关闭contentInsetAdjustmentBehavior
+(void)mh_scrollOpenAdjustment:(BOOL)open
{
    if (@available(iOS 11.0, *)){
        if (open) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        } else {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}
-(void)mh_fixIphoneXBottomMargin
{
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    
    if (isPhoneX) {
        UIEdgeInsets insets = self.contentInset;
        self.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + 34.0, insets.right);
    }
}
//是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥.
//是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
    
}
//location_X可自己定义,其代表的是滑动返回距左边的有效长度
- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    //是滑动返回距左边的有效长度
    int location_X = 100;
    
    if (gestureRecognizer ==self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            
            //这是允许每张图片都可实现滑动返回
            int temp1 = location.x;
            int temp2 = IPHONE_W;
            NSInteger XX = temp1 % temp2;
            if (point.x >0 && XX < location_X) {
                return YES;
            }
            //下面的是只允许在第一张时滑动返回生效
            //            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
            //                return YES;
            //            }
        }
    }
    return NO;
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
    
}
//重写touchesBegin方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

//重写touchesEnded方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
//重写touchesMoved方法
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}
@end
