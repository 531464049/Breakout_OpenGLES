//
//  MHResourceManager.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "MHResourceManager.h"

@implementation MHResourceManager

+ (MHResourceManager *)sharedInstance {
    static MHResourceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[MHResourceManager alloc] init];
        }
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _shaders = [NSMutableDictionary dictionary];
        _textures = [NSMutableDictionary dictionary];
    }
    return self;
}
MHShader * loadShader(NSString * vertName, NSString * fragmentName, NSString * name)
{
    MHShader * shader = [[MHShader alloc] initWithVert:vertName fragment:fragmentName];
    MHResourceManager.sharedInstance.shaders[name] = shader;
    return shader;
}
MHShader * getShader(NSString * name)
{
    return MHResourceManager.sharedInstance.shaders[name];
}
MHTexture2D * loadTexture(NSString * imgName, NSString * name)
{
    MHTexture2D * texture = [[MHTexture2D alloc] initWithImgName:imgName];
    MHResourceManager.sharedInstance.textures[name] = texture;
    return texture;
}
MHTexture2D * getTexture(NSString * name)
{
    return MHResourceManager.sharedInstance.textures[name];
}
void resourceManagerClear(void)
{
    for (NSString * key in MHResourceManager.sharedInstance.shaders.allKeys) {
        glDeleteProgram(MHResourceManager.sharedInstance.shaders[key].ID);
    }
    [MHResourceManager.sharedInstance.shaders removeAllObjects];
    for (NSString * key in MHResourceManager.sharedInstance.textures.allKeys) {
        GLuint texture = MHResourceManager.sharedInstance.textures[key].ID;
        glDeleteTextures(1, &texture);
    }
    [MHResourceManager.sharedInstance.textures removeAllObjects];
}
@end
