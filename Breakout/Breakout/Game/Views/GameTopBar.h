//
//  GameTopBar.h
//  Breakout
//
//  Created by mahao on 2022/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GameTopBar;
@protocol GameTopBarDelegate <NSObject>

@required
-(void)topBar_back:(GameTopBar *)bar;

@end

@interface GameTopBar : UIView

@property(nonatomic,weak)id <GameTopBarDelegate> delegate;
@property(nonatomic,strong)UIButton * backBtn;

@end

NS_ASSUME_NONNULL_END
