//
//  GameSource.h
//  Breakout
//
//  Created by mahao on 2022/4/29.
//

#import <Foundation/Foundation.h>
#import "MHShader.h"
#import "MHTexture2D.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameSource : NSObject

MHShader * loadShder(NSString * vShaderFile, NSString * fShaderFile, NSString * shaderName);
MHTexture2D * loadTexture(NSString * imgName, NSString * textureName);
MHShader * getShader(NSString * shaderName);
MHTexture2D * getTexture(NSString * textureName);

-(void)clearSource;

+ (GameSource *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
