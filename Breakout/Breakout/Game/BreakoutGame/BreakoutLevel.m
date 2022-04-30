//
//  BreakoutLavel.m
//  Breakout
//
//  Created by mahao on 2022/4/29.
//

#import "BreakoutLevel.h"

@interface BreakoutLevel ()
{
    float _gameViewWidth;
    float _gameViewHight;
}
@end

@implementation BreakoutLevel
-(instancetype)initLevle:(int)lavel gameViewWidth:(float)gameViewWidth gameViewHight:(float)gameViewHight
{
    self = [super init];
    if (self) {
        _level = lavel;
        _gameViewWidth = gameViewWidth;
        _gameViewHight = gameViewHight;
        [self loadLevel];
    }
    return self;
}
-(void)loadLevel
{
    //数字-1：无砖块，表示关卡中空的区域
    //数字0：一个坚硬的砖块，不可被摧毁
    //大于0的数字：一个可被摧毁的砖块，不同的数字代表需要碰撞多少次能摧毁
    //每行从15开始--最大可升级到30
    //列数从5开始--最大到15
    int rows = 15;
    int cols = 5;
    float unit_width = _gameViewWidth / rows;
    float unit_height = unit_width;
    if (unit_height * cols > _gameViewHight - 100) {
        unit_height = (_gameViewHight - 100) / cols;
    }
    NSMutableArray * results = [NSMutableArray array];
    GLKVector2 size = GLKVector2Make(unit_width, unit_height);
    for (int i = 0; i < cols; i ++) {
        for (int j = 0; j < rows; j ++) {
            GLKVector2 position = GLKVector2Make(0.0, 0.0);
            position.x = j * unit_width + unit_width/2;;
            position.y = i * unit_height + unit_height/2;
            if (i == 0) {
                //第一行默认全坚固砖块
                BreakoutObject * obj = breakoutObject(position,
                                                      size,
                                                      GLKVector3Make(1.0, 1.0, 1.0),
                                                      getTexture(@"block_solid"));
                obj.isSolid = YES;
                [results addObject:obj];
            }else{
                int s = arc4random() % 6;
                if (s == 0) {
                    continue;
                }

                GLKVector3 color = GLKVector3Make(1.0, 1.0, 1.0);
                if (s == 2) {
                    color = GLKVector3Make(0.2f, 0.6f, 1.0f);
                }else if (s == 3) {
                    color = GLKVector3Make(0.0f, 0.7f, 0.0f);
                }else if (s == 4) {
                    color = GLKVector3Make(0.8f, 0.8f, 0.4f);
                }else if (s == 5) {
                    color = GLKVector3Make(1.0f, 0.5f, 0.0f);
                }

                BreakoutObject * obj = [[BreakoutObject alloc] init];
                obj.position = position;
                obj.size = size;
                obj.color = color;
                obj.isSolid = s == 1;
                obj.destroyed = NO;
                obj.texture = s == 1 ? getTexture(@"block_solid") : getTexture(@"block");
                [results addObject:obj];
            }
        }
    }
    self.objs = [results copy];
}
-(void)draw:(SpriteRender *)render
{
    for (BreakoutObject * obj in self.objs) {
        if (obj.destroyed == YES) {
            continue;
        }
        [obj draw:render];
    }
}
#pragma mark - 重置关卡
-(void)reSetLevel
{
    for (BreakoutObject * obj in self.objs) {
        obj.destroyed = NO;
    }
}
#pragma mark - 碰撞检测
-(void)doCollisions:(BreakBallObject *)ball
{
    for (BreakoutObject * obj in self.objs) {
        if (obj.destroyed == YES) {
            //销毁的球跳过
            continue;
        }
        struct CollisionResult collisionResult = cheekCollision(ball, obj);
        if (collisionResult.collisioned) {
            //产生碰撞
            // 如果砖块不是实心就销毁砖块
            if (!obj.isSolid) {
                obj.destroyed = YES;
            }
            //碰撞处理
            CollisionsDirection direction = collisionResult.direction;
            GLKVector2 diff_vector = collisionResult.difference;
            if (direction == LEFT || direction == RIGHT) {
                //水平方向碰撞
                ball.velocity = GLKVector2Make(-ball.velocity.x, ball.velocity.y);
                //重定位
                float penetration = ball.radius - fabsf(diff_vector.x);
                if (direction == LEFT) {
                    //左边碰撞--右移
                    ball.position = GLKVector2Make(ball.position.x + penetration, ball.position.y);
                }else{
                    //右边碰撞--左移
                    ball.position = GLKVector2Make(ball.position.x - penetration, ball.position.y);
                }
            }else{
                //垂直方向碰撞
                ball.velocity = GLKVector2Make(ball.velocity.x, -ball.velocity.y);
                //重定位
                float penetration = ball.radius - fabsf(diff_vector.y);
                if (direction == UP) {
                    //上边碰撞--上移
                    ball.position = GLKVector2Make(ball.position.x, ball.position.y - penetration);
                }else{
                    //下边碰撞--下移
                    ball.position = GLKVector2Make(ball.position.x, ball.position.y + penetration);
                }
            }
            //当检测到球与砖块碰撞后，结束该次检测
            break;
        }
    }
}

@end
