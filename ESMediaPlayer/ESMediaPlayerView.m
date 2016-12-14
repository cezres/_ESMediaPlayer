//
//  ESMediaPlayerView.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESMediaPlayerView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "ESMediaBottomView.h"
#import "ESMediaGestureRecognizer.h"


@interface ESMediaPlayerView ()
{
    id<IJKMediaPlayback> _player;
    NSMutableArray<id<ESMediaPlayerCtrlAble>> *_ctrls;
}

@property (strong, nonatomic) NSString *MIMEType;

@property (weak, nonatomic) UIImageView *audioArtworkView;

@end

@implementation ESMediaPlayerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackStateChanged:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playLoadStateChanged:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:NULL];
        
        _ctrls = [NSMutableArray array];
        _autoHiddenTimeinterval = 4;
        
        [self addMediaCtrl:[[ESMediaBottomView alloc] init]];
        [self addMediaCtrl:[[ESMediaGestureRecognizer alloc] init]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _player.view.frame = self.bounds;
    _audioArtworkView.frame = self.bounds;
    for (id<ESMediaPlayerCtrlAble> ctrl  in _ctrls) {
        if ([ctrl respondsToSelector:@selector(layoutWithPlayerBounds:)]) {
            [ctrl layoutWithPlayerBounds:self.bounds];
        }
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [_player prepareToPlay];
        [self setCtrlViewHidden:@(NO)];
    }
    else {
        [_player shutdown];
    }
}


- (BOOL)play:(NSURL *)url {
    if ([_url.absoluteString isEqualToString:url.absoluteString]) {
        [self play];
        return YES;
    }
    [self stop];
    _url = url;
    [self initPlayer];
    if (self.window) {
        [_player prepareToPlay];
    }
    return YES;
}
- (void)play {
    [_player play];
}
- (void)pause {
    [_player pause];
}

- (void)stop {
    if (_player) {
        [_player.view removeFromSuperview];
        [_player shutdown];
        _player = NULL;
        for (id<ESMediaPlayerCtrlAble> ctrl  in _ctrls) {
            if ([ctrl respondsToSelector:@selector(playerBackStateChanged:)]) {
                [ctrl playerBackStateChanged:ESMediaPlaybackStateStopped];
            }
        }
    }
}

- (void)shutdown {
    for (id<ESMediaPlayerCtrlAble> ctrl in _ctrls) {
        if ([ctrl isKindOfClass:[UIView class]]) {
            [((UIView *)ctrl) removeFromSuperview];
        }
    }
    _ctrls = NULL;
    [_player shutdown];
    [_player.view removeFromSuperview];
    _player = NULL;
}

- (void)setCtrlViewHidden:(NSNumber *)hidden {
    BOOL isCanHideCtrlView = YES;
    for (id<ESMediaPlayerCtrlAble> ctrl  in _ctrls) {
        if ([ctrl respondsToSelector:@selector(isCanHideCtrlView)]) {
            if (![ctrl isCanHideCtrlView]) {
                isCanHideCtrlView = NO;
                break;
            }
        }
    }
    if (isCanHideCtrlView) {
        _isCtrlViewHidden = [hidden boolValue];
        for (id<ESMediaPlayerCtrlAble> ctrl  in _ctrls) {
            if ([ctrl respondsToSelector:@selector(setCtrlViewHidden:)]) {
                [ctrl setCtrlViewHidden:[hidden boolValue]];
            }
        }
    }
    if (!_isCtrlViewHidden && _autoHiddenTimeinterval > 0 && _player.isPlaying) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setCtrlViewHidden:) object:NULL];
        [self performSelector:@selector(setCtrlViewHidden:) withObject:@(YES) afterDelay:_autoHiddenTimeinterval];
    }
}

- (void)addMediaCtrl:(id<ESMediaPlayerCtrlAble>)ctrl {
    if (![ctrl conformsToProtocol:NSProtocolFromString(@"ESMediaPlayerCtrlAble")]) {
        return;
    }
    if ([ctrl isKindOfClass:[UIView class]]) {
        [self addSubview:(UIView *)ctrl];
    }
    [ctrl setPlayerView:self];
    [_ctrls addObject:ctrl];
}

/**
 初始化播放器
 */
- (void)initPlayer {
    NSString *MIMEType = [self getMIMETypeWithFilePath:_url.path];
    NSLog(@"文件类型: %@", MIMEType);
    if ([AVURLAsset isPlayableExtendedMIMEType:MIMEType]) {
        _player = [[IJKAVMoviePlayerController alloc] initWithContentURL:_url];
        if ([MIMEType hasPrefix:@"audio"]) {
            self.audioArtworkView.image = [self getAudioArtworkWithURL:_url];
        }
    }
    else {
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:_url withOptions:options];
    }
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _player.scalingMode = IJKMPMovieScalingModeAspectFit;
    _player.shouldAutoplay = YES;
    [self insertSubview:_player.view atIndex:0];
}




