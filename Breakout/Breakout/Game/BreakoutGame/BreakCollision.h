//
//  BreakCollision.h
//  Breakout
//
//  Created by mahao on 2022/4/30.
//

#import <Foundation/Foundation.h>
#import "BreakGameConfig.h"
#import "BreakoutLevel.h"
#import "BreakBallObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BreakCollision : NSObject

/// 碰撞检测--球与立方体obj
/// @param ball 球
/// @param obj 待碰撞obj
struct CollisionResult cheekCollision(BreakBallObject * ball, BreakoutObject * obj);

/// 碰撞检测--球与底部挡板
/// @param ball ball
/// @param player player
void cheekBall_player_collision(BreakBallObject * ball, BreakoutObject * player);

@end

NS_ASSUME_NONNULL_END
