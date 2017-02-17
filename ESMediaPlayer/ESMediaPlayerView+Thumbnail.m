//
//  ESMediaPlayerView+Thumbnail.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2017/2/10.
//  Copyright © 2017年 翟泉. All rights reserved.
//

#import "ESMediaPlayerView+Thumbnail.h"
#import "ESMediaPlayerView_Internal.h"

#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@implementation ESMediaPlayerView (Thumbnail)

+ (UIImage *)thumbnailImageWithURL:(NSURL *)url {
    UIImage *thumbnailImage;
    NSString *MIMEType = [ESMediaPlayerView getMIMETypeWithFilePath:url.path];
    if ([MIMEType hasPrefix:@"audio"]) {
        thumbnailImage = [ESMediaPlayerView getAudioArtworkWithURL:url];
    }
    else if ([MIMEType hasPrefix:@"video"]) {
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        NSError *error = nil;
        CMTime time = CMTimeMakeWithSeconds(0, 1);
        CMTime actualTime;
        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
        thumbnailImage = [UIImage imageWithCGImage:cgImage];
        if (!thumbnailImage) {
            thumbnailImage = FFMovieThumbnailImage(url, 1);
        }
    }
    return thumbnailImage;
}

@end




