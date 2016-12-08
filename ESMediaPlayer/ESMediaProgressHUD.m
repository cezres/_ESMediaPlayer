//
//  ESMediaProgressHUD.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/8.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESMediaProgressHUD.h"

@interface ESMediaProgressHUD ()

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation ESMediaProgressHUD

+ (instancetype)showHUDWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    ESMediaProgressHUD *hud = [window viewWithTag:6846541];
    if (!hud) {
        hud = [[ESMediaProgressHUD alloc] init];
        hud.tag = 6846541;
        [window addSubview:hud];
        hud.frame = CGRectMake(0, 0, 100, 50);
        hud.center = window.center;
    }
    hud.progressView.progress = currentTime / duration;
    hud.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d / %02d:%02d", (int)currentTime / 60, (int)currentTime % 60, (int)duration / 60, (int)duration % 60];
    return hud;
}

+ (void)hidden {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    ESMediaProgressHUD *hud = [window viewWithTag:6846541];
    [hud hidden];
}


- (instancetype)init {
    if (self = [super initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]]) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _timeLabel.frame = CGRectMake(0, (self.bounds.size.height - 16) / 2, self.bounds.size.width, 16);
    _progressView.frame = CGRectMake(10, CGRectGetMaxY(_timeLabel.frame) + 5, self.bounds.size.width-20, 2);
}

#pragma mark - get / set

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIProgressView *)progressView; {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor colorWithRed:219/255.0 green:92/255.0 blue:92/255.0 alpha:1];
        _progressView.trackTintColor = [UIColor colorWithWhite:86/255.0 alpha:1.0];
        [self addSubview:_progressView];
    }
    return _progressView;
}

@end
