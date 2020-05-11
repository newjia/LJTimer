//
//  ViewController.m
//  LJTimer
//
//  Created by 李佳 on 2020/5/11.
//  Copyright © 2020 李佳. All rights reserved.
//

#import "ViewController.h"
#import "LJTimer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) LJTimer *timer;

@property (assign, nonatomic) BOOL isOn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (LJTimer *)timer{
    if (!_timer) {
        _timer = [[LJTimer alloc] init];
    }
    return _timer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.timer startAt:0 seconds:10 success:^{
        [self.btn setTitle:@"进行中, 点击暂停" forState:UIControlStateNormal];
        
    } progress:^(NSUInteger value) {
        self.statusLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)value, 10];
        self.progress.progress = value / 10.0;
        NSLog(@"还剩多少   %lu/%d", (unsigned long)value, 10);
    }  complete:^{
        NSLog(@"倒计时完成");
        self.statusLabel.text = @"到点了，该起床啦!";
        [self.btn setTitle:@"点击开始" forState:UIControlStateNormal];
    }];
    self.isOn = YES;
}

- (IBAction)suspend:(UIButton *)sender {
    if (self.isOn) {
        [self.timer suspend:^{
            NSLog(@"暂停了");
            self.isOn = NO;
            [self.btn setTitle:@"暂停中, 点击继续" forState:UIControlStateNormal];
        }];
    }else{
        [self.timer resume:^{
            NSLog(@"go on");
            self.isOn = YES;
            [self.btn setTitle:@"进行中, 点击暂停" forState:UIControlStateNormal];
        }];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer cancel];
    
}

@end
