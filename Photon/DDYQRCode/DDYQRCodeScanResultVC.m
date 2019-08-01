//
//  DDYQRCodeScanResultVC.m
//  DDYProject
//
//  Created by Megan on 17/8/11.
//  Copyright © 2017 Starain. All rights reserved.
//
#define DDYRect(x,y,w,h) CGRectMake(x,y,w,h)

#import "DDYQRCodeScanResultVC.h"
#import "DDYTextView.h"

@interface DDYQRCodeScanResultVC ()

@property (nonatomic, strong) DDYTextView *resultView;

@end

@implementation DDYQRCodeScanResultVC

- (DDYTextView *)resultView {
    if (!_resultView) {
        _resultView = [DDYTextView textView];
        _resultView.userInteractionEnabled = NO;
        _resultView.editable = NO;
        _resultView.textAlignment = NSTextAlignmentCenter;
        _resultView.font = DDYFont(15);
        _resultView.frame = DDYRect(0, 0, DDYSCREENW, DDYSCREENH);
    }
    return _resultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.resultView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DDYLocalStr(@"ChatCellCopy")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleCopy)];
    //    [self showErrorText:DDYLocalStr(@"WalletQRTip")];
    MBProgressHUD *hud = [self showHudWithText:DDYLocalStr(@"")];
    hud.hidden = YES;
}

- (void)setResultStr:(NSString *)resultStr {
    _resultStr = resultStr;
    self.resultView.text = resultStr;
}

- (void)handleCopy {
    [UIPasteboard generalPasteboard].string = _resultStr;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:DDYLocalStr(@"QRCodeSavePhotoTip")
                                                                             message:DDYLocalStr(@"QRCodeCopySuccess")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:DDYLocalStr(@"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) { }];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:DDYLocalStr(@"Back") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
