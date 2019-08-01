//
//  NAQRCodeScanningVC.h
//  NAQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017 kingsic. All rights reserved.
//

#import "NAQRCodeScanningVC.h"

@interface NAQRCodeScanningVC : UIViewController

@property(nonatomic, copy) void(^qrMessageBlock)(NSString *value);


@property(nonatomic,strong)NSString *strType;

@end

