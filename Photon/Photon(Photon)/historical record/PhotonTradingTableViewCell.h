//
//  PhotonTradingTableViewCell.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/1.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotonTradingTableViewCell : UITableViewCell
+(instancetype)initPhotonTradingTableViewCellTableViewCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *photonTime;
@property (weak, nonatomic) IBOutlet UILabel *photonType;
@property (weak, nonatomic) IBOutlet UILabel *photonNote;
@property (weak, nonatomic) IBOutlet UILabel *photonAddress;
@property (weak, nonatomic) IBOutlet UILabel *photonTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *photonTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *photonNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *photonAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *photonAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *photonLine;
@end
