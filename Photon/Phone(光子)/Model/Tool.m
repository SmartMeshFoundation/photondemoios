//
//  Tool.m
//  WYPark
//
//  Created by 薛海新 on 15/10/26.
//  Copyright © 2015年 无忧停车. All rights reserved.
//

#import "Tool.h"
@implementation Tool

//+ (NSString *)eos_publicKey_with_wif:(NSString *)wif{
//    unsigned char pri[32];
//    const char *baprik = [wif UTF8String];
//    unsigned char result[37];
//    unsigned char digest[32];
//    char base[100];
//    unsigned char *hash;
//    size_t len = 100;
//    size_t klen = 37;
//
//    uint8_t pub[64];
//    uint8_t cpub[33];
//
//    if (b58tobin(result, &klen, baprik, wif.length)) {
//        printf("success\n");
//    }
//
//    memcpy(pri, result+1, 32);
//
//    uECC_compute_public_key(pri, pub);
//
//    result[0] = 0x80;
//    memcpy(result+1, pri, 32);
//    sha256_Raw(result, 33, digest);
//    sha256_Raw(digest, 32, digest);
//    memcpy(result+33, digest, 4);
//    b58enc(base, &len, result, 37);
//
//    uECC_compress(pub, cpub);
//    hash = RMD(cpub, 33);
//    memcpy(result, cpub, 33);
//    memcpy(result+33, hash, 4);
//    b58enc(base, &len, result, 37);
//
//    NSString *eosPubKey = [NSString stringWithFormat:@"EOS%@", [NSString stringWithUTF8String:base]];
//    return eosPubKey;
//}

+ (NSString *)padWithString:(NSString *)string number:(NSInteger)n {
    NSInteger len = string.length;
    while(len < n) {
        
        string = [@"0" stringByAppendingString:string];
        //        string = [NSMutableString stringWithFormat:@"0%@", string];
        len++;
    }
    return string;
}
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

+ (void)animationAlert:(UIView *)view
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}


+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(NSString *)getCNYandUSD:(NSString *)type{
    
    
    NSString *str ;
    if([[Tool getUserDefautsValueForKey:@"USD_CNY"]isEqualToString:@"CNY"]){
        str = [NSString stringWithFormat:@"%@ CNY",type];
    }else{
        str = [NSString stringWithFormat:@"%@ USD",type];
    }
    return str;
    
}


+(NSString *)getExchangeRate1:(float)banle{
    NSString *str ;
    if([[Tool getUserDefautsValueForKey:@"USD_CNY"]isEqualToString:@"CNY"]){
        str = [NSString stringWithFormat:@"%0.2f",banle*[[Tool getUserDefautsValueForKey:@"ETH_USDT"] floatValue]*[[Tool getUserDefautsValueForKey:@"USDT_CNY"] floatValue]];
    }else{
        str = [NSString stringWithFormat:@"%0.2f",banle*[[Tool getUserDefautsValueForKey:@"ETH_USDT"] floatValue]];
    }
    return str;
}



/////ETH 大数换小数
+(NSString *)powStr:(NSString *)str has:(int)wei{
    double result = [str doubleValue];
    float qw = (result/pow(10, wei));
    
    return [self changeFloat:[NSString stringWithFormat:@"%f",qw]];
}

/////btc 大数换小数
+(NSString *)btcPowStr:(NSString *)str{
    double result = [str doubleValue];
    float qw = (result/pow(10, 8));
    
    return [self changeFloat:[NSString stringWithFormat:@"%0.8f",qw]];
}

/////ETH 小数换大数
//+(NSString *)powStr1:(NSString *)str1{
//    double result = [str1 doubleValue];
//    NSInteger qw = (result*pow(10, 18));
//
//    return [NSString stringWithFormat:@"%ld",qw];
//}

//ETH 18wei
+(NSString *)powStr1:(double)str1 has:(int)wei{
    double result = str1;
    
    for(int i=0;i<wei;i++){
        result *= 10;
    }
    NSLog(@"%@",[self changeFloat:[NSString stringWithFormat:@"%f",result]]);
    
    return [NSString stringWithFormat:@"%@",[self changeFloat:[NSString stringWithFormat:@"%f",result]]];
}

///ETH qweqwe小数换大数
+(NSString *)powStqweqwer1:(double)str1{
    double asdasdsd = str1;
    for(int i=0;i<18;i++){
        asdasdsd *= 10;
    }
    
    NSLog(@"%f",asdasdsd);
    NSLog(@"%@",[self changeFloat:[NSString stringWithFormat:@"%f",asdasdsd]]);
    NSLog(@"%lld",[NSString stringWithFormat:@"%f",asdasdsd].longLongValue);
    
    return [self changeFloat:[NSString stringWithFormat:@"%f",asdasdsd]];
}



////BTC
+(NSString *)btcPowStqweqwer1:(double)str1{
    double asdasdsd = str1;
    for(int i=0;i<8;i++){
        asdasdsd *= 10;
    }
    
    NSLog(@"%f",asdasdsd);
    NSLog(@"%@",[self changeFloat:[NSString stringWithFormat:@"%f",asdasdsd]]);
    NSLog(@"%lld",[NSString stringWithFormat:@"%f",asdasdsd].longLongValue);
    
    return [self changeFloat:[NSString stringWithFormat:@"%f",asdasdsd]];
}

+(NSString *)changeFloat:(NSString *)stringFloat
{
    NSInteger length = [stringFloat length];
    if ([stringFloat containsString:@"."]) {
        
        for(NSInteger i = length - 1; i >= 0; i--)
        {
            NSString *subString = [stringFloat substringFromIndex:i];
            if(![subString isEqualToString:@"0"])
            {
                if ([subString isEqualToString:@"."]) {
                    
                    return [stringFloat substringToIndex:[stringFloat length] - 1];
                    
                }else{
                    
                    return stringFloat;
                }
            }
            else
            {
                stringFloat = [stringFloat substringToIndex:i];
            }
        }
    }
    return 0;
}
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

///////正常
+(NSString *)strTime:(NSString *)strTime
{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval  =[strTime doubleValue] / 1.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}

///////13位时间搓
+(NSString *)strDateTime:(NSString *)strTime
{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval  =[strTime doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}

#pragma mark - 适配相关
+(float)scaleWidthToHeight:(float)width Height:(float)height
{
    return (width)/(height);
}

+(float)scaleHeightWithOriginWidth:(float)originWidth Height:(float)originHeight andNewWidth:(float)newWidth
{
    return ((originHeight)*(newWidth))/(originWidth);
}





+(float)scaleWidthWithOriginHeight:(float)originWidth Height:(float)originHeight andNewHeight:(float)newHeight
{
    return ((originWidth)*(newHeight))/(originHeight);
}

+(float)ratioHeightWithRatio:(float)ratio andContainerHeight:(float)container{
    return container*ratio;
}


+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}




#pragma mark - NSUserDefaults
+(void)saveUserDefaultsValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    NSString *path = NSHomeDirectory();
    
    [defaults synchronize];
}

+(BOOL)getUserDefautsBoolForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+(id)getUserDefautsValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key];
}

+(void)cleanUserDefaultsValueForKey:(NSString *)key{
    if ([self getUserDefautsValueForKey:key]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:key];
    }
}

@end
