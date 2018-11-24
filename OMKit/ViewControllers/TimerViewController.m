//
//  TimerViewController.m
//  OMKit
//
//  Created by 幸福的小木子 on 2018/11/24.
//  Copyright © 2018年 oymuzi. All rights reserved.
//

#import "TimerViewController.h"
#import "OMTimer.h"

@interface TimerViewController ()

/** 计时器*/
@property (nonatomic, strong) OMTimer *timer;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 200, self.view.frame.size.width, 200);
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    NSArray *titles = @[@"启动", @"暂停", @"继续", @"重置"];
    for (int i=0; i<=3; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        CGFloat btnW = self.view.frame.size.width/4;
        CGFloat btnH = 40;
        btn.frame = CGRectMake(btnW*i, 100, btnW, btnH);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self action:@selector(opration:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    self.timer = [[OMTimer alloc] init];
    self.timer.timerInterval = 30;
    self.timer.precision = 100;
    self.timer.isAscend = NO;
    self.timer.progressBlock = ^(OMTime *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = [NSString stringWithFormat:@"%@:%@:%@:%@", progress.hour, progress.minute, progress.second, progress.millisecond];
        });
    };
    self.timer.completion = ^{
        NSLog(@"complete done!");
    };
    
}

- (void)opration: (UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self.timer resume];
            break;
        case 1:
            [self.timer suspend];
            break;
        case 2:
            [self.timer activate];
            break;
        case 3:
            [self.timer restart];
            break;
            
        default:
            break;
    }
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
