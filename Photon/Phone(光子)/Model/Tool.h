//
//  Tool.h
//  WYPark
//
//  Created by 薛海新 on 15/10/26.
//  Copyright © 2015年 无忧停车. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FFAppDelegate.h"




@interface Tool : NSObject
+ (NSString *)padWithString:(NSString *)string number:(NSInteger)n;
+ (UIViewController *)getCurrentVC;
+ (void)animationAlert:(UIView *)view;
+ (NSDictionary *)readLocalFileWithName:(NSString *)name;

+ (NSString *)eos_publicKey:(unsigned char[32])pri;
+ (NSString *)eos_publicKey_with_wif:(NSString *)wif;

#pragma mark - 适配相关
+(NSString *)getCNYandUSD:(NSString *)type;
+(NSString *)getExchangeRate1:(float)banle;

+(NSString *)btcPowStr:(NSString *)str;
+(NSString *)btcPowStqweqwer1:(double)str1;
+(NSString *)powStr1:(double)str1 has:(int)wei;

+(NSString *)powStr:(NSString *)str has:(int)wei;
+(NSString *)changeFloat:(NSString *)stringFloat;

/**
 *  计算宽度为整屏时当前等比例状态的高度
 *
 *  @param originHeight 原始高度
 *
 *  @return 当前使用高度
 */
+(float)scaleWithFullWidthAndOriginHeight:(float)originHeight;

+(float)scaleWidthToHeight:(float)width Height:(float)height;

+(float) scaleHeightWithOriginWidth:(float)originWidth Height:(float)originHeight andNewWidth:(float)newWidth;

+(float) scaleWidthWithOriginHeight:(float)originWidth Height:(float)originHeight andNewHeight:(float)newHeight;


/**
 *  按照比例计算高度
 */
+(float) ratioHeightWithRatio:(float)ratio andContainerHeight:(float)container;


/**
 *  计算动态文本size
 *
 *  @param text 文本
 *  @param font 字体
 *  @param maxW 最大限制宽度
 *
 *  @return 适应后的size
 */
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;



#pragma mark - NSUserDefaults

/**
 *  使用NSUserDefaults存储key-value
 *
 *  @param value 存储的值
 *  @param key   对应的key
 */
+(void)saveUserDefaultsValue:(id)value forKey:(NSString*)key;

+(BOOL)getUserDefautsBoolForKey:(NSString*)key;

+(id)getUserDefautsValueForKey:(NSString *)key;

+(void)cleanUserDefaultsValueForKey:(NSString*)key;

+(NSString *)strDateTime:(NSString *)strTime;
+(NSString *)strTime:(NSString *)strTime;
////返回颜色
+(UIView *)layerView:(UIView *)view;
+(NSString*)getCurrentTimes;
+(UIImage*) createImageWithColor:(UIColor*) color;
+(NSString *)powStqweqwer1:(double)str1;

@end
