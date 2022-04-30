//
//  SpriteRender.m
//  Breakout
//
//  Created by mahao on 2022/4/28.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "SpriteRender.h"

@interface SpriteRender ()

@property(nonatomic,strong)MHShader * shader;
@property(nonatomic,assign)GLuint VBO;
@property(nonatomic,assign)GLuint VAO;

@end

@implementation SpriteRender

-(instancetype)initWithShader:(MHShader *)shader
{
    self = [super init];
    if (self) {
        self.shader = shader;
        [self initRenderData];
    }
    return self;
}
-(void)initRenderData
{
    float vertices[] = {
        // 位置     // 纹理
        -0.5f, 0.5f, 0.0f, 1.0f,
        0.5f, -0.5f, 1.0f, 0.0f,
        -0.5f, -0.5f, 0.0f, 0.0f,

        -0.5f, 0.5f, 0.0f, 1.0f,
        0.5f, 0.5f, 1.0f, 1.0f,
        0.5f, -0.5f, 1.0f, 0.0f
        };
    
    //绑定纹理 顶点 法线
    GLuint VAO, VBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glBindVertexArray(VAO);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 4, (GLfloat *)NULL + 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    self.VAO = VAO;
    self.VBO = VBO;
}
-(void)clearRnender
{
    GLuint VBO = self.VBO;
    glDeleteBuffers(1, &VBO);
    GLuint VAO = self.VAO;
    glDeleteVertexArrays(1, &VAO);
}
void drawSprite(SpriteRender * render,MHTexture2D * texture, GLKVector2 position, GLKVector2 size, float rotate, GLKVector3 color)
{
    shaderUse(render.shader);
    shaderSetInt(render.shader, "spriteTexture", 0);
    glActiveTexture(GL_TEXTURE0);
    bindTexture(texture);
    
    //平移-->旋转-->缩放
    GLKMatrix4 modelMat = GLKMatrix4Identity;
    modelMat = GLKMatrix4Translate(modelMat, position.x, position.y, 0.0);
    modelMat = GLKMatrix4Rotate(modelMat, K_RADIANS(rotate), 0.0, 0.0, 1.0);
    modelMat = GLKMatrix4Scale(modelMat, size.x, size.y, 1.0);
    shaderSetMatrix4(render.shader, "model", modelMat);
    shaderSetVector3f(render.shader, "spriteColor", color);
    
    glBindVertexArray(render.VAO);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArray(0);
}
@end
