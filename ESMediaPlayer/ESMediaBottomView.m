//
//  ESMediaBottomView.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESMediaBottomView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "ESMediaPlayerView.h"

/**
 进度条
 */
@interface ESMediaProgress : UISlider

@end


@interface ESMediaBottomView ()

@property (strong, nonatomic) UIButton *playSwitchButton;

@property (strong, nonatomic) UIVisualEffectView *progressContentView;

@property (strong, nonatomic) ESMediaProgress *progress;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *durationLabel;

@end

@implementation ESMediaBottomView

- (instancetype)init {
    if (self = [super init]) {
        _progressContentView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [self addSubview:_progressContentView];
        
        _progress = [[ESMediaProgress alloc] init];
        [_progress addTarget:self action:@selector(didSliderTouchDown) forControlEvents:UIControlEventTouchDown];
        [_progress addTarget:self action:@selector(didSliderTouchCancel) forControlEvents:UIControlEventTouchCancel];
        [_progress addTarget:self action:@selector(didSliderTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_progress addTarget:self action:@selector(didSliderTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_progress addTarget:self action:@selector(didSliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [_progressContentView addSubview:_progress];
        
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentRight;
        [_progressContentView addSubview:_currentTimeLabel];
        
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:12];
        _durationLabel.text = @"00:00";
        [_progressContentView addSubview:_durationLabel];
        
        _playSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playSwitchButton addTarget:self action:@selector(onClickPlaySwitch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playSwitchButton];
    }
    return self;
}

- (void)refresh {
    _progress.value = _playerView.currentPlaybackTime;
    _currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)_playerView.currentPlaybackTime / 60, (int)_playerView.currentPlaybackTime % 60];
    if (!self.hidden) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:NULL];
        [self performSelector:@selector(refresh) withObject:NULL afterDelay:0.5];
    }
}

- (void)onClickPlaySwitch {
    if (_playerView.playbackState == IJKMPMoviePlaybackStatePlaying) {
        [_playerView pause];
    }
    else if (_playerView.playbackState == IJKMPMoviePlaybackStatePaused) {
        [_playerView play];
    }
    else if (_playerView.playbackState == IJKMPMoviePlaybackStateStopped) {
        _playerView.currentPlaybackTime = 0;
        [_playerView play];
    }
}

#pragma mark - Slider
- (void)didSliderTouchDown {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:NULL];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:NULL];
}
- (void)didSliderTouchCancel {
//    [self performSelector:@selector(hide) withObject:NULL afterDelay:5];
    [self refresh];
}
- (void)didSliderTouchUpOutside {
//    [self performSelector:@selector(hide) withObject:NULL afterDelay:5];
    [self refresh];
}
- (void)didSliderTouchUpInside {
    _playerView.currentPlaybackTime = _progress.value;
//    [VideoPlayerChangeProgressView hidden];
//    [self performSelector:@selector(hide) withObject:NULL afterDelay:5];
    [self refresh];
}
- (void)didSliderValueChanged {
//    [VideoPlayerChangeProgressView showProgressViewWith:_progressView.value duration:_duration];
}


#pragma mark - ESMediaCtrlAbleView
- (BOOL)isEnableAutoHide {
    return YES;
}

- (void)layoutWithRecommendRect:(CGRect)rect {
    self.frame = CGRectMake(0, rect.size.height - 49 - 50, rect.size.width, 49 + 50);
    _playSwitchButton.frame = CGRectMake(self.bounds.size.width - 10 - 55, 0, 55, 50);
    _progressContentView.frame = CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height-50);
    
    _progress.frame = CGRectMake(15+55+15, 0, _progressContentView.bounds.size.width-85-85, 49);
    _currentTimeLabel.frame = CGRectMake(15, (49 - 14) / 2, 55, 14);
    _durationLabel.frame = CGRectMake(_progressContentView.bounds.size.width - 15 - 55, (49 - 14) / 2, 55, 14);
}

- (void)reset {
    _progress.value = 0;
    _currentTimeLabel.text = @"00:00";
    _durationLabel.text = @"00:00";
}

- (void)playerLoadStateChanged:(ESMediaLoadState)loadState {
    if (loadState & ESMediaLoadStatePlayable) {
        _progress.maximumValue = _playerView.duration;
        _durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)_playerView.duration / 60, (int)_playerView.duration % 60];
    }
}

- (void)playerBackStateChanged:(ESMediaPlaybackState)playbackState {
    if (playbackState == ESMediaPlaybackStatePlaying) {
        [self refresh];
        [self.playSwitchButton setImage:[self imageWithName:@"player_pause"] forState:UIControlStateNormal];
    }
    else if (playbackState == ESMediaPlaybackStatePaused) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:NULL];
        [self.playSwitchButton setImage:[self imageWithName:@"player_play"] forState:UIControlStateNormal];
    }
    else if (playbackState == ESMediaPlaybackStateStopped) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:NULL];
        [self reset];
        [self.playSwitchButton setImage:[self imageWithName:@"player_play"] forState:UIControlStateNormal];
    }
}

#pragma mark - help
- (UIImage *)imageWithName:(NSString *)imageName {
    static NSBundle *iconBundle;
    if (!iconBundle) {
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        NSURL *iconBundleURL = [currentBundle URLForResource:@"icon" withExtension:@"bundle"];
        iconBundle = [NSBundle bundleWithURL:iconBundleURL];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@@%ldx", imageName, (long)[UIScreen mainScreen].scale];
    NSURL *imageURL = [iconBundle URLForResource:fileName withExtension:@"png"];
    if (!imageURL) {
        imageURL = [iconBundle URLForResource:imageName withExtension:@"png"];
    }
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}

@end




/**
 进度条
 */
@implementation ESMediaProgress

- (instancetype)init {
    if (self = [super init]) {
        self.minimumTrackTintColor = [UIColor colorWithRed:219/255.0 green:92/255.0 blue:92/255.0 alpha:1];
        self.maximumTrackTintColor = [UIColor colorWithWhite:86/255.0 alpha:1.0];
        self.minimumValue = 0;
        self.maximumValue = 1;
        self.value = 0;
        
        CGFloat width = 10;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIColor *bgColor = [UIColor clearColor];
        CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGRect bgRect = CGRectMake(0, 0, width, width);
        CGContextAddRect(context, bgRect);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, width/2, width/2, width/2, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFill);
        UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self setThumbImage:thumb forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds; {
    return CGRectMake(0, (bounds.size.height-4)/2, bounds.size.width, 4);
}

@end


