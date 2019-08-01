//
//  DDYButton.h
//  DDYProject
//
//  Created by Megan on 17/7/20.
//  Copyright © 2017 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef DDYButtonNew
#define DDYButtonNew ([DDYButton customDDYBtn])
#endif

typedef NS_ENUM(NSInteger, DDYBtnStyle) {
    DDYBtnStyleImgLeft           = 0,     // 左图右文，整体居中，设置间隙
    DDYBtnStyleImgRight          = 1,     // 左文右图，整体居中，设置间隙
    DDYBtnStyleImgTop            = 2,     // 上图下文，整体居中，设置间隙
    DDYBtnStyleImgDown           = 3,     // 下图上文，整体居中，设置间隙
    DDYBtnStyleNaturalImgLeft    = 4,     // 左图右文，自然对齐，两端对齐
    DDYBtnStyleNaturalImgRight   = 5,     // 左文右图，自然对齐，两端对齐
    DDYBtnStyleImgLeftThenLeft   = 6,     // 左图右文，整体居左，设置间隙
    DDYBtnStyleImgRightThenLeft  = 7,     // 左图右文，整体居左，设置间隙
    DDYBtnStyleImgLeftThenRight  = 8,     // 左文右图，整体居左，设置间隙
    DDYBtnStyleImgRightThenRight = 9,     // 左图右文，整体居右，设置间隙
};

@interface DDYButton : UIButton

+ (instancetype)customDDYBtn;

/** 布局方式 */
@property (nonatomic, assign) DDYBtnStyle btnStyle;
/** 图文间距 默认5 需要设置DDYBtnStyle才能生效 */
@property (nonatomic, assign) CGFloat padding;
/** 文字字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 创建一个NormalState按钮 */
+ (instancetype)btnTitle:(NSString *)title img:(id)img target:(id)target action:(SEL)action;

+ (instancetype)btnTitle:(NSString *)title img:(id)img target:(id)target action:(SEL)action tag:(NSInteger)tag;

@end

