//
//  MHTexture2D.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "MHTexture2D.h"

@implementation MHTexture2D

-(instancetype)initWithImgName:(NSString *)imgName
{
    self = [super init];
    if (self) {
        _ID = loadImageTexture(imgName);
        if (_ID == -1) {
            NSLog(@"****** 图片纹理读取失败 ******");
        }
    }
    return self;
}
GLint loadImageTexture(NSString * imgName)
{
    //获取图片CGImageRef
    UIImage * image = [UIImage imageNamed:imgName];
    CGImageRef spriteImage = image.CGImage;
    if (!spriteImage) {
        NSLog(@"图片加载失败??????");
        return -1;
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
  
    GLuint texture;//纹理ID
    glGenTextures(1, &texture);
    //绑定纹理
    glBindTexture(GL_TEXTURE_2D, texture);
    //过滤方式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    //环绕方式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    //生成纹理
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (float)width, (float)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glGenerateMipmap(GL_TEXTURE_2D);//这会为当前绑定的纹理自动生成所有需要的多级渐远纹理。
    //绑定纹理
    glBindTexture(GL_TEXTURE_2D, texture);

    free(spriteData);
    return texture;
}
void bindTexture(MHTexture2D * texture)
{
    glBindTexture(GL_TEXTURE_2D, texture.ID);
}
@end
