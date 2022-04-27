//
//  NSObject+MH.m
//  LSB3B4
//
//  Created by mahao on 2020/3/24.
//  Copyright © 2020 SliverStar. All rights reserved.
//

#import "NSObject+MH.h"
#import <objc/runtime.h>

@implementation NSObject (MH)

#pragma mark - 两点之间插值
+(NSArray *)getLineInterpolation:(CGPoint)start end:(CGPoint)end
{
    NSMutableArray * result = [NSMutableArray array];
    [result addObject:[NSValue valueWithCGPoint:start]];
    CGFloat distance = floor(sqrt(pow((start.x - end.x), 2) + pow((start.y - end.y), 2)));
    if (distance > 1) {
        CGFloat step = 1 / distance;
        CGFloat startRatio = 0.0;
        CGPoint prePosition = start;
        for (int j = 0; j < distance; j++)
        {
            startRatio += step;
            CGPoint r = CGPointZero;
            r.x = start.x + (end.x - start.x) * startRatio;
            r.y = start.y + (end.y - start.y) * startRatio;
            if (!CGPointEqualToPoint(r, prePosition)) {
                [result addObject:[NSValue valueWithCGPoint:r]];
                prePosition = r;
            }
        }
    }
    [result addObject:[NSValue valueWithCGPoint:end]];
    return result;
}

#pragma mark - 计算线段A-B水平角度
CGFloat lineHorizontalRadian(CGPoint p1, CGPoint p2)
{
    CGPoint p3 = CGPointMake(p1.x + 20, p1.y);
    CGFloat startRadian = atan2(p3.x - p1.x, p3.y - p1.y);
    CGFloat endAnRadian = atan2(p2.x - p1.x, p2.y - p1.y);
    CGFloat radian = startRadian - endAnRadian;
    return radian;
}

#pragma mark - 计算三点之间弧度
CGFloat angleBetweenThreePoint(CGPoint p1, CGPoint p2, CGPoint p3)
{
    double aa = pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2);
    double bb = pow(p3.x - p2.x, 2) + pow(p3.y - p2.y, 2);
    double cc = pow(p3.x - p1.x, 2) + pow(p3.y - p1.y, 2);
    double C = acos((aa + bb - cc) / (2 * sqrt(aa) * sqrt(bb)));
    return C;
}

