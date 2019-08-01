//
//  CreateViewController.m
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/12.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import "CreateViewController.h"
#import "ExtractAlertView.h"
#import <ethers/Payment.h>
#import "NAQRCodeScanningVC.h"
#import "PhotonTransactionRecordsViewController.h"
#import "DDYAuthorityMaster.h"

@interface CreateViewController ()<UITextFieldDelegate>

{
    UIView *_toastView;
    NSMutableArray *_arrayM;
    UIView *_clooseTypeView;
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navhigTop;
@property (nonatomic ,strong)NSMutableArray *dataArray;///smt&mesh
@property (weak, nonatomic) IBOutlet UITextField *createAddressTxFeld;
@property (weak, nonatomic) IBOutlet UITextField *createDepositTxFeld;
@property (weak, nonatomic) IBOutlet UITextField *createNoteTxFeld;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic,assign)BOOL isNetWork;

@property (nonatomic,strong)ExtractAlertView *extractView;
@property (nonatomic, assign) BOOL isTypeCeools;    // 默认消耗的是ethgas
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UILabel *chooseSMTLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bizhongLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel3;

@end

//static NSData *stripDataZeros(NSData *data) {
//    const char *bytes = data.bytes;
//    NSUInteger offset = 0;
//    while (offset < data.length && bytes[offset] == 0) { offset++; }
//    return [data subdataWithRange:NSMakeRange(offset, data.length - offset)];
//}

@implementation CreateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navhigTop.constant = 88;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(raidenStatusReload) name:@"RaidenStatusChange" object:nil];
    [self raidenStatusReload];

    self.titleLabel.text = DDYLocalStr(@"createrchannel");
    self.titleLabel.textColor = BGTEXT;
    self.bizhongLabel.text = DDYLocalStr(@"currency");
    self.bizhongLabel.textColor = BGTEXT;
    self.lineLabel.backgroundColor = BUTTONBGCOLOR;
    self.lineLabel2.backgroundColor = BUTTONBGCOLOR;
    self.lineLabel3.backgroundColor = BUTTONBGCOLOR;
    self.view.backgroundColor = BGCOLOT;
    self.createAddressTxFeld.textColor = BGTEXT;
    NSString *holderText = DDYLocalStr(@"photonAddress");
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xE2EDEA)
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:15]
                        range:NSMakeRange(0, holderText.length)];
    self.createAddressTxFeld.attributedPlaceholder = placeholder;

    NSString *holderText1 = DDYLocalStr(@"amountwaller");
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xE2EDEA)
                        range:NSMakeRange(0, holderText1.length)];
    [placeholder1 addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:15]
                        range:NSMakeRange(0, holderText1.length)];
    self.createDepositTxFeld.attributedPlaceholder = placeholder1;
    self.createDepositTxFeld.textColor = BGTEXT;

    NSString *holderText2 = DDYLocalStr(@"creaternote");
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc] initWithString:holderText2];
    [placeholder2 addAttribute:NSForegroundColorAttributeName
                         value:UIColorFromRGB(0xE2EDEA)
                         range:NSMakeRange(0, holderText2.length)];
    [placeholder2 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:15]
                         range:NSMakeRange(0, holderText2.length)];
    self.createNoteTxFeld.attributedPlaceholder = placeholder2;
    self.createNoteTxFeld.textColor = BGTEXT;

    self.createDepositTxFeld.delegate = self;
    self.createDepositTxFeld.keyboardType = UIKeyboardTypeDecimalPad;
    
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navhigTop.constant = 88;
    }
    [self.okButton setTitle:DDYLocalStr(@"createrThroughcreating") forState:UIControlStateNormal];
    self.okButton.alpha = 0.5;
    self.okButton.enabled = NO;
    [self.okButton setBackgroundColor:BUTTONBGCOLOR];
    [self.okButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
    self.tokenAddressString = RAIDEN_SMT_CONTRACT_ADDRESS;
}

-(void)raidenStatusReload{
}


- (IBAction)closeeButtonclick:(id)sender {
    
    if(self.isTypeCeools == NO){
        self.isTypeCeools = YES;
        _clooseTypeView = [[UIView alloc]initWithFrame:CGRectMake(15, NavHeight+84, ScreenWidth-30, _arrayM.count*50)];
        _clooseTypeView.backgroundColor = UIColorFromRGB(0x23393A);
        
        for(int i=0;i<_arrayM.count;i++){
            NATModel *model = [_arrayM objectAtIndex:i];
            UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(15, i*50, ScreenWidth-60, 50)];
            labels.text = model.symbol;
            labels.font = [UIFont systemFontOfSize:15];
            labels.textColor = BGTEXT;
            [_clooseTypeView addSubview:labels];
            
            UIButton *buttons = [[UIButton alloc]initWithFrame:CGRectMake(0, i*50, ScreenWidth-30, 50)];
            buttons.tag = 1090+i;
            [buttons addTarget:self action:@selector(chooseTypeBUttonCLick:) forControlEvents:UIControlEventTouchUpInside];
            [_clooseTypeView addSubview:buttons];
        }
        
        [self.view addSubview:_clooseTypeView];
        
    }else{
        self.isTypeCeools = NO;
        [_clooseTypeView removeFromSuperview];
    }

}

