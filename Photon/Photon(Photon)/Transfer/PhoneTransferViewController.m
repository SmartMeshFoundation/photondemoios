//
//  PhoneTransferViewController.m
//  FireFly
//
//  Created by 薛海新 on 2019/5/15.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "PhoneTransferViewController.h"
//#import "RChannelModel.h"
//#import "NAQRCodeScanningVC.h"
#import "ChannelController.h"
#import "CreateViewController.h"
#import "PhotonTransactionRecordsViewController.h"
#import "PhoneTransferView.h"
#import "WithdrawalAlertView.h"
@interface PhoneTransferViewController ()<UITextFieldDelegate,transferCellDelegate>
{
    UIView *_clooseTypeView;
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
    NSMutableArray *_arrayM;
    UIView *_middleView;
    BOOL _transViewBoos;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopHig;
@property (weak, nonatomic) IBOutlet UIView *navHigView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UILabel *chooseSMTLabel;
@property (weak, nonatomic) IBOutlet UILabel *bizhongLabel;

@property (weak, nonatomic) IBOutlet UILabel *traAddress;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *obtainButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *tfNumber;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UILabel *smtMesh;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;

@property (weak, nonatomic) IBOutlet UIButton *paymentButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isTypeCeools;    // 默认消耗的是ethgas
@property (nonatomic ,strong)NSString *tokenAddressString;///smt&mesh
@property (nonatomic ,strong)NSString *tokenSMTMESHAddress;///smt&mesh

@property (nonatomic, strong) NATModel *itemCurrent;

@property (nonatomic, strong) NSArray *channels;
@property (nonatomic ,strong)NSString *jsonStr;///smt&mesh
@property (nonatomic ,strong)NSString *fellStr;///smt&mesh
@property (nonatomic ,strong)PhoneTransferView *transferView;///smt&mesh


@property (weak, nonatomic) IBOutlet UILabel *phoneTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleNumbeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *photonVesionLabel;
@property (nonatomic ,strong)WithdrawalAlertView *withDrawalAert;///smt&mesh



@end

@implementation PhoneTransferViewController
- (IBAction)buttonCLickWebPush:(id)sender {
    

}

- (IBAction)createButtonClick:(id)sender {//创建
    CreateViewController *wodesa = [[CreateViewController alloc]init];
    wodesa.amountValueStr = @"1";
    [self.navigationController pushViewController:wodesa animated:YES];

}
- (IBAction)listButtonCLick:(id)sender {//通道列表
    ChannelController *smtChannelVC = [[ChannelController alloc] init];
//    smtChannelVC.walletAddress = [WALLET.activeAccount.checksumAddress lowercaseString];
//    smtChannelVC.balance = _itemCurrent.balance;
    smtChannelVC.itemCurrent = self.itemCurrent;
    [self.navigationController pushViewController:smtChannelVC animated:YES];

}
- (IBAction)chooseBurttonCLick:(UIButton *)sender {
    if(self.isTypeCeools == NO){
        self.isTypeCeools = YES;
        _clooseTypeView = [[UIView alloc]initWithFrame:CGRectMake(15, self.chooseView.ddy_bottom, ScreenWidth-30, _arrayM.count*50)];
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
    
    NATModel *model = [_dataArray objectAtIndex:but.tag-1090];
    self.itemCurrent = model;
    
    self.tokenSMTMESHAddress = RAIDEN_SMT_CONTRACT_ADDRESS;
//    self.smtMesh.text = @"SMT";
    self.chooseSMTLabel.text = @"SMT";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _transViewBoos = NO;
    self.phoneIconLabel.backgroundColor = [UIColor orangeColor];
    self.phoneIconLabel.layer.cornerRadius = 5;
    [self.phoneIconLabel.layer setMasksToBounds:YES];
    self.phoneTypeLabel.textColor = UIColorFromRGB(0xFFFFFF);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(raidenStatusReload) name:@"RaidenStatusChange" object:nil];
    [self raidenStatusReload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)raidenStatusReload{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([RaidenManager sharedManager].raidenStatus.EthStatus==RaidenStatus_Connected) {
            self.phoneIconLabel.backgroundColor = rgba(126, 211, 33, 1);
            self.phoneTypeLabel.text = DDYLocalStr(@"photonsonline");
        }
        else if([RaidenManager sharedManager].raidenStatus.EthStatus==RaidenStatus_Unkown){
            self.phoneIconLabel.backgroundColor = rgba(204, 204, 204, 1);
            self.phoneTypeLabel.text = DDYLocalStr(@"photonsioffline");

        }
        else{
            self.phoneIconLabel.backgroundColor = rgba(204, 204, 204, 1);
            self.phoneTypeLabel.text = DDYLocalStr(@"photonsioffline");
        }
    });
}



