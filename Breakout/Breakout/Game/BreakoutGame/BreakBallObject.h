//
//  BreakBallObject.h
//  Breakout
//
//  Created by mahao on 2022/4/30.
//

#import "BreakoutObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BreakBallObject : BreakoutObject

/// 球的移动速度-每帧移动距离
@property(nonatomic,assign,readonly)float speed;
/// 球每帧x轴y轴移动距离
@property(nonatomic,assign)GLKVector2 velocity;
/// 球的半径
@property(nonatomic,assign)float radius;

-(void)reSetBall;

-(GLKVector2)moveWithWindowWidth:(float)windowWidth;

-(void)reSet:(GLKVector2)position velocity:(GLKVector2)velocity;

BreakBallObject * breakBallObject(GLKVector2 position, float radius, float speed, MHTexture2D * texture);

@end

NS_ASSUME_NONNULL_END
