//
//  TestViewController.m
//  ESMediaPlayer
//
//  Created by 翟泉 on 2016/12/8.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "TestViewController.h"

@interface TestObject : NSObject

@property (strong, nonatomic) id obj;

@end

@implementation TestObject

@end


@interface WeakObject : NSObject

@property (weak, nonatomic) id weakObject;

@end

@implementation WeakObject

+ (instancetype)object:(id)object {
    WeakObject *weakObject = [[WeakObject alloc] init];
    weakObject.weakObject = object;
    return weakObject;
}

@end



@interface TestViewController ()

@property (strong, nonatomic) TestObject *obj;

@property (strong, nonatomic) void (^block)(void);

@end

@implementation TestViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    __weak typeof(self) weakself = self;
    
    NSString *sss = @"xxxxx";;
    
    [self setBlock:^{
        NSLog(@"%@", sss);
        NSLog(@"%@", weakself);
    }];
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!weakself) {
            return;
        }
//        weakself.block();
        void (^xxxx)(void) = weakself.block;
        xxxx();
        
        
    });
    
    
//    _obj = [[TestObject alloc] init];
//    _obj.obj = [WeakObject object:self];
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
