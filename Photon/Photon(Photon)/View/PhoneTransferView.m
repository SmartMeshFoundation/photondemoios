//
//  PhoneTransferView.m
//  FireFly
//
//  Created by 薛海新 on 2019/5/23.
//  Copyright © 2019 NAT. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "PhoneTransferView.h"

@implementation PhoneTransferView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.5f];
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0x1B272B);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    self.transferCell = [PhoneTransferTableViewCell initPhoneTransferTableViewCelllTableViewCell:tableView];
    self.transferCell.transferCellAddressLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"partner_address"]];
    return self.transferCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [self.delegate didpushAddress:[NSString stringWithFormat:@"%@",[dict objectForKey:@"partner_address"]]];
}
@end
