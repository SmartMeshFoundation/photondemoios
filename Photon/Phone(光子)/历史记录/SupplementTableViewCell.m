//
//  SupplementTableViewCell.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/4.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "SupplementTableViewCell.h"

@implementation SupplementTableViewCell

+(instancetype)initSupplementTableViewCellTableViewCell:(UITableView *)tableView
{
    SupplementTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SupplementTableViewCell" owner:nil options:nil] lastObject];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.cellZhuanzLabel.textColor = UIColorFromRGB(0x333333);
    //    cell.cellDateLabel.textColor = UIColorFromRGB(0x585F6F);
    //    cell.cellValueLabel.textColor = UIColorFromRGB(0x48AB5D);
    //    cell.celltypeLabel.textColor = UIColorFromRGB(0x585F6F);
    cell.backgroundColor = BGCOLOT;
    cell.supplementTime.textColor = UIColorFromRGB(0xBAFFEC);
    cell.supplementType.textColor = UIColorFromRGB(0xBAFFEC);
    cell.supplementAmount.textColor = UIColorFromRGB(0xBAFFEC);
    
    cell.supplementTimeLabel.textColor = BGTEXT;
    cell.supplementTypeLabel.textColor = BGTEXT;
    cell.supplementAmountLabel.textColor = BGTEXT;

    cell.supplementTime.text = DDYLocalStr(@"hometime");
    cell.supplementType.text = DDYLocalStr(@"hometype");
    cell.supplementAmount.text = DDYLocalStr(@"channebalance");
    cell.lineLabel.backgroundColor = BUTTONBGCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
