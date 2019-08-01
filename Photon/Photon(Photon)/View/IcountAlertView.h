//
//  IcountAlertView.h
//  FireFly
//
//  Created by 薛海新 on 2019/5/31.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IcountAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *extractToastLabel;
@property (weak, nonatomic) IBOutlet UIButton *extracetCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *extracetDetermineButton;
@property (weak, nonatomic) IBOutlet UILabel *extractLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
