//
//  ESMediaPlayerViewController.h
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESMediaPlayerView.h"

@interface ESMediaPlayerViewController : UIViewController

@property (strong, nonatomic) ESMediaPlayerView *playerView;


/**
 播放完成后关闭控制器
 */
@property (assign, nonatomic) BOOL closeOnComplete;


+ (instancetype)playerInController:(UIViewController *)viewController;

+ (instancetype)playerWithURL:(NSURL *)url title:(NSString *)title inController:(UIViewController *)viewController;

@end
