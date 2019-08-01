//
//  ChannelDefaultTableViewCell.m
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/12.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import "ChannelDefaultTableViewCell.h"

@implementation ChannelDefaultTableViewCell

+(instancetype)initChannelDefaultTableViewCellTableViewCell:(UITableView *)tableView
{
    ChannelDefaultTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChannelDefaultTableViewCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
//    cell.toastAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
//    cell.addressLabel.text = LocalizedString(@"对方");
//    cell.amountLabel.text = LocalizedString(@"余额");
    
    return cell;
}

@end
