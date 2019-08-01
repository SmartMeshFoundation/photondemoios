//
//  PhotonStartViewController.m
//  Photon
//
//  Created by 薛海新 on 2019/7/31.
//  Copyright © 2019 薛海新. All rights reserved.
//

#import "PhotonStartViewController.h"
#import "PhonePassWordView.h"
#import "PhoneTransferViewController.h"
#import "BackupViewController.h"

@interface PhotonStartViewController ()
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
}
@property(nonatomic,strong)PhonePassWordView *phoneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopHig;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *photonLabel;
@property (weak, nonatomic) IBOutlet UILabel *photonToastLabel;
@property (weak, nonatomic) IBOutlet UIButton *backupButton;

@end

@implementation PhotonStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navTopHig.constant = 88;
    }

    self.view.backgroundColor = BGCOLOT;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRaidenRpc:) name:@"RAIDENRPCSUCCESS" object:nil];
    [self.backupButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];
    [self.backupButton setTitle:DDYLocalStr(@"WalletHomeTipBackup") forState:UIControlStateNormal];
    
    self.titleLabel.text = DDYLocalStr(@"startphoton");
    self.balanceLabel.text = DDYLocalStr(@"addChainbalance");
    self.addressLabel.text = DDYLocalStr(@"photonAddress");
    self.photonLabel.text = DDYLocalStr(@"photonicnetwork");
    self.photonToastLabel.text = DDYLocalStr(@"photonicnetworktost");

    NSString *address = [Tool getUserDefautsValueForKey:@"WALLET_ADDRESS"];
    self.addressValueLabel.text = address;
}

- (IBAction)backupButtonClick:(id)sender {
    BackupViewController *backUp = [[BackupViewController alloc]init];
    [self.navigationController pushViewController:backUp animated:YES];
    
}
- (IBAction)startButtonClick:(id)sender {
    
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
    NSString *address = [Tool getUserDefautsValueForKey:@"WALLET_ADDRESS"];
    NSString *addressJson = [Tool getUserDefautsValueForKey:address];
    
    NSString *json = addressJson;
    if (json) {
        
        [Account decryptSecretStorageJSON:json password:self.phoneView.passWordTextField.text callback:^(Account *account, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
            if (account)
            {
                NSString *address = [account.address.checksumAddress lowercaseString];
                NSString *savepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:LC_NSSTRING_FORMAT(@"%@.json", address)];
                if (savepath) {
                    
                    ///启动光子
                        [[RaidenManager sharedManager]raidenStop:@"" has:self.phoneView.passWordTextField.text node:@"" address:address];
                    [self showLoading];
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



- (void)refreshRaidenRpc:(NSNotification *) notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        //处理消息
        [self dismissLoading];
        PhoneTransferViewController *phoner = [[PhoneTransferViewController alloc]init];
        phoner.IsPushTrans = NO;
        [self.navigationController pushViewController:phoner animated:YES];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
