//
//  ChannelTableViewCell.m
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/11.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import "ChannelTableViewCell.h"

@implementation ChannelTableViewCell

+(instancetype)initChannelTableViewCellTableViewCell:(UITableView *)tableView
{
    ChannelTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChannelTableViewCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellStyleDefault;
    cell.backgroundColor = BGCOLOT;
    cell.channelPartnerAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.channelPartnerAddress.text = DDYLocalStr(@"photonAddress");
    cell.channelValue.text = DDYLocalStr(@"channeletremaining");
//    [cell.channelAddButton addTarget:self action:@selector(channelAddButtonClicklll) forControlEvents:UIControlEventTouchUpInside];
    cell.channelButtonView.layer.cornerRadius = 4.0f;
//    cell.channelButtonView.layer.borderColor = UIColorFromRGB(0x3F7AE0).CGColor;
//    cell.channelButtonView.layer.borderWidth = 0.5;
    
    
    cell.channelPartnerAddress.textColor = UIColorFromRGB(0xBAFFEC);
    cell.channelValue.textColor = UIColorFromRGB(0xBAFFEC);
    cell.channelTImeLabel.textColor = UIColorFromRGB(0xBAFFEC);
    cell.channelSysmelLabel.textColor = BGTEXT;

    cell.channelPartnerAddressLabel.textColor = UIColorFromRGB(0xD7E6E2);
    cell.channelValueLabel.textColor = UIColorFromRGB(0xD7E6E2);

    
    [cell.channelAddButton setBackgroundColor:UIColorFromRGB(0x1B272B)];
    [cell.channelAddButton setTitleColor:UIColorFromRGB(0xDDC890) forState:UIControlStateNormal];
    [cell.channelWithdrawalButton setBackgroundColor:UIColorFromRGB(0x1B272B)];
    [cell.channelWithdrawalButton setTitleColor:UIColorFromRGB(0xDDC890) forState:UIControlStateNormal];
    [cell.channelShutDownButton setBackgroundColor:UIColorFromRGB(0x1B272B)];
    [cell.channelShutDownButton setTitleColor:UIColorFromRGB(0xDDC890) forState:UIControlStateNormal];
    cell.lineLabel.backgroundColor = BUTTONBGCOLOR;
    
    
    [cell.channelAddButton setTitle:DDYLocalStr(@"addChainadd") forState:UIControlStateNormal];
    [cell.channelWithdrawalButton setTitle:DDYLocalStr(@"withdrawallogin") forState:UIControlStateNormal];
    [cell.channelShutDownButton setTitle:DDYLocalStr(@"close") forState:UIControlStateNormal];

//
//    @property (weak, nonatomic) IBOutlet UILabel *;
//    @property (weak, nonatomic) IBOutlet UILabel *;
//    @property (weak, nonatomic) IBOutlet UIButton *;
//    @property (weak, nonatomic) IBOutlet UIButton *;
//    @property (weak, nonatomic) IBOutlet UIButton *;
//    @property (weak, nonatomic) IBOutlet UIView *channelButtonView;
//    @property (weak, nonatomic) IBOutlet UILabel *channelSysmelLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *channelTImeLabel;

    return cell;
}
/////补充
- (IBAction)addButtonClick:(id)sender {
    if (self.channelAddBlock) {
        self.channelAddBlock();
    }
}
- (IBAction)withdrawalButtonClick:(id)sender {
    if(self.channelWithdrawalBlock){
        self.channelWithdrawalBlock();
    }
}

- (IBAction)shutDownButtonClick:(id)sender {
    if(self.channelShutDownBlock){
        self.channelShutDownBlock();
    }
}



@end
