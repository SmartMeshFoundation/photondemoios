//
//  SpectrumTradingTableViewCell.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/1.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpectrumTradingTableViewCell : UITableViewCell
+(instancetype)initSpectrumTradingTableViewCellTableViewCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumTime;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumType;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumAddress;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpectrumAmount;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