-(void)chooseTypeBUttonCLick:(UIButton *)but{
    [_clooseTypeView removeFromSuperview];
    self.isTypeCeools = NO;
    self.tokenAddressString = RAIDEN_SMT_CONTRACT_ADDRESS;
    
//    self.smtMesh.text = model.symbol;
    self.chooseSMTLabel.text = @"SMT";
}


- (IBAction)backPush:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.createAddressTxFeld resignFirstResponder];
    [self.createDepositTxFeld resignFirstResponder];
    [self.createNoteTxFeld resignFirstResponder];
}
- (IBAction)okButtonClick:(id)sender {
    self.tokenAddressString = RAIDEN_SMT_CONTRACT_ADDRESS;

    if(self.isNetWork == NO){
    
    if(self.createAddressTxFeld.text.length>0){
    }else{
        [self ff_HudText:DDYLocalStr(@"createraddressnode") isLoading:NO hideDelay:2];
        return;
    }
    
    if([self.createDepositTxFeld.text doubleValue]>=0.01){
    }else{
        [self ff_HudText:DDYLocalStr(@"createrDeposits") isLoading:NO hideDelay:2];
        return;
    }
        
        
        [[RaidenManager sharedManager]getAssetsOnToken:@"" token:^(BOOL success, id result, NSError *error) {
            if (success) {
                
                
                if(![[NSString stringWithFormat:@"%@",[result objectForKey:@"data"]]isEqualToString:@"<null>"]){
                    
                    NSArray *array = [result objectForKey:@"data"];
                    
                    for(NSDictionary *dict in array){
                        if([[[dict objectForKey:@"token_address"]lowercaseString] isEqualToString:[RAIDEN_SMT_CONTRACT_ADDRESS lowercaseString]]){
                            dispatch_async(dispatch_get_main_queue(), ^{

                                if([[Tool powStr:[dict objectForKey:@"balance_on_chain"] has:18] doubleValue]>=[self.createDepositTxFeld.text doubleValue]){
                                    
                                    _toastView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, Screen_Height)];
                                    _toastView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
                                    [self.view.window addSubview:_toastView];
                                    
                                    self.extractView = [[ExtractAlertView alloc]initWithFrame:CGRectMake(25, _toastView.frame.size.height/2-90, ScreenWidth-50, 184)];
                                    self.extractView.extractLabel.text = DDYLocalStr(@"lognotice");
                                    self.extractView.extractToastLabel.text = DDYLocalStr(@"creatertoast");
                                    [self.extractView.extracetCancelButton addTarget:self action:@selector(canleButtonClick) forControlEvents:UIControlEventTouchUpInside];
                                    [self.extractView.extracetDetermineButton addTarget:self action:@selector(determineButtonClick) forControlEvents:UIControlEventTouchUpInside];
                                    [Tool animationAlert:self.extractView];
                                    [_toastView addSubview:self.extractView];

                                    
                                }else{
                                    [self ff_HudText:DDYLocalStr(@"createrInsufficientbalance") isLoading:NO hideDelay:2];
                                    return ;
                                }
                                
                            });
                            
                        }else{
                            
                        }
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{

                    [self ff_HudText:DDYLocalStr(@"createrInsufficientbalance") isLoading:NO hideDelay:2];
                    });
                    
                }
            }
        }];
    
    
        
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}


-(void)canleButtonClick{
     [_toastView removeFromSuperview];
}

