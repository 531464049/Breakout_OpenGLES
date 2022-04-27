//
//  NSObject+MH.h
//  LSB3B4
//
//  Created by mahao on 2020/3/24.
//  Copyright © 2020 SliverStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MH)

/// 获取两点直线之间插值点
/// @param start 开始点
/// @param end 结束点
+(NSArray *)getLineInterpolation:(CGPoint)start end:(CGPoint)end;

/// 计算线段A-B水平弧度
/// @param p1 p1
/// @param p2 p2
CGFloat lineHorizontalRadian(CGPoint p1, CGPoint p2);

/// 计算三点之间弧度
/// @param p1 p1
/// @param p2 p2
/// @param p3 p3
CGFloat angleBetweenThreePoint(CGPoint p1, CGPoint p2, CGPoint p3);

/// 判断两多边形是否相切
/// @param pointsA 多边形A顶点数组
/// @param pointsB 多边形B顶戴你数组
BOOL tangentBetweenPoints(NSArray * pointsA, NSArray * pointsB);

/// 计算两条直线交点--当返回(-1,-1)说明无交点
/// @param p1 point1-lin1 start
/// @param p2 point2-lin1 end
/// @param p3 point3-lin2 start
/// @param p4 point4-lin2 end
CGPoint getCross(CGPoint p1, CGPoint p2, CGPoint p3, CGPoint p4);

/// 计算两条线段之间的弧度
/// @param line1Start 线段1起点
/// @param line1End 线段1终点
/// @param line2Start 线段2起点
/// @param line2End 线段2终点
+(CGFloat)angleBetweenLine1Start:(CGPoint)line1Start lin1End:(CGPoint)line1End line2Start:(CGPoint)line2Start line2End:(CGPoint)line2End;

/// 判断点是否在多边形内
/// @param zonePoints 多边形顶点数组
/// @param point 要判断的点
+(BOOL)zonePoints:(NSArray *)zonePoints contain:(CGPoint)point;

/// 当前时间戳-秒
+(NSInteger)getCurentTimeStampSec;
/// 当前时间戳-毫秒
+(NSInteger)getCurentTimeStamp;

/// 秒数（28800）转换为时间字符串 08:00
/// @param seconds 秒
+(NSString *)timeStrFromSeconds:(NSInteger)seconds;

@end


@interface NSDictionary (MH)

-(NSString *)dicToJson;

-(BOOL)containsKey:(NSString *)key;

@end

@interface NSMutableDictionary (MH)

@end

@interface UIColor (MH)

+ (UIColor *)randomColor;

@end

@interface NSData (YX)

-(NSData *)yx_subdataWithRange:(NSRange)range;

-(void)yx_getBytes:(void *)buffer range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