#pragma mark - 判断两多边形是否相切
BOOL tangentBetweenPoints(NSArray * pointsA, NSArray * pointsB)
{
    //获取pointsA中最小外围矩形边界
    CGPoint firstPointA = [pointsA[0] CGPointValue];
    CGFloat pointsA_xMin = firstPointA.x;
    CGFloat pointsA_xMax = firstPointA.x;
    CGFloat pointsA_yMin = firstPointA.y;
    CGFloat pointsA_yMax = firstPointA.y;
    for (int i = 0; i < pointsA.count; i++) {
        CGPoint point = [pointsA[i] CGPointValue];
        CGFloat x = point.x;
        CGFloat y = point.y;
        if (x < pointsA_xMin) {
            pointsA_xMin = x;
        } else if (x > pointsA_xMax) {
            pointsA_xMax = x;
        }
        if (y < pointsA_yMin) {
            pointsA_yMin = y;
        } else if (y > pointsA_yMax) {
            pointsA_yMax = y;
        }
    }
    
    //获取pointsB中最小外围矩形边界
    CGPoint firstPointB = [pointsB[0] CGPointValue];
    CGFloat pointsB_xMin = firstPointB.x;
    CGFloat pointsB_xMax = firstPointB.x;
    CGFloat pointsB_yMin = firstPointB.y;
    CGFloat pointsB_yMax = firstPointB.y;
    for (int i = 0; i < pointsB.count; i++) {
        CGPoint point = [pointsB[i] CGPointValue];
        CGFloat x = point.x;
        CGFloat y = point.y;
        if (x < pointsB_xMin) {
            pointsB_xMin = x;
        } else if (x > pointsB_xMax) {
            pointsB_xMax = x;
        }
        if (y < pointsB_yMin) {
            pointsB_yMin = y;
        } else if (y > pointsB_yMax) {
            pointsB_yMax = y;
        }
    }
    
    NSLog(@"pointsA_xMin:%f pointsA_xMax:%f pointsA_yMin:%f pointsA_yMax:%f",pointsA_xMin,pointsA_xMax,pointsA_yMin,pointsA_yMax);
    NSLog(@"pointsB_xMin:%f pointsB_xMax:%f pointsB_yMin:%f pointsB_yMax:%f",pointsB_xMin,pointsB_xMax,pointsB_yMin,pointsB_yMax);
    
    //比较pointsA与pointsB最小外围矩形边界的位置关系，筛选出大部分不相邻的情况
    if (pointsA_xMax<pointsB_xMin || pointsA_xMin>pointsB_xMax || pointsA_yMax<pointsB_yMin || pointsA_yMin>pointsB_yMax) {
        return NO;
    }
    
    //判断pointA中的各点是否在pointB的边界线上(判断相邻的主要步骤)
    for (int i = 0; i < pointsA.count; i++) {
        CGPoint pointA = [pointsA[i] CGPointValue];
        CGFloat x = pointA.x;
        CGFloat y = pointA.y;
        for (int i = 0; i < pointsB.count; i++) {
            CGPoint bp1 = [pointsB[i] CGPointValue];
            CGPoint bp2 = [pointsB[(i+1)%pointsB.count] CGPointValue];
            //判断三点是否一线
            CGFloat dValue = (bp2.y-bp1.y)*(x-bp1.x)-(y-bp1.y)*(bp2.x-bp1.x);
            if (0 == dValue) {
                //判断pointA是否是在bp1与bp2这条边界上
                BOOL b1 = (x>bp1.x && x<bp2.x) || (x<bp1.x && x>bp2.x);
                if (b1) {
                    return YES;
                }
                
                //边界点不重合，用距离判断，取绝对值，小于1的，勉强通过
                CGFloat aa = (bp1.y-y)*(bp1.y-y)+(bp1.x-x)*(bp1.x-x);
                CGFloat bb = (bp2.y-y)*(bp2.y-y)+(bp2.x-x)*(bp2.x-x);
                if (aa<1 || bb<1) {
                    return YES;
                }
            }
        }
    }
    
    //判断pointB中的各点是否在pointA的边界线上(保险，一般用不上)
    for (int i = 0; i < pointsB.count; i++) {
        CGPoint pointB = [pointsB[i] CGPointValue];
        CGFloat x = pointB.x;
        CGFloat y = pointB.y;
        for (int i = 0; i < pointsA.count; i++) {
            CGPoint ap1 = [pointsA[i] CGPointValue];
            CGPoint ap2 = [pointsA[(i+1)%pointsA.count] CGPointValue];
            //判断三点是否一线
            CGFloat dValue = (ap2.y-ap1.y)*(x-ap1.x)-(y-ap1.y)*(ap2.x-ap1.x);
            if (0 == dValue) {
                //判断pointA是否是在bp1与bp2这条边界上
                BOOL b1 = (x>ap1.x && x<ap2.x) || (x<ap1.x && x>ap2.x);
                if (b1) {
                    return YES;
                }
                
                //边界点不重合，用距离判断，取绝对值，小于1的，勉强通过
                CGFloat aa = (ap1.y-y)*(ap1.y-y)+(ap1.x-x)*(ap1.x-x);
                CGFloat bb = (ap2.y-y)*(ap2.y-y)+(ap2.x-x)*(ap2.x-x);
                if (aa<1 || bb<1) {
                    return YES;
                }
            }
        }
    }
    
    //判断pointA中的各边是否与pointB的各边存在相交(保险，一般用不上)
    for (int i = 0; i < pointsA.count; i++) {
        CGPoint ap1 = [pointsA[i] CGPointValue];
        CGPoint ap2 = [pointsA[i%pointsA.count] CGPointValue];
        for (int i = 0; i < pointsB.count; i++) {
            CGPoint bp1 = [pointsB[i] CGPointValue];
            CGPoint bp2 = [pointsB[(i+1)%pointsB.count] CGPointValue];
            //判断ap1-ap2与bp1-bp2线段是否相交
            CGPoint crossPoint = getCross(ap1, ap2, bp1, bp2);
            if (crossPoint.x != -1) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - 计算两线段交点
CGPoint getCross(CGPoint p1, CGPoint p2, CGPoint p3, CGPoint p4)
{
    CGPoint pt = CGPointMake(-1, -1);

    //第一条直线
    double x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y;
    //第二条直线
    double x3 = p3.x, y3 = p3.y, x4 = p4.x, y4 = p4.y;
    //判断两条直线是否平行
    double parallelValue = (y1 - y2) * (x3 - x4) - (x1 - x2) * (y3 - y4);

    //直线平行直接返回
    if (0 == parallelValue) {
        return pt;
    }

    //两条直线的交点
    double x = (x1*(y2-y1)*(x4-x3)-x3*(x2-x1)*(y4-y3)+(y3-y1)*(x2-x1)*(x4-x3))/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1));
    double y = ((x1-x3)*(y2-y1)*(y4-y3)+y3*(y2-y1)*(x4-x3)-y1*(y4-y3)*(x2-x1))/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1));

    //判断交点是否是在第一条线段上
    BOOL b1 = (x>=x1 && x<=x2) || (x<=x1 && x>=x2);
    BOOL b2 = (y>=y1 && y<=y2) || (y<=y1 && y>=y2);
    //判断交点是否是在第二条线段上
    BOOL b3 = (x>=x3 && x<=x4) || (x<=x3 && x>=x4);
    BOOL b4 = (y>=y3 && y<=y4) || (y<=y3 && y>=y4);

    if (b1 && b2 && b3 && b4) {
        pt.x = x;
        pt.y = y;
    }

    return pt;
}
CGPoint getLinePara(CGPoint p1,CGPoint p2)
{
    CGFloat m = 0;
    m = p2.x - p1.x;
    CGPoint kp = CGPointZero;
    if (m == 0) {
        kp.x = 10000.0;
        kp.y = p1.y - kp.x * p1.x;
    } else {
        kp.x = (p2.y - p1.y) / (p2.x - p1.x);
        kp.y = p1.y - kp.x * p1.x;
    }

    return kp;
}
BOOL onSegement(CGPoint p1,CGPoint p2,CGPoint p)
{
    //画一个矩形 p1-p2可确定center 宽高
    CGFloat centerX = (p1.x + p2.x)/2;
    CGFloat centerY = (p1.y + p2.y)/2;
    CGFloat width = fabs(p1.x - p2.x);
    CGFloat height = fabs(p1.y - p2.y);
    
    BOOL contain = NO;
    int x = (int)p.x;
    int y = (int)p.y;
    int xmin = (int)(centerX-width/2);
    int xmax = (int)(centerX+width/2);
    int ymin = (int)(centerY-height/2);
    int ymax = (int)(centerY+height/2);
    if (x >= xmin && x <= xmax && y >= ymin && y <= ymax) {
        contain = YES;
    }
    return contain;
}

