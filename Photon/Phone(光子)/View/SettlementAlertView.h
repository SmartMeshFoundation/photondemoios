//
//  SettlementAlertView.h
//  FireFly
//
//  Created by 薛海新 on 2019/5/19.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *settlementTitle;
@property (weak, nonatomic) IBOutlet UILabel *settlementText;
@property (weak, nonatomic) IBOutlet UIButton *settlementCancleButton;
@property (weak, nonatomic) IBOutlet UIButton *settlementButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
