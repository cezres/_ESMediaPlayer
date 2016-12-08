//
//  ESMediaProgressHUD.h
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/8.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESMediaProgressHUD : UIVisualEffectView

+ (instancetype)showHUDWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;

+ (void)hidden;

@end