+(CGFloat)angleBetweenLine1Start:(CGPoint)line1Start lin1End:(CGPoint)line1End line2Start:(CGPoint)line2Start line2End:(CGPoint)line2End
{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    return rads;
}
#pragma mark - 判断点是否在多边形内
+(BOOL)zonePoints:(NSArray *)zonePoints contain:(CGPoint)point
{
    NSInteger nvert = zonePoints.count;
    CGFloat testx = point.x;
    CGFloat testy = point.y;
    NSMutableArray * vertx = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * verty = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < zonePoints.count; i ++) {
        CGPoint aPoint = [zonePoints[i] CGPointValue];
        [vertx addObject:@(aPoint.x)];
        [verty addObject:@(aPoint.y)];
    }
    BOOL c = NO;
    NSInteger i = 0;
    NSInteger j = 0;
    for (i = 0, j = nvert-1; i < nvert; j = i++) {
        
        if ((([verty[i] floatValue] > testy) != ([verty[j] floatValue] > testy)) &&
            (testx < ([vertx[j] floatValue] - [vertx[i] floatValue]) * (testy - [verty[i] floatValue]) / ([verty[j] floatValue] - [verty[i] floatValue]) + [vertx[i] floatValue])) {
            c = !c;
        }
    }
    return c;
}
+(NSInteger)getCurentTimeStampSec
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSInteger timesp = (long)([datenow timeIntervalSince1970]);
    return timesp;
}
+(NSInteger)getCurentTimeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSInteger timesp = (long)([datenow timeIntervalSince1970]*1000);
    return timesp;
}
+(NSString *)timeStrFromSeconds:(NSInteger)seconds
{
    NSInteger hour = seconds / 3600;
    NSInteger min = (seconds % 3600) / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)min];
}
@end


