//
//  ChannelPrepareWithdrawalsTableViewCell.m
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/18.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import "ChannelPrepareWithdrawalsTableViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ChannelPrepareWithdrawalsTableViewCell

+(instancetype)initChannelPrepareWithdrawalsTableViewCellTableViewCell:(UITableView *)tableView
{
    ChannelPrepareWithdrawalsTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChannelPrepareWithdrawalsTableViewCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
//    cell.channelPartnerAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
//    cell.channelPartnerAddress.text = LocalizedString(@"地址");
//    cell.channelValue.text = LocalizedString(@"剩余");
//    //    [cell.channelAddButton addTarget:self action:@selector(channelAddButtonClicklll) forControlEvents:UIControlEventTouchUpInside];
//    cell.channelButtonView.layer.cornerRadius = 4.0f;
//    cell.channelButtonView.layer.borderColor = UIColorFromRGB(0x3F7AE0).CGColor;
//    cell.channelButtonView.layer.borderWidth = 0.5;
    cell.withdrawalsBgView.layer.cornerRadius = 4.0f;
    cell.withdrawalsBgView.layer.borderColor = UIColorFromRGB(0x3F7AE0).CGColor;
    cell.withdrawalsBgView.layer.borderWidth = 0.5;
cell.lineLabel.backgroundColor = BUTTONBGCOLOR;
    return cell;
}

- (IBAction)withdrawalsCancleButtonClick:(id)sender {
    UIButton *but = sender;
    if(but.tag == 9012){////关闭
        
        if(self.shutDownwithdrawalsCancleBlock){
            self.shutDownwithdrawalsCancleBlock();
        }
        
    }else{////提现
        if(self.withdrawalsCancleBlock){
            self.withdrawalsCancleBlock();
        }
    }
}
- (IBAction)withdrawalsRetryButtonClick:(UIButton *)sender {
    if(sender.tag == 9014){
        if(self.shutDownwithdrawalsRetryBlock){
            self.shutDownwithdrawalsRetryBlock();
        }
    }else{
        if(self.withdrawalsRetryBlock){
            self.withdrawalsRetryBlock();
        }
    }
    
}
- (IBAction)withdrawalsClosedButtonClick:(id)sender {
    if(self.withdrawalsClosedBlock){
        self.withdrawalsClosedBlock();
    }
}

@end
