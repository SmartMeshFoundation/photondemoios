//
//  NSObject+AlertText.m
//  NAToken
//
//  Created by Megan on 2017/9/2.
//  Copyright © 2017 SmartMesh Foundation All rights reserved.
//

#import "NSObject+AlertText.h"

@implementation NSObject (AlertText)

#pragma mark - 显示提示
- (MBProgressHUD *)showHudWithText:(NSString *)text
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) { keyWindow = [[UIApplication sharedApplication] keyWindow]; }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:keyWindow];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    }
    hud.label.text = text;
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    return hud;
}

#pragma mark - 适合此工程的hud(一个转圈加载和一个提示)
- (MBProgressHUD *)ff_HudText:(NSString *)text isLoading:(BOOL)isLoading hideDelay:(NSTimeInterval)delay {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) { keyWindow = [[UIApplication sharedApplication] keyWindow]; }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:keyWindow];
    if (!hud) { hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES]; }
    hud.contentColor = [UIColor whiteColor];
    if (isLoading) {
        hud.mode = MBProgressHUDModeIndeterminate;
        if (text) {
            hud.label.text = text;
            hud.label.numberOfLines = 0;
        }
    } else {
        hud.label.text = text;
        hud.label.numberOfLines = 0;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:delay];
    }
    return hud;
}

@end
