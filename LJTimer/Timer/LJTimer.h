//
//  LJTimer.h
//  LJTimer
//
//  Created by 李佳 on 2020/5/11.
//  Copyright © 2020 李佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJTimer : NSObject

@property (strong, nonatomic) dispatch_source_t source;
@property (strong, nonatomic) dispatch_queue_t queue;
@property (nonatomic) BOOL isRunning;
@property (assign, nonatomic) NSUInteger totalData;
@property (assign, nonatomic) dispatch_time_t delayTime;
@property (assign, nonatomic) dispatch_time_t seconds;
@property (copy, nonatomic)  void(^endComplete)(void);
 

- (void)startAt: (dispatch_time_t)delay seconds: (dispatch_time_t)seconds success: (void(^)(void))success progress: (void(^)(NSUInteger value))progress complete: (void(^)(void))complete;

- (void)suspend: (void(^)(void))complete;
- (void)resume:(void(^)(void))complete;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
