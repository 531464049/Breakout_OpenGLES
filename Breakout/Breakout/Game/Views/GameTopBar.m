//
//  GameTopBar.m
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import "GameTopBar.h"

@interface GameTopBar ()

@end

@implementation GameTopBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    self.backBtn = [UIButton buttonWithType:0];
    self.backBtn.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    [self.backBtn setImage:[UIImage imageNamed:@"icon-arrow-left"] forState:0];
    [self.backBtn addTarget:self action:@selector(back_handle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
}
-(void)back_handle
{
    [self.delegate topBar_back:self];
}
@end
