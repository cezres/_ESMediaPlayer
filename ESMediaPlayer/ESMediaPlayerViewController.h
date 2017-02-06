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

+ (instancetype)playerInController:(UIViewController *)viewController;

+ (instancetype)play:(NSURL *)url title:(NSString *)title inController:(UIViewController *)viewController;

@end
