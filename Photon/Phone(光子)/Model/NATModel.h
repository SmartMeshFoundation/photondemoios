//
//  NATModel.h
//  NAToken
//
//  Created by Megan on 17/8/2.
//  Copyright © 2017 SmartMesh Foundation All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NATModel : NSObject

@property (nonatomic, strong) NSString *logo;

@property (nonatomic, strong) NSString *symbol;

@property (nonatomic, strong) NSString *token_address;

@property (nonatomic, strong) NSString *name;
/* token预计市值(总价)¥ */
@property (nonatomic, strong) NSString *price;
/* token的单价¥ */
@property (nonatomic, strong) NSString *unit_price;

/* token预计市值(总价)$ */
@property (nonatomic, strong) NSString *usd_price;
/* token的单价$ */
@property (nonatomic, strong) NSString *usd_unit_price;

/* 余额 */
@property (nonatomic, strong) NSString *balance;

@property (nonatomic, strong) NSString *is_open;

@property (nonatomic, strong) NSString *fixed;
/* 0 删除默认展示token 1 新增默认展示token 2 修改token信息*/
@property (nonatomic, strong) NSString *state;

/** 该属性,禁止🚫使用(只在接收新币时使用) */
@property (nonatomic, strong) NSString *walletAddress;

- (id)initWithDict:(NSDictionary *)dict;

@end