#pragma mark - Notification
/// 加载状态发生改变
- (void)playLoadStateChanged:(NSNotification*)notification {
    ESMediaLoadState loadState = (ESMediaLoadState)[_player loadState];
    
    if (loadState == ESMediaLoadStateUnknown) {
        printf("loadState:\tESMediaLoadStateUnknown\n");
    }
    if (loadState & ESMediaLoadStatePlayable) {
        printf("loadState:\tESMediaLoadStatePlayable\n");
    }
    if (loadState & ESMediaLoadStatePlaythroughOK) {
        printf("loadState:\tESMediaLoadStatePlaythroughOK\n");
    }
    if (loadState & ESMediaLoadStateStalled) {
        printf("loadState:\tESMediaLoadStateStalled\n");
    }
    for (id<ESMediaPlayerCtrlAble> ctrl  in _ctrls) {
        if ([ctrl respondsToSelector:@selector(playerLoadStateChanged:)]) {
            [ctrl playerLoadStateChanged:(ESMediaLoadState)loadState];
        }
    }
}
/// 播放状态发生改变
- (void)playBackStateChanged:(NSNotification*)notification {
    IJKMPMoviePlaybackState playbackState = [_player playbackState];
    if (playbackState == ESMediaPlaybackStateStopped) {
        printf("playbackState:\tESMediaPlaybackStateStopped\n");
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setCtrlViewHidden:) object:NULL];
    }
    else if (playbackState == ESMediaPlaybackStatePlaying) {
        printf("playbackState:\tESMediaPlaybackStatePlaying\n");
        if (!_isCtrlViewHidden && _autoHiddenTimeinterval > 0) {
            [self performSelector:@selector(setCtrlViewHidden:) withObject:@(YES) afterDelay:_autoHiddenTimeinterval];
        }
    }
    else if (playbackState == ESMediaPlaybackStatePaused) {
        printf("playbackState:\tESMediaPlaybackStatePaused\n");
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setCtrlViewHidden:) object:NULL];
    }
    else if (playbackState == ESMediaPlaybackStateInterrupted) {
        printf("playbackState:\tESMediaPlaybackStateInterrupted\n");
    }
    else if (playbackState == ESMediaPlaybackStateSeekingForward) {
        printf("playbackState:\tESMediaPlaybackStateSeekingForward\n");
    }
    else if (playbackState == ESMediaPlaybackStateSeekingBackward) {
        printf("playbackState:\tESMediaPlaybackStateSeekingBackward\n");
    }
    for (id<ESMediaPlayerCtrlAble> ctrl  in _ctrls) {
        if ([ctrl respondsToSelector:@selector(playerBackStateChanged:)]) {
            [ctrl playerBackStateChanged:(ESMediaPlaybackState)playbackState];
        }
    }
}

#pragma mark - Player
- (NSTimeInterval)currentPlaybackTime {
    return [_player currentPlaybackTime];
}
- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime {
    [_player setCurrentPlaybackTime:currentPlaybackTime];
}
- (NSTimeInterval)duration {
    return [_player duration];
}
- (ESMediaPlaybackState)playbackState {
    return (ESMediaPlaybackState)[_player playbackState];
}
- (ESMediaLoadState)loadState {
    return (ESMediaLoadState)[_player loadState];
}

#pragma mark - set 
- (void)setAutoHiddenTimeinterval:(NSTimeInterval)autoHiddenTimeinterval {
    _autoHiddenTimeinterval = autoHiddenTimeinterval;
    if (!self.window) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setCtrlViewHidden:) object:NULL];
    if (_autoHiddenTimeinterval > 0) {
        [self performSelector:@selector(setCtrlViewHidden:) withObject:@(YES) afterDelay:_autoHiddenTimeinterval];
    }
}


#pragma mark - get
- (UIImageView *)audioArtworkView {
    if (!_audioArtworkView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_player.view addSubview:imageView];
        _audioArtworkView = imageView;
    }
    return _audioArtworkView;
}
- (NSArray<id<ESMediaPlayerCtrlAble>> *)ctrls {
    return [_ctrls copy];
}


#pragma mark - help

- (NSString *)getMIMETypeWithFilePath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return NULL;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return (__bridge NSString *)(MIMEType);
}

- (UIImage *)getAudioArtworkWithURL:(NSURL *)url {
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    for (AVMetadataItem *metadataItem in [asset metadata]) {
        if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
            if ([metadataItem.value isKindOfClass:[NSData class]]) {
                return [UIImage imageWithData:(NSData *)metadataItem.value];
            }
        }
    }
    return NULL;
}

@end