- (IBAction)paymentButtonClick:(id)sender {
    
    self.tokenSMTMESHAddress = RAIDEN_SMT_CONTRACT_ADDRESS;

if (_addressTextField.text.length<5) {
        [self ff_HudText:[NSString stringWithFormat:@"%@",DDYLocalStr(@"CreateAlertEnterAll")] isLoading:NO hideDelay:0.7];
    return;
    }
    [self showLoading];
    self.tokenSMTMESHAddress = RAIDEN_SMT_CONTRACT_ADDRESS;

    [[RaidenManager sharedManager] transfersTrue:self.tokenSMTMESHAddress and:_addressTextField.text amout:_numberTextField.text dataStr:nil jsonStr:@"" resultBlock:^(BOOL success, id result, NSError *error) {
        [self dismissLoading];

        
        if ([[result objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]) {
            
            PhotonTransactionRecordsViewController *ohosad = [[PhotonTransactionRecordsViewController alloc]init];
            [self.navigationController pushViewController:ohosad animated:YES];
            
        }else if([[result objectForKey:@"error_code"] integerValue] == 1002 ||[[result objectForKey:@"error_code"] integerValue] == 3002){
           

            [[RaidenManager sharedManager]findPath:_addressTextField.text and:self.tokenSMTMESHAddress amout:_numberTextField.text dataStr:nil resultBlock:^(BOOL success, id result, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self dismissLoading];
                    
                    if (success) {
                        
                        NSDictionary *dict = result;

                        if([[dict objectForKey:@"error_code"] integerValue]== 0){
                            
                            NSData *data=[NSJSONSerialization dataWithJSONObject:[dict objectForKey:@"data"] options:NSJSONWritingPrettyPrinted error:nil];
                            self.jsonStr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            NSArray *array = [dict objectForKey:@"data"];
                            NSString *fee = [NSString stringWithFormat:@"%@",[[array objectAtIndex:0] objectForKey:@"fee"]];
                            self.fellStr = fee;
                            if([fee isEqualToString:@"0"]){
                                [[RaidenManager sharedManager] transfersNew:self.tokenSMTMESHAddress and:_addressTextField.text amout:_numberTextField.text dataStr:[NSString stringWithFormat:@"%@",[dict objectForKey:@"error_code"]] jsonStr:self.jsonStr resultBlock:^(BOOL success, id result, NSError *error) {
                                    if(success){
                                        PhotonTransactionRecordsViewController *ohosad = [[PhotonTransactionRecordsViewController alloc]init];
                                        [self.navigationController pushViewController:ohosad animated:YES];
                                    }else if([[result objectForKey:@"error_code"] integerValue]==1023){
                                        [self ff_HudText:DDYLocalStr(@"photonsuo1023") isLoading:NO hideDelay:2];
                                    }else if([[result objectForKey:@"error_code"] integerValue]==1020){
                                        [self ff_HudText:DDYLocalStr(@"photonsuo1020") isLoading:NO hideDelay:2];
                                    }else if([[result objectForKey:@"error_code"] integerValue]==2000){
                                        [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];
                                    }else if([[result objectForKey:@"error_code"] integerValue]==1016){
                                        [self ff_HudText:DDYLocalStr(@"photonOutofline") isLoading:NO hideDelay:2];
                                    }else if([[result objectForKey:@"error_code"] integerValue]==5027){
                                        [self ff_HudText:DDYLocalStr(@"photonsidesnode") isLoading:NO hideDelay:2];
                                        
                                    }else{
                                        [self ff_HudText:[NSString stringWithFormat:@"%@",[result objectForKey:@"error_message"]] isLoading:NO hideDelay:2];
                                    }
                                }];
                            }else{
                                [self ff_HudText:[NSString stringWithFormat:@"%@",[result objectForKey:@"error_message"]] isLoading:NO hideDelay:2];
                                
                            }
                            
                        }
                        
                    }else if([[result objectForKey:@"error_code"] integerValue]==1023){
                        [self ff_HudText:DDYLocalStr(@"photonsuo1023") isLoading:NO hideDelay:2];
                    }else if([[result objectForKey:@"error_code"] integerValue]==1020){
                        [self ff_HudText:DDYLocalStr(@"photonsuo1020") isLoading:NO hideDelay:2];
                    }else if([[result objectForKey:@"error_code"] integerValue]==2000){
                        [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];
                    }else if([[result objectForKey:@"error_code"] integerValue]==1016){
                        [self ff_HudText:DDYLocalStr(@"photonOutofline") isLoading:NO hideDelay:2];
                    }else if([[result objectForKey:@"error_code"] integerValue]==5027){
                        [self ff_HudText:DDYLocalStr(@"photonsidesnode") isLoading:NO hideDelay:2];
                    }else if([[result objectForKey:@"error_code"] integerValue]==3003){
                        [self ff_HudText:DDYLocalStr(@"photonsuo3003") isLoading:NO hideDelay:2];
                    }else if([[result objectForKey:@"error_code"] integerValue]==4000){
                        [self ff_HudText:DDYLocalStr(@"photonsuo3003") isLoading:NO hideDelay:2];
                    }else{
                        [self ff_HudText:[NSString stringWithFormat:@"%@",[result objectForKey:@"error_message"]] isLoading:NO hideDelay:2];
                    }
                });
                
            }];
            
        }else if([[result objectForKey:@"error_code"] integerValue]==1023){
            [self ff_HudText:DDYLocalStr(@"photonsuo1023") isLoading:NO hideDelay:2];
        }else if([[result objectForKey:@"error_code"] integerValue]==1020){
            [self ff_HudText:DDYLocalStr(@"photonsuo1020") isLoading:NO hideDelay:2];
        }else if([[result objectForKey:@"error_code"] integerValue]==2000){
            [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];
        }else if([[result objectForKey:@"error_code"] integerValue]==1016){
            [self ff_HudText:DDYLocalStr(@"photonOutofline") isLoading:NO hideDelay:2];
        }else if([[result objectForKey:@"error_code"] integerValue]==5027){
            [self ff_HudText:DDYLocalStr(@"photonsidesnode") isLoading:NO hideDelay:2];
            
        }else{
            [self ff_HudText:[NSString stringWithFormat:@"%@",[result objectForKey:@"error_message"]] isLoading:NO hideDelay:2];
        }
    }];
}
- (IBAction)obtainButtonClick:(id)sender {
    self.tokenSMTMESHAddress = RAIDEN_SMT_CONTRACT_ADDRESS;

    [[RaidenManager sharedManager]getChannelList:self.tokenSMTMESHAddress block:^(BOOL success, id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{

            if (success) {

                if (result && [result isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *arrarData = [[NSMutableArray alloc]init];
                    for(NSDictionary *dict in result){
                        if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]]isEqualToString:@"1"]){
                            [arrarData addObject:dict];
                        }
                    }
                    if(arrarData.count>0){

                    
                    if(_transViewBoos == NO){
                        _transViewBoos = YES;
                        int hieg;
                        if(arrarData.count>1){
                            hieg = 100;
                        }else{
                            hieg = 50;
                        }
                        self.transferView = [[PhoneTransferView alloc]initWithFrame:CGRectMake(15, self.addressTextField.ddy_bottom, ScreenWidth-30, arrarData.count*50)];
                        self.transferView.delegate = self;
                            self.transferView.dataArray = arrarData;
                        [self.view addSubview:self.transferView];
                    }else{
                        [self.transferView removeFromSuperview];
                        _transViewBoos = NO;

                    }
                        
                    }else{
                        [self ff_HudText:DDYLocalStr(@"photononochannel") isLoading:NO hideDelay:2];
                    }

                }else {
                    
                    [self ff_HudText:DDYLocalStr(@"photononochanneltoasr") isLoading:NO hideDelay:2];
                }

            }else {

                [_obtainButton setTitle:DDYLocalStr(@"photonobtain") forState:UIControlStateNormal];
                [self ff_HudText:DDYLocalStr(@"photononochannel") isLoading:NO hideDelay:2];

                //                [self showErrorText:DDYLocalStr(@"PoorNetWord")];
                //                [self ff_HudText:@"光子启动中" isLoading:NO hideDelay:0.7];
            }

        });
    }];
}




