//
//  UIView+MH.h
//  LS
//
//  Created by mahao on 2020/1/3.
//  Copyright © 2020 Xrobot. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MH)
/**
 模拟系统alert弹出动画
 */
-(void)mh_alertShowAnimation;


/// 设置渐变色 start/end设置为(0,0)(1,0)代表水平方向渐变,(0,0)(0,1)代表竖直方向
/// @param colors 渐变色数组
/// @param start 颜色渐变的起始位置:取值范围在(0,0)~(1,1)之间
/// @param end 颜色渐变的终点位置,取值范围也是在(0,0)~(1,1)之间
-(void)setGradientColors:(NSArray <UIColor *> *)colors startPoint:(CGPoint)start end:(CGPoint)end;


/// 判断view是否显示在屏幕上
-(BOOL)isDisplayedInScreen;

@end

@interface UIScrollView (MH)

/**
 iOS 11 开启/关闭contentInsetAdjustmentBehavior
 
 @param open 开启/关闭contentInsetAdjustmentBehavior
 */
+(void)mh_scrollOpenAdjustment:(BOOL)open;
-(void)mh_fixIphoneXBottomMargin;

@end

NS_ASSUME_NONNULL_END
