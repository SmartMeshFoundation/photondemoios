//
//  PhoneTransferTableViewCell.m
//  FireFly
//
//  Created by 薛海新 on 2019/5/23.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "PhoneTransferTableViewCell.h"

@implementation PhoneTransferTableViewCell

+(instancetype)initPhoneTransferTableViewCelllTableViewCell:(UITableView *)tableView
{
    PhoneTransferTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PhoneTransferTableViewCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellStyleDefault;
    cell.backgroundColor = UIColorFromRGB(0x1B272B);
    cell.transferCellAddressLabel.textColor = BGTEXT;
    cell.transferCellAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return cell;
}

@end
