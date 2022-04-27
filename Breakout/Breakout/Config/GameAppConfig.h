//
//  GameAppConfig.h
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#ifndef GameAppConfig_h
#define GameAppConfig_h

//常用尺寸
// 判断是否为iPhone X
#define K_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define SCREEN_B        ([UIScreen mainScreen].bounds)
#define SCREEN_W SCREEN_B.size.width
#define SCREEN_H SCREEN_B.size.height
#define NAVIBAR_H       (K_iPhoneX ? 88 : 64)
#define STATUSBAR_H     (K_iPhoneX ? 44 : 20)
#define TABBAR_H        (K_iPhoneX ? 83 : 49)
#define TABBARITEM_H    (K_iPhoneX ? 49 : 49)
#define k_bottom_margin    (K_iPhoneX ? 34.0 : 0.0)   //底部安全区域高度

#endif /* GameAppConfig_h */
