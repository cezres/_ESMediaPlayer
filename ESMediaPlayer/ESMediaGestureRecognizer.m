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

@interface ESMediaGestureRecognizer ()



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
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [_playerView setCtrlViewHidden:@(!_playerView.isCtrlViewHidden)];
}



#pragma mark - get
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    return _tapGesture;
}

@end
