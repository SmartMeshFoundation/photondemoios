//
//  NSObject+AlertText.h
//  NAToken
//
//  Created by Megan on 2017/9/2.
//  Copyright © 2017 SmartMesh Foundation All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface NSObject (AlertText)

- (MBProgressHUD *)showHudWithText:(NSString *)text;

/** 适合此工程的hud(一个转圈加载和一个提示) */
- (MBProgressHUD *)ff_HudText:(NSString *)text isLoading:(BOOL)isLoading hideDelay:(NSTimeInterval)delay;

@end
