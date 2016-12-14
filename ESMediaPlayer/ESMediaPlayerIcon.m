//
//  ESMediaPlayerIcon.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/14.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESMediaPlayerIcon.h"

@implementation ESMediaPlayerIcon

+ (UIImage *)iconWithName:(NSString *)iconName {
    static NSBundle *iconBundle;
    if (!iconBundle) {
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        NSURL *iconBundleURL = [currentBundle URLForResource:@"icon" withExtension:@"bundle"];
        iconBundle = [NSBundle bundleWithURL:iconBundleURL];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@@%ldx", iconName, (long)[UIScreen mainScreen].scale];
    NSURL *imageURL = [iconBundle URLForResource:fileName withExtension:@"png"];
    if (!imageURL) {
        imageURL = [iconBundle URLForResource:iconName withExtension:@"png"];
    }
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}

@end
