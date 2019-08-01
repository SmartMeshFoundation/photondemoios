//
//  ChannelTableViewCell.h
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/11.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *channelPartnerAddress;
@property (weak, nonatomic) IBOutlet UILabel *channelValue;

@property (weak, nonatomic) IBOutlet UILabel *channelPartnerAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *channelAddButton;
@property (weak, nonatomic) IBOutlet UIButton *channelWithdrawalButton;
@property (weak, nonatomic) IBOutlet UIButton *channelShutDownButton;
@property (weak, nonatomic) IBOutlet UIView *channelButtonView;
@property (weak, nonatomic) IBOutlet UILabel *channelSysmelLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelTImeLabel;

@property (nonatomic, copy) void(^channelAddBlock)(void);
@property (nonatomic, copy) void(^channelWithdrawalBlock)(void);
@property (nonatomic, copy) void(^channelShutDownBlock)(void);

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIButton *waitingImageButton;

@property (weak, nonatomic) IBOutlet UIButton *errerImageButton;


@property (weak, nonatomic) IBOutlet UIImageView *rollOutImageView;
@property (weak, nonatomic) IBOutlet UIImageView *intoImageVIew;


+(instancetype)initChannelTableViewCellTableViewCell:(UITableView *)tableView;
@end
