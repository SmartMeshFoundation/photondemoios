//
//  NAQRCodeScanningVC.m
//  NAQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017 kingsic. All rights reserved.
//

#import "NAQRCodeScanningVC.h"
#import "DDYQRCodeScanView.h"
#import "DDYQRCodeManager.h"


@interface NAQRCodeScanningVC ()<DDYQRCodeManagerDelegate>
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态

}
@property (nonatomic, strong) DDYQRCodeManager *qrCodeManager;

@property (nonatomic, strong) DDYQRCodeScanView *scanView;



@property (nonatomic, strong) UIImage *myQRCodeImg;

@end

@implementation NAQRCodeScanningVC

- (DDYQRCodeManager *)qrCodeManager {
    if (!_qrCodeManager) {
        _qrCodeManager = [[DDYQRCodeManager alloc] init];
        _qrCodeManager.delegate = self;
    }
    return _qrCodeManager;
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
    [self prepare];
    [self setupScanview];
    [self performSelector:@selector(setupQRManager) withObject:nil afterDelay:0.1];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SafeAreaTopHeight)];
    view.backgroundColor = UIColorFromRGB(0x13151C);
    [self.view addSubview:view];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, NavTabHeight, ScreenWidth, 44)];
    //    label.font = [UIFont systemFontOfSize:16];
    //    label.textColor = UIColorFromRGB(0xA1A1A1);
    //    label.text = Localized(@"systemSetup_xitongshezhi");//@"系统设置";
    //    label.textAlignment = NSTextAlignmentCenter;
    //    [view addSubview:label];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, NavTabHeight, 45, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_back_New_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐

    [view addSubview:backButton];
    
//    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-80-15, NavTabHeight, 80, 44)];
//    //    [nextButton setImage:[UIImage imageNamed:@"icon_back_New_white"] forState:UIControlStateNormal];
//    //    [nextButton setBackgroundColor:UIColorFromRGB(0x123832)];
//    [nextButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;// 水平左对齐
//
//    [nextButton setTitle:DDYLocalStr(@"ChatBoxAlbum") forState:UIControlStateNormal];
//    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [view addSubview:nextButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, NavHeight, ScreenWidth-30, 31)];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.text = DDYLocalStr(@"ChatMenuScanQRCode");
    titleLabel.textColor = UIColorFromRGB(0xE2EDEA);
    [self.view addSubview:titleLabel];
    


}





- (NSString *)handleQNResultMessageWithValue:(NSString *)value
{
    if (value.length >0) {
        return value;
    }
    else {
        MBProgressHUD *hud = [self showHudWithText:DDYLocalStr(@"WalletQRTip")];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:2];
        return nil;
    }
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepare
{
    self.view.backgroundColor = [UIColor blackColor];
//    [self showRightBarBtnWithTitle:DDYLocalStr(@"ScanAlbum") img:nil];
}

- (void)setupScanview {
    _scanView = [DDYQRCodeScanView scanView];
    [self.view addSubview:_scanView];
}

- (void)setupQRManager {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.qrCodeManager ddy_ScanQRCodeWithCameraContainer:self.view];
    });
}

- (void)ddy_QRCodeScanResult:(NSString *)result success:(BOOL)success; {
    if (success) {
        [self.qrCodeManager ddy_stopRunningSession];
        if (self.qrMessageBlock) {
            self.qrMessageBlock(result);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_qrCodeManager) { [_qrCodeManager ddy_startRunningSession];}
//    [self setNavigationBackgroundAlpha:0.15];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Tool saveUserDefaultsValue:@"0" forKey:@"QRBUTTON"];

    if (_qrCodeManager) {  [self.qrCodeManager ddy_stopRunningSession];}
//    [self setNavigationBackgroundAlpha:1];
}

- (void)leftBtnClick:(UIButton *)button {
    if ([self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{ }];
    }
}

- (void)rightBtnClick{
//    [DDYAuthorityMaster albumAuthSuccess:^{
//        [self.qrCodeManager ddy_imgPickerVCWithCurrentVC:self];
//    } fail:^{ } alertShow:YES];
}


- (void)dealloc {
    [_scanView stopScanningLingAnimation];
    if (_qrCodeManager) {
        [_qrCodeManager ddy_stopRunningSession];
        _qrCodeManager.delegate = nil;
        _qrCodeManager = nil;
    }
}

@end

