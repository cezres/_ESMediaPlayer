//
//  ESMediaGestureRecognizer.h
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/3.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESMediaPlayerProtocol.h"

@interface ESMediaGestureRecognizer : NSObject
<ESMediaPlayerCtrlAble>

@property (weak, nonatomic) ESMediaPlayerView *playerView;


@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;


@end
