//
//  ViewController.m
//  GCD调度
//
//  Created by 中发 on 2018/6/14.
//  Copyright © 2018年 中发. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self group1];
    [self group2];
}
/**
 1.调度组没有任务，直接执行notify
 2.入组多余出组，notify永远不会执行，因为组永远不会为空
 3.出组多余入组，会崩溃
 */
- (void)group2 {
    //创建调度组
    dispatch_group_t group = dispatch_group_create();
    //队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //调度组
        //入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
       NSLog(@"download A ,%@", [NSThread currentThread]);
        //出组
        dispatch_group_leave(group);
    });
        //入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"download B ,%@", [NSThread currentThread]);
        //出组
        dispatch_group_leave(group);
    });
    //监听
    dispatch_group_notify(group, queue, ^{
        NSLog(@"come here");
    });
    
}

/**
 调度组最重要的目的，监听任务完成
 */
- (void)group1 {
    //创建调度组
    dispatch_group_t group = dispatch_group_create();
    //队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //调度组监听队列调度任务
    dispatch_async(queue, ^{
        NSLog(@"download A ,%@", [NSThread currentThread]);
    });

    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"download B ,%@", [NSThread currentThread]);
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"come here");
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
