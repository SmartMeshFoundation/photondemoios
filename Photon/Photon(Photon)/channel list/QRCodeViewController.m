//
//  QRCodeViewController.m
//  Photon
//
//  Created by 薛海新 on 2019/7/31.
//  Copyright © 2019 薛海新. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态

}
@property (weak, nonatomic) IBOutlet UIImageView *imageVIewQr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopHig;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addresscopyButton;


@end

@implementation QRCodeViewController
- (IBAction)copyAddressButtonClick:(id)sender {
    ///复制按钮点击
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        NSString *string = self.walletAddress;
        [pab setString:string];
        if (pab == nil) {
            [MBProgressHUD showErrorText:DDYLocalStr(@"homeerrer")];
        }else
        {
            [MBProgressHUD showSuccessText:DDYLocalStr(@"WalletAddressCopied")];
        }
}
- (instancetype)init{
    // 设置导航栏
    _statusBarStyle = UIStatusBarStyleLightContent;
    return  [super init];
}
#pragma mark -- 设置导航栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.view.backgroundColor = UIColorFromRGB(0x1B272B);
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navTopHig.constant = 88;
    }
    self.addressLabel.text = self.walletAddress;
    [self.addresscopyButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];
    [self.addresscopyButton setTitle:DDYLocalStr(@"copyaddress") forState:UIControlStateNormal];

    self.titleLabel.text = DDYLocalStr(@"paymentcode");
    [self erweima];
    // Do any additional setup after loading the view from its nib.
}

- (void)erweima{
    
    //二维码滤镜
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    NSString * selfAddStr = self.walletAddress;
    
    NSData *data = [selfAddStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage = [filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    self.imageVIewQr.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:120.0];
    
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    self.imageVIewQr.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
    
    self.imageVIewQr.layer.shadowRadius=1;//设置阴影的半径
    
    self.imageVIewQr.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    
    self.imageVIewQr.layer.shadowOpacity=0.3;
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}
- (IBAction)backPush:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
