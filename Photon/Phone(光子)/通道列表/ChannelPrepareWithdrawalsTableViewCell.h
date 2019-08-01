//
//  ChannelPrepareWithdrawalsTableViewCell.h
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/18.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelPrepareWithdrawalsTableViewCell : UITableViewCell
+(instancetype)initChannelPrepareWithdrawalsTableViewCellTableViewCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *partnerAddress;
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsAmount;
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsToastLabel;

@property (weak, nonatomic) IBOutlet UIView *withdrawalsBgView;
@property (weak, nonatomic) IBOutlet UILabel *partnerAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsCancleButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsRetryButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsClosedButton;
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsTypeLabel;


@property (nonatomic, copy) void(^withdrawalsCancleBlock)(void);
@property (nonatomic, copy) void(^withdrawalsRetryBlock)(void);
@property (nonatomic, copy) void(^withdrawalsClosedBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

/////关闭
@property (nonatomic, copy) void(^shutDownwithdrawalsCancleBlock)(void);
@property (nonatomic, copy) void(^shutDownwithdrawalsRetryBlock)(void);
//@property (nonatomic, copy) void(^shutDownwithdrawalsClosedBlock)(void);

@end
