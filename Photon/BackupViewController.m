//
//  BackupViewController.m
//  Photon
//
//  Created by 薛海新 on 2019/7/31.
//  Copyright © 2019 薛海新. All rights reserved.
//


#import "BackupViewController.h"
#import "PhonePassWordView.h"

@interface BackupViewController ()
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopHig;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *keyStoreButton;
@property (weak, nonatomic) IBOutlet UIButton *privateButton;
@property(nonatomic,strong)PhonePassWordView *phoneView;
@property(nonatomic,strong)NSString *impotButtonTitle;

@end

@implementation BackupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOT;
    
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navTopHig.constant = 88;
    }
    
    self.titleLabel.text = DDYLocalStr(@"SMTBackUpPrepareConfirm");
    [self.keyStoreButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];
    [self.keyStoreButton setTitle:DDYLocalStr(@"BackupExportJsonFile") forState:UIControlStateNormal];
    [self.privateButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];
    [self.privateButton setTitle:DDYLocalStr(@"BackupExportPrivateKey") forState:UIControlStateNormal];
}


- (IBAction)impotWalletButtonClick:(UIButton *)sender {
    
    self.impotButtonTitle = sender.titleLabel.text;
    /////
    self.phoneView = [[PhonePassWordView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.phoneView.cancleButton addTarget:self action:@selector(phonePassWordCancleBUtton) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneView.phoneCancleButton addTarget:self action:@selector(phonePassWordCancleBUtton) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneView.determineButton addTarget:self action:@selector(phonePassWordDetermineButton) forControlEvents:UIControlEventTouchUpInside];
    [Tool animationAlert:self.phoneView.bgView];
    [self.view addSubview:self.phoneView];

}


-(void)phonePassWordCancleBUtton{
    [self.phoneView removeFromSuperview];
}
-(void)phonePassWordDetermineButton{
    [self.phoneView removeFromSuperview];
    if([self.impotButtonTitle isEqualToString:DDYLocalStr(@"BackupExportJsonFile")]){
        [self getkeyStoreCopy];
    }else{
        [self getprivateKeyCopy];
    }
}

/////Get private
-(void)getprivateKeyCopy{
    
    NSString *address = [Tool getUserDefautsValueForKey:@"WALLET_ADDRESS"];
    NSString *addressJson = [Tool getUserDefautsValueForKey:address];
    
    [Account getPrivateKeyDecryptSecretStorageJSON:addressJson password:self.phoneView.passWordTextField.text callback:^(Account *account, NSString *privateKey, NSError *error) {
        
        if (account)
        {
            ///复制按钮点击
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            NSString *string = privateKey;
            [pab setString:string];
            if (pab == nil) {
                [MBProgressHUD showErrorText:DDYLocalStr(@"homeerrer")];
            }else
            {
                [MBProgressHUD showSuccessText:DDYLocalStr(@"WalletAddressCopied")];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else if (error.code != kAccountErrorCancelled)
        {
            if (error.code == kAccountErrorWrongPassword) {
                
                NSLog(@"Decryption error: %@", error);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:DDYLocalStr(@"TransferPwdError") delegate:self cancelButtonTitle:DDYLocalStr(@"SignupOK") otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
        
    }];

}
/////Get keyStore
-(void)getkeyStoreCopy{
    NSString *address = [Tool getUserDefautsValueForKey:@"WALLET_ADDRESS"];
    NSString *addressJson = [Tool getUserDefautsValueForKey:address];
    
    [Account decryptSecretStorageJSON:addressJson password:self.phoneView.passWordTextField.text callback:^(Account *account, NSError *error) {
        if (account)
        {
            ///复制按钮点击
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            NSString *string = addressJson;
            [pab setString:string];
            if (pab == nil) {
                [MBProgressHUD showErrorText:DDYLocalStr(@"homeerrer")];
            }else
            {
                [MBProgressHUD showSuccessText:DDYLocalStr(@"WalletAddressCopied")];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else if (error.code != kAccountErrorCancelled)
        {
            if (error.code == kAccountErrorWrongPassword) {
                
                NSLog(@"Decryption error: %@", error);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:DDYLocalStr(@"TransferPwdError") delegate:self cancelButtonTitle:DDYLocalStr(@"SignupOK") otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
    }];
}

- (IBAction)backPush:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)init{
   
    _statusBarStyle = UIStatusBarStyleLightContent;
    return  [super init];
}
#pragma mark -- 设置导航栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
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
