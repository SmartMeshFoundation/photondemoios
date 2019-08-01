//
//  ImpotWalletViewController.m
//  Photon
//
//  Created by 薛海新 on 2019/7/31.
//  Copyright © 2019 薛海新. All rights reserved.
//

#import "ImpotWalletViewController.h"
#import "PhotonStartViewController.h"

@interface ImpotWalletViewController ()
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
}
@property (weak, nonatomic) IBOutlet UITextView *keyStoreTextView;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UILabel *toastLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHigTop;
@property (weak, nonatomic) IBOutlet UIButton *impotButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ImpotWalletViewController
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
    self.bgView.backgroundColor = BGCOLOT;
    self.toastLabel.text = DDYLocalStr(@"enterkeystore");

    self.view.backgroundColor = BGCOLOT;
    self.passWordTextField.placeholder = DDYLocalStr(@"LoginInputPassword");
    [self.impotButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];
    [self.impotButton setTitle:DDYLocalStr(@"importwallet") forState:UIControlStateNormal];

    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navHigTop.constant = 88;
    }
    
}

- (IBAction)backPush:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


///////Import keystore
- (IBAction)copyButtonClick:(id)sender {
    
    
    NSString *json = self.keyStoreTextView.text;
    if (json) {
        
        [Account decryptSecretStorageJSON:json password:self.passWordTextField.text callback:^(Account *account, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
            if (account)
            {
                NSString *address = [account.address.checksumAddress lowercaseString];
                NSString *savepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:LC_NSSTRING_FORMAT(@"%@.json", address)];
                if (savepath) {
                    
                    NSError *error = nil;
                    if ([self.keyStoreTextView.text writeToFile:savepath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
                        NSLog(@"keystore 写入地址 %@", savepath);
                        
                        //////////////caveat//////
                        
                        ///The wallet keystore should be saved to keyChain, here is just dome
                        
                        /////Save address to local
                        [Tool saveUserDefaultsValue:address forKey:@"WALLET_ADDRESS"];
                        ////Save the keystore to the local
                        [Tool saveUserDefaultsValue:json forKey:address];

                        PhotonStartViewController *staret = [[PhotonStartViewController alloc]init];
                        [self.navigationController pushViewController:staret animated:YES];

                    }
                    
                }else {

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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
