//
//  CreateViewController.h
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/12.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateViewController : UIViewController
@property (nonatomic, strong) NATModel *itemCurrent;///类别
@property (nonatomic, strong) NSDictionary *aumontDict;///类别
@property (nonatomic,strong)NSString *amountValueStr;
@property (nonatomic,strong)NSArray *arrayBlace;
@property (nonatomic,strong)NSString *tokenAddressString;///smt&mesh

@end
