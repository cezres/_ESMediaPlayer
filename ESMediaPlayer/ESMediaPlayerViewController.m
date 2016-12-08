//
//  ESMediaPlayerViewController.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/2.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESMediaPlayerViewController.h"

@interface ESMediaPlayerViewController ()

@property (strong, nonatomic) UIVisualEffectView *topView;

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
    [self.view addSubview:self.topView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _playerView.frame = self.view.bounds;
    _topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onClickBack {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIVisualEffectView *)topView {
    if (!_topView) {
        _topView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"hd_idct_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(10, (44-26)/2, 26, 26);
        [_topView addSubview:backButton];
    }
    return _topView;
}

@end
