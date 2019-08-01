//
//  RChannelShutDownTableViewCell.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/6.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "RChannelShutDownTableViewCell.h"

@implementation RChannelShutDownTableViewCell



+(instancetype)initRChannelShutDownTableViewCellTableViewCell:(UITableView *)tableView
{
    RChannelShutDownTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RChannelShutDownTableViewCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellStyleDefault;
    cell.backgroundColor = BGCOLOT;
    cell.shutDownAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.nameLabel.text = DDYLocalStr(@"addAddress");
    cell.valueLabel.text = DDYLocalStr(@"channeletremaining");
    cell.shutDownButton.layer.cornerRadius = 4.0f;
//    cell.shutDownButton.layer.borderColor = UIColorFromRGB(0x3F7AE0).CGColor;
//    cell.shutDownButton.layer.borderWidth = 0.5;
    cell.shutDownSyselLabel.textColor = BGTEXT;
    cell.shutDownTimeLabel.textColor = UIColorFromRGB(0xBAFFEC);

    cell.shutBeizhu.textColor = UIColorFromRGB(0xBAFFEC);
    cell.nameLabel.textColor = UIColorFromRGB(0xBAFFEC);
    cell.valueLabel.textColor = UIColorFromRGB(0xBAFFEC);

    cell.shutDownTypeLabel.textColor = UIColorFromRGB(0xD7E6E2);
    cell.shutDownAddressLabel.textColor = UIColorFromRGB(0xD7E6E2);
    cell.shutDownAmountLabel.textColor = UIColorFromRGB(0xD7E6E2);

    cell.shutToastLabel.textColor = UIColorFromRGB(0xDDC890);
    [cell.shutDownButton setBackgroundColor:UIColorFromRGB(0x1B272B)];
    [cell.shutDownButton setTitleColor:UIColorFromRGB(0xDDC890) forState:UIControlStateNormal];

    cell.lineLabel.backgroundColor = BUTTONBGCOLOR;
    return cell;
}
- (IBAction)settlementButtonClick:(id)sender {
    if(self.shutDownClickBlock){
        self.shutDownClickBlock();
    }
}


@end
