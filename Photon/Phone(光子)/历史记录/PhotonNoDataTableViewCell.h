//
//  PhotonNoDataTableViewCell.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/1.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotonNoDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nodataTime;
@property (weak, nonatomic) IBOutlet UILabel *nodataType;
@property (weak, nonatomic) IBOutlet UILabel *nodataAddress;
@property (weak, nonatomic) IBOutlet UILabel *nodataAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nodataTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nodataTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nodataAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nodataNumber;
@property (weak, nonatomic) IBOutlet UILabel *nodataLine;
+(instancetype)initPhotonNoDataTableViewCellTableViewCell:(UITableView *)tableView;
@end
