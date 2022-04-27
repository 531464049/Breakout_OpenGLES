//
//  ViewController.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import "ViewController.h"
#import "GameViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * startBtn = [UIButton buttonWithType:0];
    startBtn.frame = CGRectMake(0, 0, 100, 50);
    startBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [startBtn setTitle:@"Start Game" forState:0];
    startBtn.backgroundColor = [UIColor randomColor];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [startBtn setTitleColor:[UIColor whiteColor] forState:0];
    startBtn.layer.cornerRadius = 10;
    startBtn.layer.masksToBounds = YES;
    [startBtn addTarget:self action:@selector(start_game) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}
-(void)start_game
{
    GameViewController * vc = [[GameViewController alloc] init];
    
    CATransition * transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = .3;
    [self.navigationController.view.layer  addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:vc animated:NO];
}

@end
