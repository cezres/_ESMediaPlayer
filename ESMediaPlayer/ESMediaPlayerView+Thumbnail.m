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
#import <objc/runtime.h>

@implementation ESMediaPlayerView (Thumbnail)

//+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;   {
//    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
//    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
//    if (class_addMethod([self class],originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod))) {
//        class_replaceMethod([self class],swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}


//+ (void)initialize {
//    NSLog(@"%s", __FUNCTION__);
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleMethod:@selector(setLoadState:) swizzledSelector:@selector(thumbnail_setLoadState:)];
//    });
//}

//- (void)thumbnail_setLoadState:(ESMediaLoadState)loadState {
//    
//}

+ (UIImage *)thumbnailImageWithURL:(NSURL *)url {
    UIImage *thumbnailImage = [self cacheImageForURL:url];
    if (thumbnailImage) {
        return thumbnailImage;
    }
    
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
    }
    [self storeCachedImage:thumbnailImage ForURL:url];
    return thumbnailImage;
}


#pragma mark help

+ (NSString *)cachePathForURL:(NSURL *)url {
    if (!url) {
        return NULL;
    }
    static NSString *cacheDirPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/ESMediaPlayer"];
        BOOL isDirectory;
        if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirPath isDirectory:&isDirectory] || !isDirectory) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirPath withIntermediateDirectories:NO attributes:NULL error:NULL];
        }
    });
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:NULL];
    return [cacheDirPath stringByAppendingFormat:@"/%@", [attributes objectForKey:@"NSFileSize"]];
}

+ (UIImage *)cacheImageForURL:(NSURL *)url {
    if (!url) {
        return NULL;
    }
    NSString *path = [self cachePathForURL:url];
    if (!path) {
        return NULL;
    }
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+ (void)storeCachedImage:(UIImage *)cachedImage ForURL:(NSURL *)url {
    if (!cachedImage || !url) {
        return;
    }
    NSString *path = [self cachePathForURL:url];
    if (!path) {
        return;
    }
    [UIImagePNGRepresentation(cachedImage) writeToFile:path atomically:YES];
}

+ (void)removeThumbnailCachedForURL:(NSURL *)url {
    NSString *path = [self cachePathForURL:url];
    if (!path) {
        return;
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+ (void)removeAllThumbnailCached {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/ESMediaPlayer"];
    [[NSFileManager defaultManager] removeItemAtPath:dir error:NULL];
}

@end




