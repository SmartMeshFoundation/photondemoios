//
//  PhotonTradingTableViewCell.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/1.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "PhotonTradingTableViewCell.h"

@implementation PhotonTradingTableViewCell

+(instancetype)initPhotonTradingTableViewCellTableViewCell:(UITableView *)tableView
{
    PhotonTradingTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotonTradingTableViewCell" owner:nil options:nil] lastObject];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.cellZhuanzLabel.textColor = UIColorFromRGB(0x333333);
//    cell.cellDateLabel.textColor = UIColorFromRGB(0x585F6F);
//    cell.cellValueLabel.textColor = UIColorFromRGB(0x48AB5D);
//    cell.celltypeLabel.textColor = UIColorFromRGB(0x585F6F);
    cell.backgroundColor = BGCOLOT;

    cell.photonAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.photonNote.textColor = UIColorFromRGB(0xBAFFEC);
    cell.photonType.textColor = UIColorFromRGB(0xBAFFEC);
    cell.photonTime.textColor = UIColorFromRGB(0xBAFFEC);
    cell.photonAddress.textColor = UIColorFromRGB(0xBAFFEC);
    cell.phoneNumber.textColor = UIColorFromRGB(0xBAFFEC);

    cell.photonTimeLabel.textColor = BGTEXT;
    cell.photonTypeLabel.textColor = BGTEXT;
    cell.photonNoteLabel.textColor = BGTEXT;
    cell.photonAddressLabel.textColor = UIColorFromRGB(0xBAFFEC);
    cell.photonAmountLabel.textColor = BGTEXT;

    cell.photonTime.text = DDYLocalStr(@"hometime");
    cell.photonType.text = DDYLocalStr(@"hometype");
    cell.photonNote.text = DDYLocalStr(@"creaternote");
    cell.photonAddress.text = DDYLocalStr(@"addAddress");
    cell.phoneNumber.text = DDYLocalStr(@"homenumber");

    cell.photonLine.backgroundColor = BUTTONBGCOLOR;


cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
