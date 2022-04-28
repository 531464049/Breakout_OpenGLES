//
//  GameViewController.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import "GameViewController.h"
#import "GameTopBar.h"
#import "MHGameView.h"

@interface GameViewController ()<GameTopBarDelegate>

@property(nonatomic,strong)GameTopBar * topBar;
@property(nonatomic,strong)MHGameView * gameView;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0.0, 0.0, 0.0, 255);
    [self setupUI];
}
-(void)setupUI
{
    self.topBar = [[GameTopBar alloc] initWithFrame:CGRectMake(0, STATUSBAR_H, SCREEN_W, NAVIBAR_H - STATUSBAR_H)];
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
    
    self.gameView = [[MHGameView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.topBar.frame) - 50 - k_bottom_margin)];
    [self.view addSubview:self.gameView];
}
-(void)topBar_back:(GameTopBar *)bar
{
    [self.gameView clearGame];
    
    CATransition * transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = .3;
    [self.navigationController.view.layer  addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
