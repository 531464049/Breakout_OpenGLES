//
//  MHShader.h
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHShader : NSObject

@property(nonatomic,assign,readonly)GLuint ID;

-(instancetype)initWithVert:(NSString *)vertName fragment:(NSString *)fragmentName;

void shaderUse(MHShader * shader);
void shaderSetInt(MHShader * shader, const char *name, int value);
void shaderSetFloat(MHShader * shader, const char *name, float value);
void shaderSetVector2f(MHShader * shader, const char *name, GLKVector2 value);
void shaderSetVector3f(MHShader * shader, const char *name, GLKVector3 value);
void shaderSetVector4f(MHShader * shader, const char *name, GLKVector4 value);
void shaderSetMatrix4(MHShader * shader, const char *name, GLKMatrix4 matrix);

@end

NS_ASSUME_NONNULL_END
