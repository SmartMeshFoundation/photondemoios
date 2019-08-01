//
//  RChannelShutDownTableViewCell.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/6.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RChannelShutDownTableViewCell : UITableViewCell
+(instancetype)initRChannelShutDownTableViewCellTableViewCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *shutDownButton;
@property (weak, nonatomic) IBOutlet UILabel *shutDownAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutDownAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutToastLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutDownSyselLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutDownTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutBeizhu;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *shutDownTypeLabel;
@property(nonatomic,copy) void(^shutDownClickBlock)(void);


@property (weak, nonatomic) IBOutlet UIButton *waitingImageButton;

@property (weak, nonatomic) IBOutlet UIButton *errerImageButton;

@end
