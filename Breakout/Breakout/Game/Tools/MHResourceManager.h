//
//  MHResourceManager.h
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import <Foundation/Foundation.h>
#import "MHShader.h"
#import "MHTexture2D.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHResourceManager : NSObject

@property(nonatomic,strong,readonly)NSMutableDictionary<NSString *,MHShader*> * shaders;
@property(nonatomic,strong,readonly)NSMutableDictionary<NSString *,MHTexture2D*> * textures;

MHShader * loadShader(NSString * vertName, NSString * fragmentName, NSString * name);
MHShader * getShader(NSString * name);
MHTexture2D * loadTexture(NSString * imgName, NSString * name);
MHTexture2D * getTexture(NSString * name);

void resourceManagerClear(void);

+ (MHResourceManager *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
