//
//  LJTimer.m
//  LJTimer
//
//  Created by 李佳 on 2020/5/11.
//  Copyright © 2020 李佳. All rights reserved.
//

#import "LJTimer.h"
@interface LJT

@end

@implementation LJTimer

 
- (void)startAt: (dispatch_time_t)delay seconds: (dispatch_time_t)seconds success: (void(^)(void))success progress: (void(^)(NSUInteger value))progress complete: (void(^)(void))complete{
    
    if (self.isRunning) {
        return;
    }
    
    self.endComplete = complete;
    self.delayTime = delay;
    self.seconds = seconds;
    self.totalData = 0;
    self.queue = dispatch_queue_create("titi.titi", 0);
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.source, ^{
        NSUInteger value = dispatch_source_get_data(self.source);
        weakSelf.totalData += value;
  
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(seconds - weakSelf.totalData);
        });
    });
    self.isRunning = YES;
    dispatch_resume(self.source);
    dispatch_async(dispatch_get_main_queue(), ^{
        success();
        progress(seconds);

    });
    
    [self begin];
    self.isRunning = TRUE;
}

- (void)begin{
    __weak typeof(self) weakSelf = self;
    NSInteger count = self.seconds;
    for (int i = 0; i < count; i++) {
        dispatch_async(self.queue, ^{
            if (!weakSelf.isRunning) {
                NSLog(@"暂停");
                return;
            }
            sleep(1);
            dispatch_source_merge_data(self.source, 1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (i == count - 1) {
                    if (weakSelf.endComplete) {
                        weakSelf.endComplete();
                    }
                    weakSelf.isRunning = 0;
                    dispatch_source_cancel(self.source);
                    
                }
            });
        });
    }
}

 

- (void)suspend: (void(^)(void))complete{
    if (self.isRunning) {// 正在跑就暂停
        dispatch_suspend(self.source);
        dispatch_suspend(self.queue);// mainqueue 挂起
        self.isRunning = NO;
        complete();
    }
}

- (void)resume:(void(^)(void))complete{
    if (!_isRunning && self.source) {
        dispatch_resume(self.source);
        dispatch_resume(self.queue);
        self.isRunning = YES;
        complete();
    }
}


- (void)cancel{
    if ( !self.source) {
        return;
    }
    if (self.isRunning) {
        self.isRunning = NO ;
    }
    dispatch_source_cancel(self.source);
    
}

- (void)dealloc{
    if (self.isRunning) {
        self.isRunning = NO ;
    }
    NSLog(@"我销毁了");
    dispatch_resume(self.source);
    dispatch_suspend(self.queue);
}

@end
