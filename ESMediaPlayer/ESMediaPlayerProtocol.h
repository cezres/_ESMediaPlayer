//
//  ESMediaPlayerProtocol.h
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/3.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#ifndef ESMediaPlayerProtocol_h
#define ESMediaPlayerProtocol_h

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ESMediaLoadState) {
    ESMediaLoadStateUnknown        = 0,
    ESMediaLoadStatePlayable       = 1 << 0,
    ESMediaLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    ESMediaLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
};

typedef NS_ENUM(NSInteger, ESMediaPlaybackState) {
    ESMediaPlaybackStateStopped,
    ESMediaPlaybackStatePlaying,
    ESMediaPlaybackStatePaused,
    ESMediaPlaybackStateInterrupted,
    ESMediaPlaybackStateSeekingForward,
    ESMediaPlaybackStateSeekingBackward
};


@class ESMediaPlayerView;

@protocol ESMediaPlayerCtrlAble <NSObject>

/**
 播放器
 */
@property (weak, nonatomic) ESMediaPlayerView *playerView;


@optional

/**
 每次播放前都会reset一次
 */
- (void)reset;


#pragma mark - view

/**
 自动隐藏是否有效
 */
@property (assign, nonatomic, readonly) BOOL isEnableAutoHide;

/**
 重写此方法进行布局
 */
- (void)layoutWithRecommendRect:(CGRect)rect;



#pragma mark - state

/**
 加载状态发生改变
 
 @param loadState 加载状态
 */
- (void)playerLoadStateChanged:(ESMediaLoadState)loadState;

/**
 播放状态发生改变
 
 @param playbackState 播放状态
 */
- (void)playerBackStateChanged:(ESMediaPlaybackState)playbackState;

@end


#endif /* ESMediaPlayerProtocol_h */
