//
//  ChannelController.h
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/11.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelController : UIViewController
@property (nonatomic,strong)NSString *isSmt;
@property (nonatomic,strong)NSDictionary *amountDict;
@property (nonatomic,strong)NSString *amountValueStr;
@property (nonatomic, strong) NATModel *itemCurrent;///类别


@end
