//
//  SpriteRender.h
//  Breakout
//
//  Created by mahao on 2022/4/28.
//

#import <Foundation/Foundation.h>
#import "MHShader.h"
#import "MHTexture2D.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpriteRender : NSObject

-(instancetype)initWithShader:(MHShader *)shader;
-(void)clearRnender;

void drawSprite(SpriteRender * render,MHTexture2D * texture, GLKVector2 position, GLKVector2 size, float rotate, GLKVector3 color);

@end

NS_ASSUME_NONNULL_END
