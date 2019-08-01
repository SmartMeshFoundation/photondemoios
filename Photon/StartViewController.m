//
//  StartViewController.m
//  Photon
//
//  Created by 薛海新 on 2019/7/31.
//  Copyright © 2019 薛海新. All rights reserved.
//
#define LC_NSSTRING_FORMAT(s,...) [NSString stringWithFormat:s,##__VA_ARGS__]

#import "StartViewController.h"
#import "RaidenManager.h"
#import "PhoneTransferViewController.h"
#import "ImpotWalletViewController.h"
#import "CreateWalletViewController.h"


@interface StartViewController ()
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopHig;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastLabel;

@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *impotButton;

@end

@implementation StartViewController
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
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navTopHig.constant = 88;
    }
    self.titleLabel.text = DDYLocalStr(@"createwallet");
    self.view.backgroundColor = BGCOLOT;
    [self.createButton setTitle:DDYLocalStr(@"createwallet") forState:UIControlStateNormal];
    [self.createButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];
    
    [self.impotButton setTitle:DDYLocalStr(@"importwallet") forState:UIControlStateNormal];
    [self.impotButton setTitleColor:BUTTONBGCOLOR forState:UIControlStateNormal];

}

////Create wallet
- (IBAction)createButtonClick:(id)sender {
    
    CreateWalletViewController *create = [[CreateWalletViewController alloc]init];
    [self.navigationController pushViewController:create animated:YES];
    
    
}
////Impot wallet
- (IBAction)impotButtonClick:(id)sender {
    ImpotWalletViewController *impot = [[ImpotWalletViewController alloc]init];
    [self.navigationController pushViewController:impot animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
