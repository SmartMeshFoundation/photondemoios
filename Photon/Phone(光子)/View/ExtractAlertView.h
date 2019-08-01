//
//  ExtractAlertView.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/4.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtractAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *extractToastLabel;
@property (weak, nonatomic) IBOutlet UIButton *extracetCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *extracetDetermineButton;
@property (weak, nonatomic) IBOutlet UILabel *extractLabel;

@end
