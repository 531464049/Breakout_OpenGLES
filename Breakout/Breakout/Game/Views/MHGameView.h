//
//  MHGameView.h
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHGameView : UIView

-(void)clearGame;

@end

NS_ASSUME_NONNULL_END
