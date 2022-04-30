//
//  BreakoutObject.m
//  Breakout
//
//  Created by mahao on 2022/4/29.
//

#import "BreakoutObject.h"

@implementation BreakoutObject

BreakoutObject * breakoutObject(GLKVector2 position, GLKVector2 size, GLKVector3 color, MHTexture2D * texture)
{
    BreakoutObject * obj = [[BreakoutObject alloc] init];
    obj.position = position;
    obj.size = size;
    obj.color = color;
    obj.texture = texture;
    return obj;
}

-(void)draw:(SpriteRender *)render
{
    drawSprite(render, self.texture, self.position, self.size, 0.0, self.color);
}
@end
