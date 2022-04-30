//
//  BreakCollision.m
//  Breakout
//
//  Created by mahao on 2022/4/30.
//

#import "BreakCollision.h"

@implementation BreakCollision

struct CollisionResult cheekCollision(BreakBallObject * ball, BreakoutObject * obj)
{
    /**
     这里的碰撞检测来自 AABB - 圆碰撞检测
     https://learnopengl-cn.github.io/06%20In%20Practice/2D-Game/05%20Collisions/02%20Collision%20detection/
     需要大佬指导
     */
    //球中心点
    GLKVector2 ballCenter = ball.position;
    //计算AABB中心和半边长
    GLKVector2 aabb_half_extents = GLKVector2Make(obj.size.x/2, obj.size.y/2);
    GLKVector2 aabb_center = obj.position;
    //获取两个中心的差矢量
    GLKVector2 difference = GLKVector2Subtract(ballCenter, aabb_center);
    float clampedX = clamp(difference.x, -aabb_half_extents.x, aabb_half_extents.x);
    float clampedY = clamp(difference.y, -aabb_half_extents.y, aabb_half_extents.y);
    GLKVector2 clamped = GLKVector2Make(clampedX, clampedY);
    // AABB_center加上clamped这样就得到了碰撞箱上距离圆最近的点closest
    GLKVector2 closest = GLKVector2Add(aabb_center, clamped);
    // 获得圆心center和最近点closest的矢量并判断是否 length <= radius
    difference = GLKVector2Subtract(closest, ballCenter);
    float length = GLKVector2Length(difference);
    
    if (length <= ball.radius) {
        CollisionsDirection direction = vectorDirection(difference);
        struct CollisionResult result = {YES, direction, difference};
        return result;
    }else{
        struct CollisionResult result = {NO, UP, difference};
        return result;
    }
}
float clamp(float value, float min, float max)
{
    return MAX(min, MIN(max, value));
}

CollisionsDirection vectorDirection(GLKVector2 target)
{
    GLKVector2 compass[] = {
        GLKVector2Make(0.0f, 1.0f),  // 上
        GLKVector2Make(1.0f, 0.0f),  // 右
        GLKVector2Make(0.0f, -1.0f), // 下
        GLKVector2Make(-1.0f, 0.0f)  // 左
    };
    float max = 0.f;
    int best_match = -1;
    for (int i = 0; i < 4; i ++) {
        float dot_product = GLKVector2DotProduct(GLKVector2Normalize(target), compass[i]);
        if (dot_product > max) {
            max = dot_product;
            best_match = i;
        }
    }
    return (CollisionsDirection)best_match;
}


void cheekBall_player_collision(BreakBallObject * ball, BreakoutObject * player)
{
    struct CollisionResult collisionResult = cheekCollision(ball, player);
    if (!collisionResult.collisioned) {
        return;
    }
    //球和挡板之间的碰撞：基于撞击挡板的点与（挡板）中心的距离来改变球的水平速度。撞击点距离挡板的中心点越远，则水平方向的速度就会越大。
    // 检查碰到了挡板的哪个位置，并根据碰到哪个位置来改变速度
    float centerBoard = player.position.x;
    float distance = ball.position.x - centerBoard;
    float percentage = fabs(distance / (player.size.x / 2));

    float angle = 75.0 - percentage * 60.0;
    float x = ball.speed * cos(K_RADIANS(angle));
    float y = ball.speed * sin(K_RADIANS(angle));
    if (ball.velocity.x < 0) {
        x = -x;
    }
    ball.velocity = GLKVector2Make(x, -y);
}

@end
