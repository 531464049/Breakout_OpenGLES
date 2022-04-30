//
//  GameSource.m
//  Breakout
//
//  Created by mahao on 2022/4/29.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "GameSource.h"

@interface GameSource ()

@property(nonatomic,strong)NSMutableDictionary<NSString *, MHShader *> * shaderMap;
@property(nonatomic,strong)NSMutableDictionary<NSString *, MHTexture2D *> * textureMap;

@end

@implementation GameSource

+ (GameSource *)sharedInstance {
    static GameSource *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[GameSource alloc] init];
        }
    });
    return sharedInstance;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.shaderMap = [NSMutableDictionary dictionary];
        self.textureMap = [NSMutableDictionary dictionary];
    }
    return self;
}
MHShader * loadShder(NSString * vShaderFile, NSString * fShaderFile, NSString * shaderName)
{
    MHShader * shader = [[MHShader alloc] initWithVert:vShaderFile fragment:fShaderFile];
    GameSource.sharedInstance.shaderMap[shaderName] = shader;
    return shader;
}
MHTexture2D * loadTexture(NSString * imgName, NSString * textureName)
{
    MHTexture2D * texture = [[MHTexture2D alloc] initWithImgName:imgName];
    GameSource.sharedInstance.textureMap[textureName] = texture;
    return texture;
}
MHShader * getShader(NSString * shaderName)
{
    return GameSource.sharedInstance.shaderMap[shaderName];
}
MHTexture2D * getTexture(NSString * textureName)
{
    return GameSource.sharedInstance.textureMap[textureName];
}

-(void)clearSource
{
    for (NSString * key in self.shaderMap.allKeys) {
        MHShader * shader = GameSource.sharedInstance.shaderMap[key];
        glDeleteProgram(shader.ID);
    }
    [self.shaderMap removeAllObjects];
    for (NSString * key in self.textureMap.allKeys) {
        GLuint texture = GameSource.sharedInstance.textureMap[key].ID;
        glDeleteTextures(1, &texture);
    }
    [self.textureMap removeAllObjects];
}
@end
