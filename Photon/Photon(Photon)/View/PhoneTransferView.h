//
//  PhoneTransferView.h
//  FireFly
//
//  Created by 薛海新 on 2019/5/23.
//  Copyright © 2019 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneTransferTableViewCell.h"
@protocol transferCellDelegate <NSObject>

///协议 传送点击的第几个button
- (void)didpushAddress:(NSString *)addressText;

@end
@interface PhoneTransferView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,weak)id <transferCellDelegate>delegate;

@property(nonatomic,strong)PhoneTransferTableViewCell *transferCell;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end
