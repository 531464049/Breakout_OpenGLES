//
//  MHGameView.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "MHGameView.h"
#import "BreakGameConfig.h"
#import "GameSource.h"
#import "SpriteRender.h"
#import "BreakoutLevel.h"
#import "BreakBallObject.h"





@interface MHGameView ()<GLKViewDelegate>
{
    CGPoint _userTouchLastP;//用户点击上一个坐标点
    UserTouchDirection _userDirection;
}
@property(nonatomic,strong)GLKView * glkView;
@property(nonatomic,strong)EAGLContext * context;
@property(nonatomic,strong)CADisplayLink * updateLink;

@property(nonatomic,assign)GameState gameState;
@property(nonatomic,strong)SpriteRender * spriteRender;
@property(nonatomic,strong)BreakoutLevel * breakoutLevel;
@property(nonatomic,strong)BreakoutObject * player;
@property(nonatomic,strong)BreakBallObject * ball;

@end

@implementation MHGameView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        self.context.multiThreaded = YES;
        if (!self.context) {
            NSLog(@"fail to create ES context");
        }
        self.glkView = [[GLKView alloc] initWithFrame:self.bounds context:self.context];
        self.glkView.backgroundColor = [UIColor clearColor];
        self.glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        self.glkView.drawableMultisample = GLKViewDrawableMultisample4X;
        self.glkView.delegate = self;
        [self addSubview:self.glkView];
        [EAGLContext setCurrentContext:self.context];
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glEnable(GL_CULL_FACE);
        
        [self initGame];
    }
    return self;
}
#pragma mark - 初始化游戏
-(void)initGame
{
    //加载着色器
    loadShder(@"sprite.vs", @"sprite.fs", @"sprite");
    //加载纹理贴图
    loadTexture(@"background.jpg", @"background");
    loadTexture(@"block.png", @"block");
    loadTexture(@"block_solid.png", @"block_solid");
    loadTexture(@"paddle.png", @"paddle");
    loadTexture(@"awesomeface.png", @"ball");
    
    //初始化render
    self.spriteRender = [[SpriteRender alloc] initWithShader:getShader(@"sprite")];
    //初始化关卡
    self.breakoutLevel = [[BreakoutLevel alloc] initLevle:1 gameViewWidth:self.frame.size.width gameViewHight:self.frame.size.height];
    //初始化player-->底部挡板
    GLKVector2 playerPosition = GLKVector2Make(self.bounds.size.width/2, self.bounds.size.height - Player_Size_Height/2);
    self.player = breakoutObject(playerPosition,
                                 GLKVector2Make(Player_Size_Width, Player_Size_Height),
                                 GLKVector3Make(1.0, 1.0, 1.0),
                                 getTexture(@"paddle"));
    //初始化 球
    GLKVector2 ballPosition = GLKVector2Make(playerPosition.x, playerPosition.y - Player_Size_Height/2 - Ball_Radius);
    self.ball = breakBallObject(ballPosition,
                                Ball_Radius,
                                6.0,
                                getTexture(@"ball"));
    
    _gameState = GameState_Initial;
    _userTouchLastP = CGPointZero;
    _userDirection = UserTouchDirectionNone;
    //绘制初始状态
    [self.glkView display];
    [self startUpdateLink];
}
#pragma mark - 游戏失败--重置
-(void)gameReset
{
    _gameState = GameState_Initial;
    _userTouchLastP = CGPointZero;
    _userDirection = UserTouchDirectionNone;
    //重置关卡
    [self.breakoutLevel reSetLevel];
    //重置球
    [self.ball reSetBall];
    //重置挡板位置--球位置
    self.player.position = GLKVector2Make(self.bounds.size.width/2, self.bounds.size.height - Player_Size_Height/2);
    self.ball.position = GLKVector2Make(self.player.position.x, self.player.position.y - Player_Size_Height/2 - Ball_Radius);
    //绘制初始状态
    [self.glkView display];
    [self startUpdateLink];
}
#pragma mark - 绘制
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0, 1.0, 1.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    MHShader * shader = getShader(@"sprite");
    GLKMatrix4 projection = GLKMatrix4MakeOrtho(0.0, self.frame.size.width, self.frame.size.height, 0.0, -1.0, 1.0);
    shaderSetMatrix4(shader, "projection", projection);
    //绘制背景
    drawSprite(self.spriteRender,
               getTexture(@"background"),
               GLKVector2Make(self.frame.size.width/2, self.frame.size.height/2),
               GLKVector2Make(self.bounds.size.width, self.bounds.size.height),
               0.0,
               GLKVector3Make(1.0, 1.0, 1.0));
    //绘制关卡砖块
    [self.breakoutLevel draw:self.spriteRender];
    //绘制底部挡板-player
    [self.player draw:self.spriteRender];
    //绘制球
    [self.ball draw:self.spriteRender];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}
