//
//  PhoneTransferTableViewCell.h
//  FireFly
//
//  Created by 薛海新 on 2019/5/23.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneTransferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *transferCellAddressLabel;
+(instancetype)initPhoneTransferTableViewCelllTableViewCell:(UITableView *)tableView;
@end
