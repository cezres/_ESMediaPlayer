//
//  ESMediaPlayerView_Internal.h
//  ESMediaPlayer
//
//  Created by 翟泉 on 2017/2/10.
//  Copyright © 2017年 翟泉. All rights reserved.
//

#import <ESMediaPlayer/ESMediaPlayer.h>

@interface ESMediaPlayerView ()

+ (NSString *)getMIMETypeWithFilePath:(NSString *)path;

+ (UIImage *)getAudioArtworkWithURL:(NSURL *)url;

- (void)setLoadState:(ESMediaLoadState)loadState;

@end