@implementation NSDictionary (MH)

-(BOOL)containsKey:(NSString *)key
{
    if (!key || ![key isKindOfClass:[NSString class]] || key.length == 0) {
        return NO;
    }
    return [self.allKeys containsObject:key];
}
-(NSString *)dicToJson
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end

@implementation NSMutableDictionary (MH)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(setObject:forKey:)withMethod:@selector(safe_setObject:forKey:)];
    });
}
- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    /** 得到类的实例方法 class_getInstanceMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name)
     _Nullable __unsafe_unretained cls  那个类
     _Nonnull name 按个方法
     
     补充: class_getClassMethod 得到类的 类方法
     */
    // 必须两个Method都要拿到
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);

    /** 动态添加方法 class_addMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name, IMP  _Nonnull imp, const char * _Nullable types)
        class_addMethod  是相对于实现来的说的，将本来不存在于被操作的Class里的newMethod的实现添加在被操作的Class里，并使用origSel作为其选择子
     _Nonnull name  原方法选择子，
     _Nonnull imp 新方法选择子，
     
     */
    // 如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
    BOOL didAddMethod = class_addMethod(class,origSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    // 如果返回成功:则说明被替换方法没有存在.也就是被替换的方法没有被实现,我们需要先把这个方法实现,然后再执行我们想要的效果,用我们自定义的方法去替换被替换的方法. 这里使用到的是class_replaceMethod这个方法. class_replaceMethod本身会尝试调用class_addMethod和method_setImplementation，所以直接调用class_replaceMethod就可以了)
    if (didAddMethod) {
        class_replaceMethod(class,newSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
        
    } else { // 如果返回失败:则说明被替换方法已经存在.直接将两个方法的实现交换即
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (void)safe_setObject:(id)value forKey:(NSString *)key {
    if (value) {
        [self safe_setObject:value forKey:key];
    }else {
        NSLog(@"[NSMutableDictionarysetObject: forKey:], Object cannot be nil");
    }
}
@end

@implementation UIColor (MH)

+ (UIColor *)randomColor{
    
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0f];
}

@end


@implementation NSData (YX)

-(NSData *)yx_subdataWithRange:(NSRange)range
{
    if (self.length < range.location + range.length) {
        return nil;
    }
    return [self subdataWithRange:range];
}
-(void)yx_getBytes:(void *)buffer range:(NSRange)range
{
    if (self.length < range.location + range.length) {
        return;
    }
    [self getBytes:buffer range:range];
}
@end