-(void)didpushAddress:(NSString *)addressText{
    [self.transferView removeFromSuperview];
    self.addressTextField.text = addressText;
    _transViewBoos = NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _numberTextField) {
        
        if ([string isEqualToString:@"."] && [textField.text rangeOfString:@"."].location != NSNotFound) {
            
            return NO;
        }
        else if ([string isEqualToString:@""]) {
            
            return YES;
        }
        else if ([string isEqualToString:@"."]) {
            return YES;
        }
        else if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            
            if (textField.text.length > [textField.text rangeOfString:@"."].location + 2) {
                
                return NO;
            }
            
        }else if (textField.text.length > 7) {
            return NO;
        }
    }
    return YES;
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField == _addressTextField) {
//
//        if (self.isSuccess) {
//
//            id result = [_ipWalletDictM objectForKey:[textField.text lowercaseString]];
//
//            if (result) {
//
//                _middleView.hidden = NO;
//            }
//        }
//    }
//}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    if(self.transferView !=nil){
        [self.transferView removeFromSuperview];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navTopHig.constant = 88;
    }
    NSDictionary *vesionDIct = [[RaidenManager sharedManager]getVesion];
    if([[NSString stringWithFormat:@"%@",[vesionDIct objectForKey:@"error_code"]]isEqualToString:@"0"]){
        self.photonVesionLabel.text = [NSString stringWithFormat:@"v%@",[[vesionDIct objectForKey:@"data"]objectForKey:@"version"]];
    }
    self.photonVesionLabel.textColor = BGTEXT;
    

    self.view.backgroundColor = BGCOLOT;
    self.titleNumbeiLabel.text = DDYLocalStr(@"homenumber");
    self.titleNumbeiLabel.textColor = BGTEXT;
    self.titleLabel.textColor = BGTEXT;
    self.titleLabel.text = DDYLocalStr(@"photonPay");
    self.chooseView.backgroundColor = UIColorFromRGB(0x1B272B);

    self.chooseSMTLabel.textColor = BUTTONBGCOLOR;
    self.chooseSMTLabel.text = @"SMT";
    self.bizhongLabel.textColor = BGTEXT;
    self.bizhongLabel.text = DDYLocalStr(@"currency");
    self.traAddress.textColor = TEXTALPHA;
    self.traAddress.text = DDYLocalStr(@"photonAddress");
    self.tfNumber.textColor = TEXTALPHA;
    self.tfNumber.text = DDYLocalStr(@"homenumber");
    self.lineLabel.backgroundColor = UIColorFromRGB(0xBAFFEC);
    self.lineLabel2.backgroundColor = UIColorFromRGB(0xBAFFEC);
    [self.obtainButton setTitleColor:UIColorFromRGB(0x5EBDA4) forState:UIControlStateNormal];
    [self.obtainButton setTitle:DDYLocalStr(@"photonobtain") forState:UIControlStateNormal];
    
    self.obtainButton.layer.cornerRadius = 10;//2.0是圆角的弧度，根据需求自己更改
    [self.obtainButton setBackgroundColor:UIColorFromRGB(0x1B272B)];
    NSString *holderText = DDYLocalStr(@"photonAddress");
    self.smtMesh.textColor = BGTEXT;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xE2EDEA)
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:15]
                        range:NSMakeRange(0, holderText.length)];
    self.addressTextField.attributedPlaceholder = placeholder;
    self.addressTextField.textColor = BGTEXT;
    self.addressTextField.delegate = self;
    [self.paymentButton setTitle:DDYLocalStr(@"photonPayPayis") forState:UIControlStateNormal];
    [self.paymentButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
    NSString *holderText1 = DDYLocalStr(@"TransferInputAmount");
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xE2EDEA)
                        range:NSMakeRange(0, holderText1.length)];
    [placeholder1 addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:15]
                        range:NSMakeRange(0, holderText1.length)];
    self.numberTextField.attributedPlaceholder = placeholder1;
    self.numberTextField.textColor = BGTEXT;
    self.numberTextField.delegate = self;
    self.numberTextField.keyboardType = UIKeyboardTypeDecimalPad;

    
    [self.paymentButton setBackgroundColor:BUTTONBGCOLOR];
    
    self.tokenSMTMESHAddress = RAIDEN_SMT_CONTRACT_ADDRESS;

        
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)qrButtonClick:(id)sender {//扫一扫
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [DDYAuthorityMaster cameraAuthSuccess:^{
//            NAQRCodeScanningVC *vc = [[NAQRCodeScanningVC alloc] init];
//
//            @weakly(self);
//            vc.qrMessageBlock = ^(NSString *value) {
//
//                @normally(self);
//                NSMutableDictionary *dict = [self handleQNResultMessageWithValue:value];
//
//                if (dict) {
//
//                    _addressTextField.text = [dict objectForKey:@"address"];
//                    _numberTextField.text = [dict objectForKey:@"amount"];
//                }
//
//                [self.navigationController popViewControllerAnimated:NO];
//            };
//
//            [self.navigationController pushViewController:vc animated:YES];
//        } fail:^{
//
//        } alertShow:YES];
//    });
    
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

- (IBAction)backPush:(id)sender {
    
    if(self.IsPushTrans == YES){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.withDrawalAert = [[WithdrawalAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.withDrawalAert.titleLabel.text = DDYLocalStr(@"QRCodeSavePhotoTip");

        [Tool animationAlert:self.withDrawalAert.bgView];
        self.withDrawalAert.textLabel.text = DDYLocalStr(@"transfer_toast");
        [self.withDrawalAert.withdrawalAlertCancleButton addTarget:self action:@selector(withAlertCancleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.withDrawalAert.withdrawalAlertShutDown addTarget:self action:@selector(withAlertCancleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.withDrawalAert];
    }
}

-(void)withAlertCancleButton:(UIButton *)but{
    [self.withDrawalAert removeFromSuperview];
    if(but.tag == 1779){
    }else{
        [[RaidenManager sharedManager]stop];
        [self.navigationController popViewControllerAnimated:YES];
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
