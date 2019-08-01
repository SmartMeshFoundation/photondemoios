//
//  SpectrumTradingTableViewCell.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/1.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "SpectrumTradingTableViewCell.h"

@implementation SpectrumTradingTableViewCell

+(instancetype)initSpectrumTradingTableViewCellTableViewCell:(UITableView *)tableView
{
    SpectrumTradingTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SpectrumTradingTableViewCell" owner:nil options:nil] lastObject];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.cellZhuanzLabel.textColor = UIColorFromRGB(0x333333);
    //    cell.cellDateLabel.textColor = UIColorFromRGB(0x585F6F);
    //    cell.cellValueLabel.textColor = UIColorFromRGB(0x48AB5D);
    //    cell.celltypeLabel.textColor = UIColorFromRGB(0x585F6F);
    cell.backgroundColor = BGCOLOT;

    cell.SpectrumTime.text = DDYLocalStr(@"hometime");
    cell.SpectrumType.text = DDYLocalStr(@"hometype");
    cell.SpectrumAddress.text = DDYLocalStr(@"addAddress");
    cell.SpectrumAmount.text = DDYLocalStr(@"channebalance");
    cell.SpectrumTime.textColor = UIColorFromRGB(0xBAFFEC);
    cell.SpectrumType.textColor = UIColorFromRGB(0xBAFFEC);
    cell.SpectrumAddress.textColor = UIColorFromRGB(0xBAFFEC);
    cell.SpectrumAmount.textColor = UIColorFromRGB(0xBAFFEC);
    cell.SpectrumAddressLabel.textColor = UIColorFromRGB(0xBAFFEC);

    cell.SpectrumTimeLabel.textColor = BGTEXT;
    cell.SpectrumTypeLabel.textColor = BGTEXT;
    cell.SpectrumAmountLabel.textColor = BGTEXT;
cell.lineLabel.backgroundColor = BUTTONBGCOLOR;
    cell.SpectrumAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.SpectrumAmountLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
