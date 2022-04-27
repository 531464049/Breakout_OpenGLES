//
//  NSString+MH.h
//  LS
//
//  Created by mahao on 2020/1/7.
//  Copyright © 2020 Xrobot. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MH)

/**
 根据字符串宽度及字体计算高度
 @param width 宽度
 @param textFont 字体
 @return height
 */
-(CGFloat)textForLabHeightWithTextWidth:(CGFloat)width font:(UIFont *)textFont;

/**
 根据字符串高度及字体计算宽度
 @param height 高度
 @param textFont 字体
 @return width
 */
-(CGFloat)textForLabWidthWithTextHeight:(CGFloat)height font:(UIFont *)textFont;

/**
 根据字体大小 宽度 字间距 行间距 计算文字所占高度
 @param textFont 字体
 @param width 宽度
 @param lineSpace 行间距
 @param keming 字间距
 @return 高度
 */
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming;
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent;

/**
 将字符串转化为带行间距字间距的attbutedStr
 @param textFont 字体
 @param textColor 字体颜色
 @param lineSpace 行间距
 @param keming 字间距
 @return attbutedStr
 */
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming;
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent;


/// 16进制转普通字符串
-(NSString *)hexStringToString;

/// 普通字符串转16进制字符串
-(NSString *)hexString;
/// json字符串转字典
-(NSDictionary *)jsonToDic;

@end

NS_ASSUME_NONNULL_END
