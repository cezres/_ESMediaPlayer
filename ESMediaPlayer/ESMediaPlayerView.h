//
//  ESMediaPlayerView.h
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESMediaPlayerProtocol.h"

@protocol IJKMediaPlayback;

@interface ESMediaPlayerView : UIView

@property (strong, nonatomic, readonly) NSURL *url;

@property (strong, nonatomic, readonly) id<IJKMediaPlayback> player;

@property (strong, nonatomic, readonly) NSArray<id<ESMediaPlayerCtrlAble>> *ctrls;

@property (assign, nonatomic, readonly) BOOL isCtrlViewHidden;

//@property (assign, nonatomic) BOOL isEnableAutoHide;

/**
 自动隐藏控制视图的时间间隔  如果小于等于0 不自动隐藏
 */
@property (assign, nonatomic) NSTimeInterval autoHiddenTimeinterval;


- (BOOL)play:(NSURL *)url;

- (void)play;

- (void)pause;

- (void)stop;

- (void)shutdown;

/**
 设置控制视图隐藏

 @param hidden 是否隐藏
 */
- (void)setCtrlViewHidden:(NSNumber *)hidden;


- (void)addMediaCtrl:(id<ESMediaPlayerCtrlAble>)ctrl;


#pragma mark - Player

@property (assign, nonatomic) NSTimeInterval currentPlaybackTime;
@property (assign, nonatomic, readonly) NSTimeInterval duration;

@property (assign, nonatomic, readonly) ESMediaPlaybackState playbackState;
@property (assign, nonatomic, readonly) ESMediaLoadState loadState;

@end
