//
//  NATModel.m
//  NAToken
//
//  Created by Megan on 17/8/2.
//  Copyright © 2017 SmartMesh Foundation All rights reserved.
//

#import "NATModel.h"

@implementation NATModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.logo = dict[@"logo"];
        self.symbol = dict[@"symbol"];
        self.token_address = dict[@"token_address"];
        self.price = dict[@"price"];
        self.balance = dict[@"balance"];
    }
    return self;
}

@end
