//
//  ViewController.m
//  ESMediaPlayerDemo
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ViewController.h"
#import "ESMediaPlayer.h"

#import "TestViewController.h"

@interface ViewController ()

@property (strong, nonatomic) ESMediaPlayerView *player;

@property (strong, nonatomic) NSArray<NSURL *> *urls;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addURLsWithExtension:@"mp3"];
    [self addURLsWithExtension:@"mp4"];
    [self addURLsWithExtension:@"flv"];
    
    [self.view addSubview:self.player];
    
    [self.player play:[NSURL URLWithString:@"http://dianbo.wsdemo.zego.im/livestream-zegotest-2873169708-LVSID16121481622492980--20161213174722.m3u8"]];
    
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
}
- (IBAction)stop:(id)sender {
//    [_player stop];
    
    ESMediaPlayerViewController *player = [ESMediaPlayerViewController playerInController:self];
    [player.playerView play:_urls.firstObject];
    
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
