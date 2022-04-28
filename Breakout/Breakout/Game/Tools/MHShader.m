//
//  Shader.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "MHShader.h"

@implementation MHShader

-(instancetype)initWithVert:(NSString *)vertName fragment:(NSString *)fragmentName
{
    self = [super init];
    if (self) {
        _ID = complieLinkShader(vertName, fragmentName);
        if (_ID == -1) {
            NSLog(@"******* 着色器编译链接失败 *******");
        }
    }
    return self;
}
#pragma mark - 编译链接着色器
GLint complieLinkShader(NSString * vertName, NSString * fragmentName)
{
    NSString * vertexPath = [[NSBundle mainBundle] pathForResource:vertName ofType:nil];
    NSString * fragmentPath = [[NSBundle mainBundle] pathForResource:fragmentName ofType:nil];
    
    GLuint vertShader = 0;
    GLuint fragShader = 0;

    //创建着色器程序
    GLint program = glCreateProgram();

    NSURL * vertUrl = [NSURL fileURLWithPath:vertexPath];
    NSURL * fragUrl = [NSURL fileURLWithPath:fragmentPath];
    if (!compileShader(&vertShader, GL_VERTEX_SHADER, vertUrl)) {
        NSLog(@"Failed to compile vertex shader");
        return -1;
    }
    
    if (!compileShader(&fragShader, GL_FRAGMENT_SHADER, fragUrl)) {
        NSLog(@"Failed to compile fragment shader");
        return -1;
    }

    //绑定顶点着色器
    glAttachShader(program, vertShader);
    //绑定片段着色器
    glAttachShader(program, fragShader);
    //两个着色器都已绑定到着色器程序上了，删除
    glDeleteShader(vertShader);
    glDeleteShader(fragShader);
    //链接
    glLinkProgram(program);
    GLint linkSuccess;
    glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) { //连接错误
        GLchar messages[256];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"Shader Program Error:%@", messageString);
        return -1;
    }
    return program;
}
BOOL compileShader(GLuint * shader, GLenum type, NSURL * URL)
{
    NSError * error;
    NSString * sourceString = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    if (!sourceString) {
        NSLog(@"Failed to load vertex shader: %@", [error localizedDescription]);
        return NO;
    }
    
    const GLchar * source = (GLchar *)[sourceString UTF8String];
    return compileShaderString(shader, type, source);
}
BOOL compileShaderString(GLuint * shader, GLenum type, const GLchar * shaderString)
{
    //shader 着色器
    //type 类型 顶点着色器：GL_VERTEX_SHADER   片段着色器：GL_FRAGMENT_SHADER
    //shaderString 着色器源码
    //创建着色器
    *shader = glCreateShader(type);
    //加载着色器源码
    glShaderSource(*shader, 1, &shaderString, NULL);
    //编译着色器
    glCompileShader(*shader);
    // 获取结果，没获取到就释放内存
    GLint status = 0;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(*shader, sizeof(messages), 0, &messages[0]);
        NSLog(@"%s",messages);
    }
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}

void shaderUse(MHShader * shader)
{
    glUseProgram(shader.ID);
}
void shaderSetInt(MHShader * shader, const char *name, int value)
{
    glUniform1i(glGetUniformLocation(shader.ID, name), value);
}
void shaderSetFloat(MHShader * shader, const char *name, float value)
{
    glUniform1f(glGetUniformLocation(shader.ID, name), value);
}
void shaderSetVector2f(MHShader * shader, const char *name, GLKVector2 value)
{
    glUniform2f(glGetUniformLocation(shader.ID, name), value.x, value.y);
}
void shaderSetVector3f(MHShader * shader, const char *name, GLKVector3 value)
{
    glUniform3f(glGetUniformLocation(shader.ID, name), value.x, value.y, value.z);
}
void shaderSetVector4f(MHShader * shader, const char *name, GLKVector4 value)
{
    glUniform4f(glGetUniformLocation(shader.ID, name), value.x, value.y, value.z, value.w);
}
void shaderSetMatrix4(MHShader * shader, const char *name, GLKMatrix4 matrix)
{
    glUniformMatrix4fv(glGetUniformLocation(shader.ID, name), 1, GL_FALSE, matrix.m);
}
@end
