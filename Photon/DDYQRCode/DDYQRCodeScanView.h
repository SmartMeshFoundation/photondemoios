//
//  DDYQRCodeScanView.h
//  DDYProject
//
//  Created by Megan on 17/8/8.
//  Copyright © 2017 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDYQRCodeManager.h"

#define DDYSCREENBOUNDS [UIScreen mainScreen].bounds

@interface DDYQRCodeScanView : UIView

+ (instancetype)scanView;

- (void)startScanningLingAnimation;

- (void)stopScanningLingAnimation;

@end
