//
//  SupplementTableViewCell.h
//  FireFly
//
//  Created by 薛海新 on 2019/3/4.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplementTableViewCell : UITableViewCell
+(instancetype)initSupplementTableViewCellTableViewCell:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *supplementTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplementTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplementAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplementTime;
@property (weak, nonatomic) IBOutlet UILabel *supplementType;
@property (weak, nonatomic) IBOutlet UILabel *supplementAmount;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@end
