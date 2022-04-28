//
//  MHTexture2D.h
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

@interface MHTexture2D : NSObject

@property(nonatomic,assign,readonly)GLint ID;

-(instancetype)initWithImgName:(NSString *)imgName;

void bindTexture(MHTexture2D * texture);

@end

NS_ASSUME_NONNULL_END
