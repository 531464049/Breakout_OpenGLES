//
//  AppDelegate.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController * vc = [[ViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    nav.interactivePopGestureRecognizer.enabled = NO;
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
