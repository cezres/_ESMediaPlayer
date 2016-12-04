//
//  ESMediaGestureRecognizer.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/3.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESMediaGestureRecognizer.h"
#import "ESMediaPlayerView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger, PanGestureMode) {
    PanGestureModeNone,
    /// 音量
    PanGestureModeVolume,
    /// 亮度
    PanGestureModeBrightness,
    /// 播放进度
    PanGestureModePlayProgress
};

@interface ESMediaGestureRecognizer ()

{
    PanGestureMode _panGestureMode;
    
    NSTimeInterval _playTime;
}

@end

@implementation ESMediaGestureRecognizer

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setPlayerView:(ESMediaPlayerView *)playerView {
    _playerView = playerView;
    [_playerView addGestureRecognizer:self.tapGesture];
    [_playerView addGestureRecognizer:self.panGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [_playerView setCtrlViewHidden:@(!_playerView.isCtrlViewHidden)];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:_playerView];
    CGPoint location = [panGesture locationInView:_playerView];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x < panGesture.view.bounds.size.width / 2 &&
            fabs(translation.y) >= fabs(translation.x)) {
            _panGestureMode = PanGestureModeBrightness;
            NSLog(@"亮度");
        }
        else if (location.x > panGesture.view.bounds.size.width/2 &&
                 fabs(translation.y) >= fabs(translation.x)) {
            _panGestureMode = PanGestureModeVolume;
            NSLog(@"音量");
        }
        else {
            _panGestureMode = PanGestureModePlayProgress;
            _playTime = [_playerView currentPlaybackTime];
            NSLog(@"播放进度");
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (_panGestureMode == PanGestureModePlayProgress) {
            
        }
        else {
            CGFloat offset = -translation.y / 200;
            if (_panGestureMode == PanGestureModeBrightness) {
                [UIScreen mainScreen].brightness += offset;
            }
            else if (_panGestureMode == PanGestureModeVolume) {
                MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                musicPlayer.volume += offset;
#pragma clang diagnostic pop
            }
            [panGesture setTranslation:CGPointZero inView:panGesture.view];
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (_panGestureMode == PanGestureModePlayProgress) {
            CGFloat offset = translation.x / panGesture.view.bounds.size.width * _playerView.duration;
            CGFloat newTime = _playTime + offset;
            newTime = newTime < 0 ? 0 : newTime > _playerView.duration ? _playerView.duration : newTime;
            _playerView.currentPlaybackTime = newTime;
        }
        _panGestureMode = PanGestureModeNone;
    }
}


#pragma mark - get
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}

@end
