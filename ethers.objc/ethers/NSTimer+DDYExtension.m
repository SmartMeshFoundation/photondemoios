//
//  NSTimer+DDYExtension.m
//  DDYProject
//
//  Created by SmartMesh on 2018/3/29.
//  Copyright © 2018年 Starain. All rights reserved.
//

#import "NSTimer+DDYExtension.h"

@implementation NSTimer (DDYExtension)

+ (NSTimer *)ddy_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    if (@available(iOS 10.0, *)) {
        return [self scheduledTimerWithTimeInterval:interval repeats:repeats block:^(NSTimer * _Nonnull timer) { block(timer); }];
    } else {
        return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(ddy_timerInvoke:) userInfo:[block copy] repeats:repeats];
    }
}

+ (void)ddy_timerInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
