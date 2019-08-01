//
//  PhonePassWordView.h
//  FireFly
//
//  Created by 薛海新 on 2019/5/11.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhonePassWordView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneCancleButton;

@end
