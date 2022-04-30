//
//  BreakGameConfig.h
//  Breakout
//
//  Created by mahao on 2022/4/30.
//

#ifndef BreakGameConfig_h
#define BreakGameConfig_h

#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

//game state
typedef NS_ENUM(int, GameState) {
    GameState_Initial = 0,       //初始状态
    GameState_Runing = 1,       //
    GameState_Paused = 2,       //
    GameState_Fail = 3,       //
};

//底部挡板移动方向
typedef NS_ENUM(int, UserTouchDirection) {
    UserTouchDirectionNone = 0,       //无方向--静止
    UserTouchDirectionLeft = 1,       //左
    UserTouchDirectionRight = 2,       //右
};

//碰撞检测方向
typedef NS_ENUM(int, CollisionsDirection) {
    UP,
    RIGHT,
    DOWN,
    LEFT
};

/// 碰撞检测结果
struct CollisionResult {
    BOOL collisioned;//是否碰撞
    CollisionsDirection direction;//碰撞方向
    GLKVector2 difference;//差矢量
};

static const float Player_Size_Width = 100.f;//挡板宽度
static const float Player_Size_Height = 20.f;//挡板高度
static const float Player_Spead = 8.f;//挡板每帧移动速度
static const float Ball_Radius = 10.0;//球半径

#endif /* BreakGameConfig_h */
