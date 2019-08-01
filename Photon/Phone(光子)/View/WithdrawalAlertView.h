//
//  WithdrawalAlertView.h
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/5/8.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalAlertView : UIView
@property (weak, nonatomic) IBOutlet UIButton *withdrawalAlertCancleButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalAlertShutDown;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
