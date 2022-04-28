//
//  MHGameView.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "MHGameView.h"
#import "MHResourceManager.h"

@interface MHGameView ()<GLKViewDelegate>

@property(nonatomic,strong)GLKView * glkView;
@property(nonatomic,strong)EAGLContext * context;
@property(nonatomic,strong)CADisplayLink * updateLink;

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
        
        [self startUpdateLink];
    }
    return self;
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0, 0.0, 0.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}
-(void)displayRender
{
    [self.glkView display];
}
#pragma mark -------- 定时器 ----------
- (void)startUpdateLink
{
    if (_updateLink == nil) {
        _updateLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayRender)];
        _updateLink.frameInterval = 2;
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
    
    resourceManagerClear();
    
    //清空数据-渲染空数据
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
        
    [self.glkView deleteDrawable];
    [self.glkView removeFromSuperview];
    
    [EAGLContext setCurrentContext:nil];
    _context = nil;
}
@end
