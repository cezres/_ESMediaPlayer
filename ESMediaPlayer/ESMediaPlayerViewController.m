//
//  ESMediaPlayerViewController.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESMediaPlayerViewController.h"
#import "ESMediaPlayerIcon.h"

@interface ESMediaPlayerViewController ()
<ESMediaPlayerCtrlAble>

@property (strong, nonatomic) UIVisualEffectView *topView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backButton;


@end

@implementation ESMediaPlayerViewController

+ (instancetype)playerInController:(UIViewController *)viewController {
    ESMediaPlayerViewController *controller = [[ESMediaPlayerViewController alloc] init];
    [viewController presentViewController:controller animated:YES completion:NULL];
    return controller;
}

- (instancetype)init {
    if (self = [super init]) {
        _playerView = [[ESMediaPlayerView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:_playerView];
    [self.topView addSubview:self.backButton];
    [self.topView addSubview:self.titleLabel];
    [self.view addSubview:self.topView];
    
    [self.playerView addMediaCtrl:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.playerView shutdown];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!CGSizeEqualToSize(self.view.bounds.size, _playerView.bounds.size)) {
        _playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        _backButton.frame = CGRectMake(15, (_topView.bounds.size.height-30)/2, 30, 30);
        CGFloat titleX = 15 + 30 + 15;
        _titleLabel.frame = CGRectMake(titleX, (_topView.bounds.size.height-20), _topView.frame.size.width - titleX - 15, 20);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle; {
    return UIStatusBarStyleLightContent;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


- (void)onClickBack {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ESMediaPlayerCtrlAble
- (void)setCtrlViewHidden:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.transform = CGAffineTransformMakeTranslation(0, -44);
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.transform = CGAffineTransformIdentity;
        }];
    }
}


- (UIVisualEffectView *)topView {
    if (!_topView) {
        _topView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    }
    return _topView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.tintColor = [UIColor whiteColor];
        [_backButton setImage:[ESMediaPlayerIcon iconWithName:@"hd_idct_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end
