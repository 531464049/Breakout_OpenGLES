//
//  BreakoutObject.h
//  Breakout
//
//  Created by mahao on 2022/4/29.
//

#import <Foundation/Foundation.h>
#import "BreakGameConfig.h"
#import "SpriteRender.h"
#import "MHShader.h"
#import "MHTexture2D.h"
#import "GameSource.h"

NS_ASSUME_NONNULL_BEGIN

/// 描述游戏内部个方块的对象
@interface BreakoutObject : NSObject

/// 位置，尺寸，速度
@property(nonatomic,assign)GLKVector2 position, size;
/// 颜色
@property(nonatomic,assign)GLKVector3 color;
/// 贴图
@property(nonatomic,strong)MHTexture2D * texture;
/// 是否坚固无法摧毁
@property(nonatomic,assign)BOOL isSolid;
/// 是否已被摧毁
@property(nonatomic,assign)BOOL destroyed;

BreakoutObject * breakoutObject(GLKVector2 position, GLKVector2 size, GLKVector3 color, MHTexture2D * texture);

-(void)draw:(SpriteRender *)render;


@end

NS_ASSUME_NONNULL_END
