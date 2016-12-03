//
//  ESMediaBottomView.h
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESMediaPlayerProtocol.h"

@interface ESMediaBottomView : UIView
<ESMediaPlayerCtrlAble>

@property (weak, nonatomic) ESMediaPlayerView *playerView;

@end




