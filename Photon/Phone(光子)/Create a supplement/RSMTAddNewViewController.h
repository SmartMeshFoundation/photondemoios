//
//  RSMTAddNewViewController.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/28.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RChannelModel.h"
#import "RChannelModel.h"

@interface RSMTAddNewViewController : UIViewController
@property (nonatomic, strong) RChannelModel *channel;
@property (nonatomic, strong) NATModel *itemCurrent;///类别
@property (nonatomic, strong) NSDictionary *aumontDict;///类别
@property (nonatomic,strong)NSString *amountValueStr;


@end
