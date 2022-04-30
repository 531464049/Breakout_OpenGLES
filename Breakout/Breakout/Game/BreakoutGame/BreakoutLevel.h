//
//  BreakoutLavel.h
//  Breakout
//
//  Created by mahao on 2022/4/29.
//

#import <Foundation/Foundation.h>
#import "BreakGameConfig.h"
#import "BreakCollision.h"
#import "BreakoutObject.h"
#import "BreakBallObject.h"
#import "GameSource.h"
#import "SpriteRender.h"

NS_ASSUME_NONNULL_BEGIN

@interface BreakoutLevel : NSObject

/// 当前关卡
@property(nonatomic,assign,readonly)int level;
/// 当前关卡是否完成
@property(nonatomic,assign,readonly)BOOL isCompleted;
/// 当前关卡方块数组
@property(nonatomic,copy)NSArray<BreakoutObject *> * objs;

/// 关卡绘制
/// @param render 绘制render
-(void)draw:(SpriteRender *)render;

/// 关卡重置
-(void)reSetLevel;

/// 关卡元素与球的碰撞检测
/// @param ball ball
-(void)doCollisions:(BreakBallObject *)ball;

/// 初始化关卡
/// @param lavel 关卡
/// @param gameViewWidth 游戏显示宽度
/// @param gameViewHight 游戏显示高度-计算方块单元size
-(instancetype)initLevle:(int)lavel gameViewWidth:(float)gameViewWidth gameViewHight:(float)gameViewHight;

@end

NS_ASSUME_NONNULL_END
