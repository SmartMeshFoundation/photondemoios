//
//  NSTimer+DDYExtension.h
//  DDYProject
//
//  Created by SmartMesh on 2018/3/29.
//  Copyright © 2018年 Starain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (DDYExtension)

+ (NSTimer *)ddy_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end
