//
//  RRaidenChannelModel.h
//  FireFly
//
//  Created by RDP on 2018/5/9.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRaidenChannelModel : NSObject

@property (nonatomic, strong) NSString *channel_address;
@property (nonatomic, strong) NSString *partner_address;
@property (nonatomic, strong) NSString *token_address;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *settle_timeout;

@end
