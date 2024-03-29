//
//  ViewController.m
//  ESMediaPlayerDemo
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ViewController.h"
#import "ESMediaPlayer.h"

#import "ESMediaPlayerView+Thumbnail.h"

#import "TestViewController.h"

#import <IJKMediaFramework/IJKMediaFramework.h>


@interface ViewController ()

@property (strong, nonatomic) ESMediaPlayerView *player;

@property (strong, nonatomic) NSArray<NSURL *> *urls;


@property (strong, nonatomic) IJKFFMoviePlayerController *ffmPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addURLsWithExtension:@"mp3"];
    [self addURLsWithExtension:@"mp4"];
    [self addURLsWithExtension:@"flv"];
    
    
    [self.view addSubview:self.player];
    
//    [ESMediaPlayerView removeAllThumbnailCached];
    
//    UIImage *image = [ESMediaPlayerView thumbnailImageWithURL:self.urls[2]];
//    NSLog(@"%@", image);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.player play:[NSURL URLWithString:@"https://mvvideo5.meitudata.com/571090934cea5517.mp4"]];
//    });
    
}


- (IBAction)next:(id)sender {
    
    if (![_urls count]) {
        return;
    }
    __block NSInteger currentIndex = -1;
    if (self.player.url) {
        [_urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.absoluteString isEqualToString:self.player.url.absoluteString]) {
                currentIndex = idx;
                *stop = YES;
            }
        }];
        NSInteger nextIndex = currentIndex + 1 == _urls.count ? 0 : currentIndex + 1;
        [_player play:_urls[nextIndex]];
    }
    else {
        [_player play:_urls.firstObject];
    }
    
//    [_player play];
//    _player.currentPlaybackTime = 100;
    
}
- (IBAction)stop:(id)sender {
    if (![_urls count]) {
        return;
    }
    
//    [_player stop];
    
    
//    [_player play:[NSURL URLWithString:@"http://mvvideo5.meitudata.com/571090934cea5517.mp4"]];
    
    
    [ESMediaPlayerViewController playerWithURL:_urls.lastObject title:@"「你的名字」五月天【如果我们不曾相遇】" inController:self];
    
    
//    TestViewController *test = [[TestViewController alloc] init];
//    [self presentViewController:test animated:YES completion:NULL];
    
    
}

- (void)addURLsWithExtension:(NSString *)extension {
    NSArray<NSURL *> *urls = [[NSBundle mainBundle] URLsForResourcesWithExtension:extension subdirectory:NULL];
    if (_urls) {
        _urls = [_urls arrayByAddingObjectsFromArray:urls];
    }
    else {
        _urls = urls;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat height = self.view.bounds.size.width * 0.75;
    if (height > self.view.bounds.size.height) {
        height = self.view.bounds.size.height;
    }
    _player.frame = CGRectMake(0, (self.view.bounds.size.height - height) / 2, self.view.bounds.size.width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (ESMediaPlayerView *)player {
    if (!_player) {
        _player = [[ESMediaPlayerView alloc] init];
    }
    return _player;
}


@end
