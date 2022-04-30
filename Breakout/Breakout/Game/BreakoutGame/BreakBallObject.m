//
//  BreakBallObject.m
//  Breakout
//
//  Created by mahao on 2022/4/30.
//

#import "BreakBallObject.h"

@implementation BreakBallObject

BreakBallObject * breakBallObject(GLKVector2 position, float radius, float speed, MHTexture2D * texture)
{
    //根据初始speed 计算x-y轴每帧移动距离
    //默认初始向右上方45°移动
    float x = speed * cos(K_RADIANS(45.0));
    float y = speed * sin(K_RADIANS(45.0));
    BreakBallObject * obj = [[BreakBallObject alloc] initWithSpeed:speed];
    obj.position = position;
    obj.size = GLKVector2Make(radius * 2, radius * 2);
    obj.color = GLKVector3Make(1.0, 1.0, 1.0);
    obj.texture = texture;
    obj.radius = radius;
    obj.velocity = GLKVector2Make(x, -y);
    return obj;
}
-(instancetype)initWithSpeed:(float)speed
{
    self = [super init];
    if (self) {
        _speed = speed;
    }
    return self;
}
-(void)reSetBall
{
    float x = self.speed * cos(K_RADIANS(45.0));
    float y = self.speed * sin(K_RADIANS(45.0));
    self.velocity = GLKVector2Make(x, -y);
}
-(GLKVector2)moveWithWindowWidth:(float)windowWidth
{
    //移动
    self.position = GLKVector2Add(self.position, self.velocity);
    //检查是否超过边界
    if (self.position.x <= self.radius) {
        self.position = GLKVector2Make(self.radius, self.position.y);
        self.velocity = GLKVector2Make(-self.velocity.x, self.velocity.y);
    }else if (self.position.x + self.radius >= windowWidth) {
        self.position = GLKVector2Make(windowWidth - self.radius, self.position.y);
        self.velocity = GLKVector2Make(-self.velocity.x, self.velocity.y);
    }
    if (self.position.y <= self.radius) {
        self.position = GLKVector2Make(self.position.x, self.radius);
        self.velocity = GLKVector2Make(self.velocity.x, -self.velocity.y);
    }
    return self.velocity;
}

-(void)reSet:(GLKVector2)position velocity:(GLKVector2)velocity
{
    
}

@end
