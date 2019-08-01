//
//  RChannelToastTableViewCell.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/6.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RChannelToastTableViewCell : UITableViewCell
+(instancetype)initRChannelRChannelToastTableViewCellTableViewCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastSyselLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIButton *waitingImageButton;

@property (weak, nonatomic) IBOutlet UIButton *errerImageButton;

@end