#pragma mark - 更新游戏单元状态
-(void)displayRender
{
    if (self.gameState == GameState_Paused || self.gameState == GameState_Fail) {
        //暂停-失败   不更新位置
        return;
    }
    //更新挡板位置
    [self updatePlayerPosition];
    //根据游戏状态更新组件
    if (self.gameState == GameState_Initial) {
        //未开始状态--更新球位置在挡板上中心
        GLKVector2 ballPosition = GLKVector2Make(self.player.position.x, self.player.position.y - Player_Size_Height/2 - Ball_Radius);
        self.ball.position = ballPosition;
    }else if (self.gameState == GameState_Runing) {
        //进行中--更新球运动状态
        [self.ball moveWithWindowWidth:self.frame.size.width];
        //球与关卡元素的碰撞处理
        [self.breakoutLevel doCollisions:self.ball];
        //球与挡板的碰撞处理
        cheekBall_player_collision(self.ball, self.player);
        //检查是否失败
        if (self.ball.position.y >= self.frame.size.height) {
            //球进入底部边界--游戏失败--重置状态
            self.gameState = GameState_Fail;
            [self gameReset];
        }
    }
    
    [self.glkView display];
}
#pragma mark - 更新挡板位置
-(void)updatePlayerPosition
{
    //处理用户点击事件
    GLKVector2 userPosition = self.player.position;
    if (_userDirection == UserTouchDirectionLeft) {
        //左
        userPosition.x = userPosition.x - Player_Spead;
        if (userPosition.x <= Player_Size_Width/2) {
            userPosition.x = Player_Size_Width/2;
        }
    }else if (_userDirection == UserTouchDirectionRight){
        //右
        userPosition.x = userPosition.x + Player_Spead;
        if (userPosition.x >= self.frame.size.width - Player_Size_Width/2) {
            userPosition.x = self.frame.size.width - Player_Size_Width/2;
        }
    }
    self.player.position = userPosition;
}
#pragma mark - 手势处理
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    _userTouchLastP = point;
    if (point.x >= self.frame.size.width/2) {
        //右
        _userDirection = UserTouchDirectionRight;
    }else{
        //左
        _userDirection = UserTouchDirectionLeft;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (point.x == _userTouchLastP.x) {
        return;
    }
    if (point.x >= _userTouchLastP.x) {
        //右
        _userDirection = UserTouchDirectionRight;
    }else{
        //左
        _userDirection = UserTouchDirectionLeft;
    }
    _userTouchLastP = point;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    _userDirection = UserTouchDirectionNone;
    //如果当前游戏未开始--切换到runing状态
    if (self.gameState == GameState_Initial) {
        self.gameState = GameState_Runing;
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    _userDirection = UserTouchDirectionNone;
    //如果当前游戏未开始--切换到runing状态
    if (self.gameState == GameState_Initial) {
        self.gameState = GameState_Runing;
    }
}
#pragma mark -------- 定时器 ----------
- (void)startUpdateLink
{
    if (_updateLink == nil) {
        _updateLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayRender)];
        _updateLink.preferredFramesPerSecond = 60;
        [_updateLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
- (void)stopUpdateLink
{
    if(_updateLink){
        [_updateLink invalidate];
        _updateLink = nil;
    }
}
-(void)clearGame
{
    [self stopUpdateLink];
    
    glClearColor(0.0, 0.0, 0.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [GameSource.sharedInstance clearSource];
    
    //清空数据-渲染空数据
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
        
    [self.glkView deleteDrawable];
    [self.glkView removeFromSuperview];
    
    [EAGLContext setCurrentContext:nil];
    _context = nil;
}
@end
