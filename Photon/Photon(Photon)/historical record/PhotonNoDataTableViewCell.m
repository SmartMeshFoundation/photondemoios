//
//  PhotonNoDataTableViewCell.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/1.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "PhotonNoDataTableViewCell.h"

@implementation PhotonNoDataTableViewCell

+(instancetype)initPhotonNoDataTableViewCellTableViewCell:(UITableView *)tableView
{
    PhotonNoDataTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotonNoDataTableViewCell" owner:nil options:nil] lastObject];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.cellZhuanzLabel.textColor = UIColorFromRGB(0x333333);
    //    cell.cellDateLabel.textColor = UIColorFromRGB(0x585F6F);
    //    cell.cellValueLabel.textColor = UIColorFromRGB(0x48AB5D);
    //    cell.celltypeLabel.textColor = UIColorFromRGB(0x585F6F);
    cell.backgroundColor = BGCOLOT;
    cell.nodataTime.textColor = UIColorFromRGB(0xBAFFEC);
    cell.nodataType.textColor = UIColorFromRGB(0xBAFFEC);
    
    cell.nodataAmountLabel.textColor = BGTEXT;
    cell.nodataTypeLabel.textColor = BGTEXT;
    cell.nodataTimeLabel.textColor = BGTEXT;

    cell.nodataAddress.textColor = UIColorFromRGB(0xBAFFEC);
    cell.nodataAddressLabel.textColor = UIColorFromRGB(0xBAFFEC);

    cell.nodataTime.text = DDYLocalStr(@"hometime");
    cell.nodataType.text = DDYLocalStr(@"hometype");
    cell.nodataAddress.text = DDYLocalStr(@"addAddress");
    cell.nodataNumber.textColor = UIColorFromRGB(0xBAFFEC);
    cell.nodataNumber.text = DDYLocalStr(@"homenumber");

    cell.nodataLine.backgroundColor = BUTTONBGCOLOR;
    cell.nodataAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
