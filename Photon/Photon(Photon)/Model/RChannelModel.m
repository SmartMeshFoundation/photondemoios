//
//  RChannelModel.m
//  FireFly
//
//  Created by RDP on 2018/5/8.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "RChannelModel.h"
#define NORMAL_CHANNEL_HEIGHT 135

RChannelState RChannelStateValueOf(NSString *text){
    if (text) {
        if ([text isEqualToString:@"open"]) {
            return RChannelState_StateOpened;
        }
        if ([text isEqualToString:@"close"]) {
            return RChannelState_StateClosed;
        }
    }
    return -1;
}

NSString* RChannelStateDescription(RChannelState value){
    switch (value) {
        case RChannelState_StateOpened:
            
            return @"open";
        case RChannelState_StateClosed:
            
            return @"close";
        case RChannelState_StateSettled:
            
            return @"settle";

        default:
            return @"open";
    }
}

@implementation RChannelModel

- (float)cellHeight
{
    if (self.state.integerValue==RChannelState_StateOpened) {
        _cellHeight = NORMAL_CHANNEL_HEIGHT + 50;
    }else {
        _cellHeight = NORMAL_CHANNEL_HEIGHT;
    }
    
    return _cellHeight;
}

@end
