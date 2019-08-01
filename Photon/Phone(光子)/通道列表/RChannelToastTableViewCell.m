//
//  RChannelToastTableViewCell.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/6.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "RChannelToastTableViewCell.h"

@implementation RChannelToastTableViewCell

+(instancetype)initRChannelRChannelToastTableViewCellTableViewCell:(UITableView *)tableView
{
    RChannelToastTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RChannelToastTableViewCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    cell.toastAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.addressLabel.text = DDYLocalStr(@"addAddress");
    cell.amountLabel.text = DDYLocalStr(@"channebalance");

    cell.toastSyselLabel.textColor = BGTEXT;
    cell.beizhu.textColor = UIColorFromRGB(0xBAFFEC);
    cell.addressLabel.textColor = UIColorFromRGB(0xBAFFEC);
    cell.amountLabel.textColor = UIColorFromRGB(0xBAFFEC);
    cell.toastTimeLabel.textColor = UIColorFromRGB(0xBAFFEC);

    cell.toastAddressLabel.textColor = UIColorFromRGB(0xD7E6E2);
    cell.toastTypeLabel.textColor = UIColorFromRGB(0xD7E6E2);
    cell.toastAmountLabel.textColor = UIColorFromRGB(0xD7E6E2);

    cell.toastLabel.textColor = UIColorFromRGB(0xDDC890);
    cell.lineLabel.backgroundColor = BUTTONBGCOLOR;
    return cell;
}

@end