-(void)determineButtonClick{/////Create channel
    [_toastView removeFromSuperview];
    [self showLoading];
    ////创建通道
    ///正式 46666；
    //测试100
    
    //self.createAddressTxFeld.text Address
    //self.tokenAddressString   Contract address
    //settleTimeout。>40000
    //self.createDepositTxFeld.text。  Amount deposited
    [[RaidenManager sharedManager] openChannel:self.createAddressTxFeld.text tokenAddress:self.tokenAddressString settleTimeout:46666 balanceStr:self.createDepositTxFeld.text resultBlock:^(BOOL success, id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissLoading];
            if (success) {
                
                if (result) {
                    ///////Enter transfer record
                    [self pushPhoton];
                    
                }else {
                    [self ff_HudText:@"openChannel返回nil!" isLoading:NO hideDelay:2];
                }
                
                //////Error message code
            }else if([[result objectForKey:@"error_code"] integerValue]==5027){
                [self ff_HudText:DDYLocalStr(@"photonsidesnode") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==3005){
                [self ff_HudText:DDYLocalStr(@"photonChannelalready") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==1016){
                [self ff_HudText:DDYLocalStr(@"photonOutofline") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==2000){
                [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==5001){
                [self ff_HudText:DDYLocalStr(@"photonsuo5001") isLoading:NO hideDelay:2];
                
            }else if([[result objectForKey:@"error_code"] integerValue]==2012){
                [self ff_HudText:DDYLocalStr(@"photonsuo2012") isLoading:NO hideDelay:2];
                
            }else if([[result objectForKey:@"error_code"] integerValue]==2999){
                [self ff_HudText:DDYLocalStr(@"photon2999") isLoading:NO hideDelay:2];
                
            }else{
                [self ff_HudText:[NSString stringWithFormat:@"%@",[result objectForKey:@"error_message"]] isLoading:NO hideDelay:0.7];
            }
        });
    }];
}

-(void)pushPhoton{
    PhotonTransactionRecordsViewController *transaction = [[PhotonTransactionRecordsViewController alloc]init];
    if([[NSString stringWithFormat:@"%@",self.amountValueStr]isEqualToString:@"1"]){
        transaction.isPop = YES;
        transaction.transferPhoton = YES;
    }else{
        transaction.isPop = YES;
        transaction.transferPhoton = NO;
    }
        transaction.isPhoton = YES;
        transaction.itemCurrent = self.itemCurrent.symbol;
    [self.navigationController pushViewController:transaction animated:YES];
    
}

- (IBAction)qrPush:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DDYAuthorityMaster cameraAuthSuccess:^{
            NAQRCodeScanningVC *vc = [[NAQRCodeScanningVC alloc] init];

            @weakly(self);
            vc.qrMessageBlock = ^(NSString *value) {

                @normally(self);
                NSMutableDictionary *dict = [self handleQNResultMessageWithValue:value];

                if (dict) {

                    _createAddressTxFeld.text = [dict objectForKey:@"address"];
                    _createDepositTxFeld.text = [dict objectForKey:@"amount"];
                }

                [self.navigationController popViewControllerAnimated:NO];
            };



            [self.navigationController pushViewController:vc animated:YES];
        } fail:^{

        } alertShow:YES];
    });
}

- (NSMutableDictionary *)handleQNResultMessageWithValue:(NSString *)value
{
    if (value.length >= 42 && [value hasPrefix:@"0x"]) {
        
        // 将扫描结果放在字典中,3个key: @"address", @"amount", @"token"
        NSMutableDictionary<NSString *, NSString *> *dataDict = [NSMutableDictionary dictionary];
        
        dataDict = [self generateDataDictWithValue:value];
        
        if (dataDict.count) { // 如果有信息被存储,则执行语句
            
            return dataDict;
        }else {
            return nil;
        }
    }
    else {
        
        MBProgressHUD *hud = [self showHudWithText:DDYLocalStr(@"WalletQRTip")];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:2];
        return nil;
    }
}

#pragma mark - 将扫描结果生成字典
- (NSMutableDictionary<NSString *, NSString *> *)generateDataDictWithValue:(NSString *)value
{
    // 将扫描结果放在字典中,3个key: @"address", @"amount", @"token"
    NSMutableDictionary<NSString *, NSString *> *dataDict = [NSMutableDictionary dictionary];
    
    NSArray *qustMakSepArr = [value componentsSeparatedByString:@"?"];
    
    for (NSString *qusMak in qustMakSepArr)
    {
        if ([qusMak hasPrefix:@"0x"] && qusMak.length == 42)
        {
            [dataDict setObject:qusMak forKey:@"address"];
        }
        else if ([qusMak containsString:@"&"])
        {
            NSArray *temArr = [qusMak componentsSeparatedByString:@"&"];
            for (NSString *andSep in temArr)
            {
                if ([andSep hasPrefix:@"amount="]) {
                    NSString *value = [andSep substringFromIndex:[andSep rangeOfString:@"amount="].length];
                    [dataDict setObject:value forKey:@"amount"];
                } else if ([andSep hasPrefix:@"token="]) {
                    NSString *value = [andSep substringFromIndex:[andSep rangeOfString:@"token="].length];
                    [dataDict setObject:value forKey:@"token"];
                } else {
                    MBProgressHUD *hud = [self showHudWithText:DDYLocalStr(@"WalletQRQuestion")];
                    hud.mode = MBProgressHUDModeText;
                    [hud hideAnimated:YES afterDelay:2];
                }
            }
        }
        else
        {
            MBProgressHUD *hud = [self showHudWithText:DDYLocalStr(@"WalletQRQuestion")];
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:2];
        }
    }
    return dataDict;
}


//获取输入值
- (void)textFieldDidChange:(UITextField *)textField
{
    if(self.createAddressTxFeld.text.length>0&&self.createDepositTxFeld.text.length>0){
        self.okButton.alpha = 1;
        self.okButton.enabled = YES;
    }else{
        self.okButton.enabled = NO;
        self.okButton.alpha = 0.5;
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
// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.createAddressTxFeld.text.length>0&&self.createDepositTxFeld.text.length>0){
        self.okButton.alpha = 1;
        self.okButton.enabled = YES;
    }else{
        self.okButton.enabled = NO;
        self.okButton.alpha = 0.5;
    }
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    //                    showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    //                    showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        //                        showMsg(@"最多两位小数");
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //            showMsg(@"数据格式有误");
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
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
