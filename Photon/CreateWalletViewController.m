//
//  CreateWalletViewController.m
//  Photon
//
//  Created by 薛海新 on 2019/7/31.
//  Copyright © 2019 薛海新. All rights reserved.
//

#import "CreateWalletViewController.h"
#import "PhotonStartViewController.h"

@interface CreateWalletViewController ()
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHigTop;

@end

@implementation CreateWalletViewController
- (instancetype)init{
    // 设置导航栏
    _statusBarStyle = UIStatusBarStyleLightContent;
    return  [super init];
}
#pragma mark -- 设置导航栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}
- (IBAction)backPush:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOT;
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navHigTop.constant = 88;
    }
    self.titleLabel.text = DDYLocalStr(@"createwallet");
    self.passWordTextField.placeholder = DDYLocalStr(@"SignupPassword");

    [self.createButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];
    [self.createButton setTitle:DDYLocalStr(@"createwallet") forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(createButtonCLick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createButtonCLick{
    
    ////////////Ethers class library to create wallets
    Account *account = [Account randomMnemonicAccount];
    
    NSLog(@"99999:::\n\n%@", account.mnemonicPhrase);
    [account encryptSecretStorageJSON:self.passWordTextField.text callback:^(NSString *json) {
        ///Save json file to local
        [self saveToJsonDirWithJson:json account:account];
    }];
}

- (void)saveToJsonDirWithJson:(NSString *)json account:(Account *)account
{
    if (json && account.address.checksumAddress) {
        
        NSString *address = [account.address.checksumAddress lowercaseString];
        NSString *savepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:LC_NSSTRING_FORMAT(@"%@.json", address)];
        if (savepath) {
            
            NSError *error = nil;
            if ([json writeToFile:savepath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
                NSLog(@"keystore 写入地址 %@", savepath);
                
                //////////////caveat//////
                
                ///The wallet keystore should be saved to keyChain, here is just dome
                
                /////Save address to local

                [Tool saveUserDefaultsValue:address forKey:@"WALLET_ADDRESS"];
                ////Save the keystore to the local

                [Tool saveUserDefaultsValue:json forKey:address];

                PhotonStartViewController *impot = [[PhotonStartViewController alloc]init];
                //                impot.keystoreStr = json;
                [self.navigationController pushViewController:impot animated:YES];
            }
            
        }else {
            //        DDYInfoLog(@"keystore 路径有误");
        }
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
