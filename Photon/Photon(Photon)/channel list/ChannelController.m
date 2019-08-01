//
//  ChannelController.m
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/4/11.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import "ChannelController.h"
#import "ChannelTableViewCell.h"
#import "NSObject+MJKeyValue.h"
#import "CreateViewController.h"
#import "RSMTAddNewViewController.h"
#import "PhotonTransactionRecordsViewController.h"
#import "ExtractAlertView.h"
#import "RChannelShutDownTableViewCell.h"
#import "RChannelToastTableViewCell.h"

#import "RChannelModel.h"

#import "ChannelDefaultTableViewCell.h"

#import "WithdrawalAlertView.h"
#import "ClosedAlertView.h"
#import "SettlementAlertView.h"

#import "IcountAlertView.h"
#import "PhoneTransferViewController.h"
#import "ChannelErrerAlertView.h"
#import "QRCodeViewController.h"

@interface ChannelController ()
{
    WithdrawalAlertView *_withdAlertView;
    ClosedAlertView *_closedAlertView;
    SettlementAlertView *_settlementAlertView;

    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态

    
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navtopHig;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navViewBg;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) RChannelModel *homeCurrentChannel;
@property (nonatomic, strong) RChannelModel *wthdrawaksChannel;
@property (nonatomic, strong) RChannelModel *closedAlertVIewChannel;
@property (nonatomic, strong) RChannelModel *settlementAlertVIewChannel;
@property (nonatomic, strong) RChannelModel *closedChannelStr;
@property (nonatomic, strong) RChannelModel *shutClosedDownCanclestr;

@property (nonatomic, strong) IcountAlertView *icountView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) NSString *tokenAddress;

@property (nonatomic, strong) NSMutableArray *ipWalletsM;
@property (nonatomic, strong) ExtractAlertView *extractView;
@property (nonatomic, strong) ChannelTableViewCell *channelCell;

@property (nonatomic, strong) RChannelShutDownTableViewCell *shutdownCell;
@property (nonatomic, strong) RChannelToastTableViewCell *toastCell;
@property (nonatomic, strong) ChannelDefaultTableViewCell *defaultCell;

@property (nonatomic, strong) ChannelErrerAlertView *errerAlertView;


@property (nonatomic, assign) BOOL isNetWork;

@property (nonatomic, strong) NSString *settled_block;
@property (nonatomic, strong) NSString *block_number;
@property (nonatomic ,strong)dispatch_source_t channelListTime;//  注意:此处应该使用强引用 strong

@property (nonatomic ,strong)NSString *tokenStrAddress;///smt&mesh
@property (weak, nonatomic) IBOutlet UIView *bgTopView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

////topView
@property (weak, nonatomic) IBOutlet UILabel *topChannelLabel;
@property (weak, nonatomic) IBOutlet UILabel *topChannelPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *topSMT;
@property (weak, nonatomic) IBOutlet UILabel *topMesh;
@property (weak, nonatomic) IBOutlet UILabel *topSMTLabel;
@property (weak, nonatomic) IBOutlet UILabel *topMeshLabel;

@property (weak, nonatomic) IBOutlet UILabel *topPhoneSMT;
@property (weak, nonatomic) IBOutlet UILabel *topPhoneMesh;
@property (weak, nonatomic) IBOutlet UILabel *topPhoneSMTLabel;
@property (weak, nonatomic) IBOutlet UILabel *topPhoneMeshLabel;

@property (weak, nonatomic) IBOutlet UIButton *transferButton;


@end

@implementation ChannelController
- (IBAction)transferButtonCLick:(id)sender {
    PhoneTransferViewController *phoner = [[PhoneTransferViewController alloc]init];
    phoner.IsPushTrans = YES;
    [self.navigationController pushViewController:phoner animated:YES];

}
- (IBAction)pushWebView:(id)sender {
    
    
}
- (IBAction)icountButtonClick:(id)sender {
    
    self.icountView = [[IcountAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [Tool animationAlert:self.icountView.bgView];
    self.icountView.extractToastLabel.text = DDYLocalStr(@"QRCodeSavePhotoTip");
    self.icountView.extractLabel.text = DDYLocalStr(@"phonelog");
    [self.icountView.extracetCancelButton addTarget:self action:@selector(icountCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.icountView.extracetDetermineButton addTarget:self action:@selector(icountDetermineButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.icountView];
    
}

-(void)icountCancelButtonClick{
    [self.icountView removeFromSuperview];
}
-(void)icountDetermineButtonClick{
    [self.icountView removeFromSuperview];
    [[RaidenManager sharedManager]debugUploadLogfile:^(BOOL success, id result, NSError *error) {
        if([[NSString stringWithFormat:@"%@",[result objectForKey:@"error_message"]]isEqualToString:@"SUCCESS"]){
            [self ff_HudText:DDYLocalStr(@"uploadsuccessfullog") isLoading:NO hideDelay:2];
        }else{
            [self ff_HudText:DDYLocalStr(@"uploadfailurefullog") isLoading:NO hideDelay:2];
        }
    }];
}

- (IBAction)qrCodeButtonClick:(id)sender {
    QRCodeViewController *qrcode = [[QRCodeViewController alloc]init];
    qrcode.walletAddress = [Tool getUserDefautsValueForKey:@"WALLET_ADDRESS"];
    [self.navigationController pushViewController:qrcode animated:YES];
}
#pragma mark - setupRefresh
- (void)setupRefresh
{
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadChannels)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    header.automaticallyChangeAlpha = YES;
//    _tableView.mj_header = header;
}

- (IBAction)backPush:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addChannelClick:(id)sender {
    PhotonTransactionRecordsViewController *photon = [[PhotonTransactionRecordsViewController alloc]init];
//    photon.itemCurrent = self.isSmt;
    [self.navigationController pushViewController:photon animated:YES];
}
- (IBAction)photonPushClick:(id)sender {
    CreateViewController *create = [[CreateViewController alloc]init];
    create.itemCurrent = self.itemCurrent;
    create.aumontDict = self.amountDict;
    create.amountValueStr = self.amountValueStr;
    [self.navigationController pushViewController:create animated:YES];
}


- (NSMutableArray *)channels
{
    if (!_channels) {
        NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
        
        _channels = tmpArr;
    }
    return _channels;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    [self.transferButton setTitle:DDYLocalStr(@"photonPayPayis") forState:UIControlStateNormal];
    [self.transferButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
    [self.transferButton setBackgroundColor:BUTTONBGCOLOR];
    self.bgTopView.backgroundColor = [UIColorFromRGB(0x66CFB2)colorWithAlphaComponent:0.1f];
    self.tableView.backgroundColor = BGCOLOT;
    self.bgTopView.layer.cornerRadius =6;
    //将多余的部分切掉
    self.titleLabel.text = DDYLocalStr(@"photonicnetwork");
    self.titleLabel.textColor = BGTEXT;
    self.typeLabel.text = DDYLocalStr(@"photonsonline");
    self.typeLabel.textColor = BGTEXT;

    
    self.view.backgroundColor = BGCOLOT;
    self.bgTopView.layer.masksToBounds = YES;
    
    
    self.topChannelLabel.text = DDYLocalStr(@"totalchannelbalance");
    self.topChannelLabel.textColor = BUTTONBGCOLOR;
    self.topSMT.text = @"SMT";
    self.topSMT.textColor = BUTTONBGCOLOR;
    self.topMesh.text = @"MESH";
    self.topMesh.textColor = BUTTONBGCOLOR;
    self.topSMTLabel.textColor = BGTEXT;
    self.topMeshLabel.textColor = BGTEXT;

    
    self.topChannelPhoneLabel.text = DDYLocalStr(@"addChainbalance");
    self.topChannelPhoneLabel.textColor = UIColorFromRGB(0x66CFB2);
    self.topPhoneSMT.text = @"SMT";
    self.topPhoneSMT.textColor = BUTTONBGCOLOR;
    self.topPhoneMesh.text = @"MESH";
    self.topPhoneMesh.textColor = BUTTONBGCOLOR;
    self.topPhoneSMTLabel.textColor = BGTEXT;
    self.topPhoneMeshLabel.textColor = BGTEXT;
   
    
    self.tokenStrAddress = RAIDEN_SMT_CONTRACT_ADDRESS;

    
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navtopHig.constant = 88;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)receiveNotification:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadChannels];
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navtopHig.constant = 88;
    }

    self.iconImage.backgroundColor = [UIColor orangeColor];
    self.iconImage.layer.cornerRadius = 5;
    [self.iconImage.layer setMasksToBounds:YES];
    

    self.tokenStrAddress = RAIDEN_SMT_CONTRACT_ADDRESS;


    
    dispatch_queue_t meshqueue = dispatch_get_main_queue();
    dispatch_source_t timerMesh = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, meshqueue);
    dispatch_source_set_timer(timerMesh, DISPATCH_TIME_NOW, 14.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timerMesh, ^{
        NSLog(@"刷新通道列表");
        [self loadChannels];
    });
    //4.开始执行
    dispatch_resume(timerMesh);
    self.channelListTime = timerMesh;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(raidenStatusReload) name:@"RaidenStatusChange" object:nil];
    [self raidenStatusReload];
    
    //通知中心是个单例
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"NOTAAIFY" object:nil];


}

-(void)raidenStatusReload{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([RaidenManager sharedManager].raidenStatus.EthStatus==RaidenStatus_Connected) {
            self.iconImage.backgroundColor = rgba(126, 211, 33, 1);
            self.iconLabel.text = DDYLocalStr(@"photonsonline");
            self.isNetWork = NO;
        }
        else if([RaidenManager sharedManager].raidenStatus.EthStatus==RaidenStatus_Unkown){
            self.iconImage.backgroundColor = rgba(204, 204, 204, 1);
            self.iconLabel.text = DDYLocalStr(@"photonsioffline");
            self.isNetWork = YES;
        }
        else{
            self.iconImage.backgroundColor = rgba(204, 204, 204, 1);
            self.iconLabel.text = DDYLocalStr(@"photonsioffline");
            self.isNetWork = YES;
        }
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_cancel(self.channelListTime);
    NSLog(@"停止轮训");
}

- (void)loadChannels
{

    [[RaidenManager sharedManager]getChannelList:nil block:^(BOOL success, id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [_tableView.mj_header endRefreshing];
            [self dismissLoading];
            if (success) {
                
                if (result && [result isKindOfClass:[NSArray class]]) {
                    
                    NSArray *resultArr = (NSArray *)result;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSMutableArray *arrayM = [RChannelModel mj_objectArrayWithKeyValuesArray:resultArr];
                        
                        self.channels = arrayM;
                        [self.tableView reloadData];
                    });
                    
                }else {
                    
                    [self ff_HudText:@"getChannelList数据为nil" isLoading:NO hideDelay:2];
                }
                
            }else {
                
            }
            
        });
    }];
    
    [[RaidenManager sharedManager]getAssetsOnToken:@"" token:^(BOOL success, id result, NSError *error) {
        if (success) {
            
            
            if(![[NSString stringWithFormat:@"%@",[result objectForKey:@"data"]]isEqualToString:@"<null>"]){
                
                NSArray *array = [result objectForKey:@"data"];
                
                for(NSDictionary *dict in array){
                    if([[[dict objectForKey:@"token_address"]lowercaseString] isEqualToString:[RAIDEN_SMT_CONTRACT_ADDRESS lowercaseString]]){
                        dispatch_async(dispatch_get_main_queue(), ^{

                        self.topSMTLabel.text = [NSString stringWithFormat:@"%@",[Tool powStr:[dict objectForKey:@"balance_in_photon"] has:18]];
                            [Tool saveUserDefaultsValue:self.topSMTLabel.text forKey:@"SMTBALANCEPHOTON"];
                        self.topPhoneSMTLabel.text = [NSString stringWithFormat:@"%@",[Tool powStr:[dict objectForKey:@"balance_on_chain"] has:18]];
                            [Tool saveUserDefaultsValue:self.topPhoneSMTLabel.text forKey:@"SMTBALANCECHAIN"];
                        });

                    }else{
                        
                    }
                }
                
            }
        }else {
            self.topSMTLabel.text = [Tool getUserDefautsValueForKey:@"SMTBALANCEPHOTON"];
            self.topPhoneSMTLabel.text = [Tool getUserDefautsValueForKey:@"SMTBALANCECHAIN"];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == self.channels.count){
        return 10;
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 10;
    }else{
        return 5;
    }
}


-(void)channelAddButtonClick:(RChannelModel *)channelModel{//////补充
    RSMTAddNewViewController *addVC = [[RSMTAddNewViewController alloc] init];
    addVC.channel = channelModel;
//    addVC.itemCurrent = self.isSmt;
    addVC.aumontDict = self.amountDict;
    addVC.amountValueStr = self.amountValueStr;
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)listRecordButtonCLick{////交易记录
    PhotonTransactionRecordsViewController *photonVC = [[PhotonTransactionRecordsViewController alloc]init];
//    photonVC.itemCurrent = self.itemCurrent;
    photonVC.isPhoton = YES;
    [self.navigationController pushViewController:photonVC animated:YES];
    
}


-(void)channelWithdrawalButtonClick:(RChannelModel *)channel{//////提现按钮
    if([channel.balance doubleValue]>0){
    if(self.isNetWork == NO){
    self.wthdrawaksChannel = channel;
    
    
    _withdAlertView = [[WithdrawalAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _withdAlertView.titleLabel.text = DDYLocalStr(@"determinewithdrawal");
    if([channel.token_address caseInsensitiveCompare:RAIDEN_SMT_CONTRACT_ADDRESS] == NSOrderedSame){
        self.isSmt = @"SMT";
    }else{
        self.isSmt = @"MESH";
    }
    [Tool animationAlert:_withdAlertView.bgView];
    _withdAlertView.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@,%@",DDYLocalStr(@"entirebalance"),[Tool powStr:[NSString stringWithFormat:@"%@",self.homeCurrentChannel.balance] has:18],self.isSmt,DDYLocalStr(@"chanleTrading")];
    [_withdAlertView.withdrawalAlertCancleButton addTarget:self action:@selector(withAlertCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_withdAlertView.withdrawalAlertShutDown addTarget:self action:@selector(withAlertCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_withdAlertView];
        
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
    }else{
        [self ff_HudText:DDYLocalStr(@"photon1") isLoading:NO hideDelay:2];

    }
}

-(void)withAlertCancleButton:(UIButton *)but{//////提现按钮
    if(self.isNetWork == NO){
    if(but.tag == 1779){
        [_withdAlertView removeFromSuperview];
    }else{
        [_withdAlertView removeFromSuperview];

        [[RaidenManager sharedManager] getWithdraw:self.homeCurrentChannel.channel_identifier and:self.homeCurrentChannel.balance resultBlock:^(BOOL success, id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissLoading];
                if(success == YES){
                    
                   
                    
                    [self listRecordButtonCLick];
                }else if ([[result objectForKey:@"error_code"] integerValue]==2000){
                    [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];

                }else{
                    NSString *strToastErrer;
                    if([[result objectForKey:@"error_code"] integerValue]==1016){
                        strToastErrer = DDYLocalStr(@"photonOutofline");
                    }else if([[result objectForKey:@"error_code"] integerValue]==5024){
                        strToastErrer = DDYLocalStr(@"chanlewtransactions");
                    }else if([[result objectForKey:@"error_code"] integerValue]==5001){
                        strToastErrer = DDYLocalStr(@"photonsuo5001");
                    }else{
                        strToastErrer = [result objectForKey:@"error_message"];
                    }
                    _closedAlertView = [[ClosedAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    _closedAlertView.closedAlertViewTitle.text = DDYLocalStr(@"QRCodeSavePhotoTip");
                    [Tool animationAlert:_closedAlertView.bgView];
                    if([self.homeCurrentChannel.token_address caseInsensitiveCompare:RAIDEN_SMT_CONTRACT_ADDRESS] == NSOrderedSame){
                        self.isSmt = @"SMT";
                    }else{
                        self.isSmt = @"MESH";
                    }
                    _closedAlertView.closedAlertViewText.text = [NSString stringWithFormat:@"*%@",DDYLocalStr(@"chanlewwmandatoryClosetoast")];
                    _closedAlertView.closedAlertViewText2.text = [NSString stringWithFormat:@"*%@",strToastErrer];

                    [_closedAlertView.closedAlertViewCancleButton addTarget:self action:@selector(closedCancleButton:) forControlEvents:UIControlEventTouchUpInside];
                    [_closedAlertView.closedAlertViewButton addTarget:self action:@selector(closedCancleButton:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:_closedAlertView];
                }

            });
        }];
    }
    
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)closedCancleButton:(UIButton *)but{//////提现失败调用强制关闭
    if(self.isNetWork == NO){
    [_closedAlertView removeFromSuperview];

    if(but.tag == 1779){
        [_closedAlertView removeFromSuperview];
    }else{
        /////提现失败 启用强制关闭通道提现
        [self closedChannelList:self.homeCurrentChannel];
        [self loadChannels];
    }
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}


///关闭通道和强制关闭通道
-(void)closeChannelISMandatory:(BOOL)smandatory is:(RChannelModel *)channelIdentifier{
    if(self.isNetWork == NO){
    [self showLoading];
    [[RaidenManager sharedManager] closeChannel:channelIdentifier.channel_identifier has:smandatory resultBlock:^(BOOL success, id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissLoading];
            if (success) {
               
//                [_tableView.mj_header beginRefreshing];
                [self loadChannels];
                
                
                [self listRecordButtonCLick];
                
            }else if([[result objectForKey:@"error_code"] integerValue]==2000){
                [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];
            }else{
                NSString *strToastErrer;
                if([[result objectForKey:@"error_code"] integerValue]==2999){
                    strToastErrer = DDYLocalStr(@"photon2999");
                }else if([[result objectForKey:@"error_code"] integerValue]==5001){
                    strToastErrer = DDYLocalStr(@"photonsuo5001");
                }else if([[result objectForKey:@"error_code"] integerValue]==5025){
                    strToastErrer = DDYLocalStr(@"photonsuo");
                }else if([[result objectForKey:@"error_code"] integerValue]==5024){
                    strToastErrer = DDYLocalStr(@"chanlewtransactions");
                }else if([[result objectForKey:@"error_code"] integerValue]==5027){
                    strToastErrer = DDYLocalStr(@"photonsidesnode");
                }else if([[result objectForKey:@"error_code"] integerValue]==3005){
                    strToastErrer = DDYLocalStr(@"photonChannelalready");
                }else if([[result objectForKey:@"error_code"] integerValue]==1016){
                    strToastErrer = DDYLocalStr(@"photonOutofline");
                }else{
                    strToastErrer = [result objectForKey:@"error_message"];
                }
                [self loadChannels];
                
                self.closedChannelStr = channelIdentifier;
                _closedAlertView = [[ClosedAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                [Tool animationAlert:_closedAlertView.bgView];

                _closedAlertView.closedAlertViewTitle.text = DDYLocalStr(@"chanlewClosefailure");
                _closedAlertView.closedAlertViewText.text = [NSString stringWithFormat:@"*%@",DDYLocalStr(@"chanlewwmandatoryClosetoast")];
                _closedAlertView.closedAlertViewText2.text = [NSString stringWithFormat:@"*%@",strToastErrer];
                [_closedAlertView.closedAlertViewCancleButton addTarget:self action:@selector(closedButton:) forControlEvents:UIControlEventTouchUpInside];
                [_closedAlertView.closedAlertViewButton addTarget:self action:@selector(closedButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_closedAlertView];
            }
        });
    }];
        
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)closedButton:(UIButton *)but{
    if(self.isNetWork == NO){
    [_closedAlertView removeFromSuperview];
    if(but.tag == 1779){
    }else{
        [self closedChannelList:self.closedChannelStr];////关闭失败调用强制关闭按钮
    }
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)channelShutDownButtonClick:(RChannelModel *)channel{//////三按钮关闭按钮+强制关闭
    if(self.isNetWork == NO){
    
    self.closedAlertVIewChannel = channel;
    
    _withdAlertView = [[WithdrawalAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _withdAlertView.titleLabel.text = DDYLocalStr(@"nochanlewClosefailure");
    _withdAlertView.textLabel.text = [NSString stringWithFormat:@"%@",DDYLocalStr(@"chanlewClosetoast")];
    [_withdAlertView.withdrawalAlertCancleButton addTarget:self action:@selector(shutDownCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [Tool animationAlert:_withdAlertView.bgView];
    [_withdAlertView.withdrawalAlertCancleButton setTitle:DDYLocalStr(@"SignupCancel") forState:UIControlStateNormal];
    [_withdAlertView.withdrawalAlertShutDown addTarget:self action:@selector(shutDownCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_withdAlertView.withdrawalAlertShutDown setTitle:DDYLocalStr(@"SignupOK") forState:UIControlStateNormal];
    [self.view addSubview:_withdAlertView];
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)shutDownCancleButton:(UIButton *)but{
    if(self.isNetWork == NO){
    [_withdAlertView removeFromSuperview];
    if(but.tag == 1779){
    }else{
        [self closeChannelISMandatory:false is:self.closedAlertVIewChannel];
    }
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)closedChannelList:(RChannelModel *)channel{////只支持强制关闭通道
    if(self.isNetWork == NO){
    [[RaidenManager sharedManager] closeChannel:channel.channel_identifier has:true resultBlock:^(BOOL success, id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissLoading];
            if (success) {
                [self loadChannels];
                
                [self listRecordButtonCLick];
                
                
            }else if([[result objectForKey:@"error_code"] integerValue]==2999){
                [self ff_HudText:DDYLocalStr(@"photon2999") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==5001){
                [self ff_HudText:DDYLocalStr(@"photonsuo5001") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==5024){
                [self ff_HudText:DDYLocalStr(@"chanlewtransactions") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==5027){
                [self ff_HudText:DDYLocalStr(@"photonsidesnode") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==3005){
                [self ff_HudText:DDYLocalStr(@"photonChannelalready") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==1016){
                [self ff_HudText:DDYLocalStr(@"photonOutofline") isLoading:NO hideDelay:2];
            }else if([[result objectForKey:@"error_code"] integerValue]==2000){
                [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];
            }else{
                [self ff_HudText:DDYLocalStr(@"chanlewmandatoryClosetoast") isLoading:NO hideDelay:2];
            }
        });
    }];
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)closedButtonClick:(RChannelModel *)channel{//单个按钮是否强制关闭按钮
    if(self.isNetWork == NO){
    self.shutClosedDownCanclestr = channel;
    _withdAlertView = [[WithdrawalAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _withdAlertView.titleLabel.text = DDYLocalStr(@"whetherchanlewmandatoryClosetoast");
    _withdAlertView.textLabel.text = [NSString stringWithFormat:@"%@",DDYLocalStr(@"chanlewwmandatoryClosetoast")];
    [_withdAlertView.withdrawalAlertCancleButton addTarget:self action:@selector(shutClosedDownCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [Tool animationAlert:_withdAlertView.bgView];
    [_withdAlertView.withdrawalAlertCancleButton setTitle:DDYLocalStr(@"SignupCancel") forState:UIControlStateNormal];
    [_withdAlertView.withdrawalAlertShutDown addTarget:self action:@selector(shutClosedDownCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_withdAlertView.withdrawalAlertShutDown setTitle:DDYLocalStr(@"SignupOK") forState:UIControlStateNormal];
    [self.view addSubview:_withdAlertView];
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)shutClosedDownCancleButton:(UIButton *)but{//单个按钮是否强制关闭按钮
    if(self.isNetWork == NO){
    [_withdAlertView removeFromSuperview];
    if(but.tag == 1779){
    }else{
        
        [self closedChannelList:self.shutClosedDownCanclestr];
    }
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)settlementButtonClick:(RChannelModel *)channel{///立即结算
    if(self.isNetWork == NO){
    self.settlementAlertVIewChannel = channel;
    _settlementAlertView = [[SettlementAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [_settlementAlertView.settlementCancleButton addTarget:self action:@selector(settlementCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [Tool animationAlert:_settlementAlertView.bgView];
    [_settlementAlertView.settlementButton addTarget:self action:@selector(settlementCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settlementAlertView];
        
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)settlementCancleButton:(UIButton *)but{///立即结算按钮
    if(self.isNetWork == NO){
    [_settlementAlertView removeFromSuperview];

    if(but.tag == 1779){
    }else{
        ///立即结算按钮
        [[RaidenManager sharedManager]settleChannel:self.settlementAlertVIewChannel.channel_identifier resultBlock:^(BOOL success, id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(success){
                    PhotonTransactionRecordsViewController *photonVC = [[PhotonTransactionRecordsViewController alloc]init];
                    photonVC.isPhoton = YES;
                    [self.navigationController pushViewController:photonVC animated:YES];
                    
                }else if([[result objectForKey:@"error_code"] integerValue]==2999){
                    [self ff_HudText:DDYLocalStr(@"photon2999") isLoading:NO hideDelay:2];
                }else if([[result objectForKey:@"error_code"] integerValue]==5001){
                    [self ff_HudText:DDYLocalStr(@"photonsuo5001") isLoading:NO hideDelay:2];
                }else if([[result objectForKey:@"error_code"] integerValue]==5024){
                    [self ff_HudText:DDYLocalStr(@"chanlewtransactions") isLoading:NO hideDelay:2];
                }else if([[result objectForKey:@"error_code"] integerValue]==5027){
                    [self ff_HudText:DDYLocalStr(@"photonsidesnode") isLoading:NO hideDelay:2];
                }else if([[result objectForKey:@"error_code"] integerValue]==3005){
                    [self ff_HudText:DDYLocalStr(@"photonChannelalready") isLoading:NO hideDelay:2];
                }else if([[result objectForKey:@"error_code"] integerValue]==1016){
                    [self ff_HudText:DDYLocalStr(@"photonOutofline") isLoading:NO hideDelay:2];
                }else if([[result objectForKey:@"error_code"] integerValue]==2000){
                    [self ff_HudText:DDYLocalStr(@"photononogas") isLoading:NO hideDelay:2];
                }else{
                    [self ff_HudText:DDYLocalStr(@"chanleSettlementfailures") isLoading:NO hideDelay:2];
                }
                
            });
        }];
    }
    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
}

-(void)pushPhotonVC{
    PhotonTransactionRecordsViewController *photonVC = [[PhotonTransactionRecordsViewController alloc]init];
    photonVC.itemCurrent = self.isSmt;
    photonVC.isPhoton = YES;
    [self.navigationController pushViewController:photonVC animated:YES];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RChannelModel *channel = [self.channels objectAtIndex:indexPath.section];
    __block ChannelController *blockSelf = self;

    
    if([channel.state integerValue] == 1){///三按钮
        
            self.channelCell = [ChannelTableViewCell initChannelTableViewCellTableViewCell:tableView];
            self.channelCell.channelPartnerAddressLabel.text = channel.partner_address;
            self.channelCell.channelValueLabel.text = [Tool powStr:channel.balance has:18];
            if([channel.token_address caseInsensitiveCompare:RAIDEN_SMT_CONTRACT_ADDRESS] == NSOrderedSame){
                self.channelCell.channelSysmelLabel.text = @"SMT";
            }else{
                self.channelCell.channelSysmelLabel.text = @"MESH";
            }

            if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"1"]){
                [self.channelCell.waitingImageButton setBackgroundImage:[UIImage imageNamed:@"waiting_phone"] forState:UIControlStateNormal];
                [self.channelCell.waitingImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }else if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"3"]||[[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"4"]){
                [self.channelCell.errerImageButton setBackgroundImage:[UIImage imageNamed:@"errer_photon"] forState:UIControlStateNormal];
                [self.channelCell.errerImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            }
            
            if([channel.locked_amount integerValue]>0&&[channel.partner_locked_amount integerValue]>0){
                self.channelCell.rollOutImageView.hidden = NO;
                self.channelCell.intoImageVIew.hidden = NO;
            }else if([channel.locked_amount integerValue]>0){
                self.channelCell.rollOutImageView.hidden = YES;
                self.channelCell.intoImageVIew.hidden = NO;
            }else if([channel.partner_locked_amount integerValue]>0){
                self.channelCell.rollOutImageView.hidden = NO;
                self.channelCell.intoImageVIew.hidden = YES;
            }else{

            }

            self.channelCell.channelAddBlock = ^{//补充
                blockSelf.homeCurrentChannel = channel;

                [blockSelf channelAddButtonClick:blockSelf.homeCurrentChannel];
                };
            
            self.channelCell.channelWithdrawalBlock = ^{//提现
                blockSelf.homeCurrentChannel = channel;

                [blockSelf channelWithdrawalButtonClick:blockSelf.homeCurrentChannel];
            };
            self.channelCell.channelShutDownBlock = ^{//关闭
                blockSelf.homeCurrentChannel = channel;

                [blockSelf channelShutDownButtonClick:blockSelf.homeCurrentChannel];
            };
            return self.channelCell;
        
    }else if([channel.state integerValue] == 2||[channel.state integerValue] == 4||[channel.state integerValue] == 5){
        
        if([channel.state integerValue] == 2){
            
            
                self.shutdownCell = [RChannelShutDownTableViewCell initRChannelShutDownTableViewCellTableViewCell:tableView];
                if([channel.token_address caseInsensitiveCompare:RAIDEN_SMT_CONTRACT_ADDRESS] == NSOrderedSame){

                    self.shutdownCell.shutDownSyselLabel.text = @"SMT";
                }else{
                    self.shutdownCell.shutDownSyselLabel.text = @"MESH";
                }
                
                if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"1"]){
                    [self.shutdownCell.waitingImageButton setBackgroundImage:[UIImage imageNamed:@"waiting_phone"] forState:UIControlStateNormal];
                    [self.shutdownCell.waitingImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

                    
                }else if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"3"]||[[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"4"]){
                    [self.shutdownCell.errerImageButton setBackgroundImage:[UIImage imageNamed:@"errer_photon"] forState:UIControlStateNormal];
                    [self.shutdownCell.errerImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

                }
                self.block_number = channel.block_number_now;
                self.settled_block = channel.block_number_channel_can_settle;

                self.shutdownCell.shutDownButton.hidden = NO;
                
                
                    if([self.block_number integerValue]>=[self.settled_block integerValue]){
                        

                        self.shutdownCell.shutDownClickBlock = ^{
                            [blockSelf settlementButtonClick:channel];
                        };

                        self.shutdownCell.shutDownAddressLabel.text = channel.partner_address;
                        self.shutdownCell.shutDownAmountLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",channel.balance] has:18];
                        self.shutdownCell.shutDownButton.hidden = NO;
                        self.shutdownCell.shutDownTypeLabel.text = DDYLocalStr(@"chanleokSettlement");

                        [self.shutdownCell.shutDownButton setTitle:DDYLocalStr(@"chanleimmediatelySettlement") forState:UIControlStateNormal];
                        self.shutdownCell.shutToastLabel.text = DDYLocalStr(@"chanleiclosemmediatelySettlement");
                        
                    }else{
                        self.shutdownCell.shutDownAddressLabel.text = channel.partner_address;
                        self.shutdownCell.shutDownAmountLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",channel.balance] has:18];
                        self.shutdownCell.shutDownTypeLabel.text = DDYLocalStr(@"Syncing block");

                        self.shutdownCell.shutToastLabel.text = [NSString stringWithFormat:@"%@...%@(%@)/%@(%@)",DDYLocalStr(@"chanlePleasewaitnumber"),self.block_number,DDYLocalStr(@"chanlecurrentblock"),self.settled_block,DDYLocalStr(@"chanleSettlementblocks")];
                        self.shutdownCell.shutDownButton.hidden = YES;
                    }
                
                return self.shutdownCell;
        }else{
            
                self.toastCell = [RChannelToastTableViewCell initRChannelRChannelToastTableViewCellTableViewCell:tableView];
                self.toastCell.toastAddressLabel.text = channel.partner_address;
                self.toastCell.toastAmountLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",channel.balance] has:18];
                
                if([channel.token_address caseInsensitiveCompare:RAIDEN_SMT_CONTRACT_ADDRESS] == NSOrderedSame){
                    self.toastCell.toastSyselLabel.text = @"SMT";
                }else{
                    self.toastCell.toastSyselLabel.text = @"MESH";
                }

                if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"1"]){
                    [self.toastCell.waitingImageButton setBackgroundImage:[UIImage imageNamed:@"waiting_phone"] forState:UIControlStateNormal];
                    [self.toastCell.waitingImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"3"]||[[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"4"]){
                    [self.toastCell.errerImageButton setBackgroundImage:[UIImage imageNamed:@"errer_photon"] forState:UIControlStateNormal];
                    [self.toastCell.errerImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

                }

                if([channel.state integerValue] == 4){
//                    self.toastCell.toastTypeLabel.text = DDYLocalStr(@"chanleclosedinthe");

                    self.toastCell.toastLabel.text = DDYLocalStr(@"chanleSettlemenclosetblocks");
                }else{
//                    self.toastCell.toastTypeLabel.text = DDYLocalStr(@"chanlesettlementinthe");

                    self.toastCell.toastLabel.text = DDYLocalStr(@"chanlchaneesettlementinthe");
                }
                return self.toastCell;
                
            
            
        }
        
    }else if([channel.state integerValue] == 6||[channel.state integerValue] == 7||[channel.state integerValue] == 11||[channel.state integerValue] == 12){

        self.shutdownCell = [RChannelShutDownTableViewCell initRChannelShutDownTableViewCellTableViewCell:tableView];
        self.shutdownCell.shutDownAddressLabel.text = channel.partner_address;
        self.shutdownCell.shutDownAmountLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",channel.balance] has:18];
        
        if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"1"]){
            [self.shutdownCell.waitingImageButton setBackgroundImage:[UIImage imageNamed:@"waiting_phone"] forState:UIControlStateNormal];
            [self.shutdownCell.waitingImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            
        }else if([[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"3"]||[[NSString stringWithFormat:@"%@",channel.delegate_state] isEqualToString:@"4"]){
            [self.shutdownCell.errerImageButton setBackgroundImage:[UIImage imageNamed:@"errer_photon"] forState:UIControlStateNormal];
            [self.shutdownCell.errerImageButton addTarget:self action:@selector(waitingImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        }

        if([channel.token_address caseInsensitiveCompare:RAIDEN_SMT_CONTRACT_ADDRESS] == NSOrderedSame){
            self.shutdownCell.shutDownSyselLabel.text = @"SMT";
        }else{
            self.shutdownCell.shutDownSyselLabel.text = @"MESH";
        }
        [self.shutdownCell.shutDownButton setTitle:DDYLocalStr(@"whetherchanlewmandatoryClosetoast") forState:UIControlStateNormal];

        self.shutdownCell.shutDownClickBlock = ^{
//            @strongly(self);
            [blockSelf closedButtonClick:channel];
        };

        if([channel.state integerValue] == 6){
            self.shutdownCell.shutDownTypeLabel.text = DDYLocalStr(@"chanleWithdrawalof");
            self.shutdownCell.shutToastLabel.text = DDYLocalStr(@"chanleWithdrawaloftoastclose");
        }else if ([channel.state integerValue] == 7){
            self.shutdownCell.shutDownTypeLabel.text = DDYLocalStr(@"chanleclosedinthe");
            self.shutdownCell.shutToastLabel.text = DDYLocalStr(@"chanleclosemandatory");
        }else if ([channel.state integerValue] == 11){
            self.shutdownCell.shutDownTypeLabel.text = DDYLocalStr(@"chanleclosedinthe");
            self.shutdownCell.shutToastLabel.text = DDYLocalStr(@"chanletoclosemandatory");
        }else{
            self.shutdownCell.shutDownTypeLabel.text = DDYLocalStr(@"chanleWithdrawalof");
            self.shutdownCell.shutToastLabel.text = DDYLocalStr(@"chanletoWithdrawalof");
        }
        
        return self.shutdownCell;
        
    }else{
        self.defaultCell = [ChannelDefaultTableViewCell initChannelDefaultTableViewCellTableViewCell:tableView];
        return self.defaultCell;
    }
}

-(void)waitingImageButtonClick:(UIButton *)but{
    
    self.errerAlertView = [[ChannelErrerAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [Tool animationAlert:self.errerAlertView.bgView];
    self.errerAlertView.titleLabel.text = DDYLocalStr(@"QRCodeSavePhotoTip");
    if(but.tag == 1990){
        self.errerAlertView.textLabel.text = DDYLocalStr(@"chanleseterrerALert");
    }else{
        self.errerAlertView.textLabel.text = DDYLocalStr(@"chanleseterrerALert1");
    }
    [self.errerAlertView.okButton addTarget:self action:@selector(errerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.errerAlertView];
}
-(void)errerButtonClick:(UIButton *)but{
    [self.errerAlertView removeFromSuperview];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RChannelModel *channel = self.channels[indexPath.section];
    

    if([channel.state integerValue] == 1){///默认3按钮
        
            return 143;
       
    }else if([channel.state integerValue] == 2||[channel.state integerValue] == 4||[channel.state integerValue] == 5){
        if([channel.state integerValue] == 2){
            
            if([self.block_number integerValue]>=[self.settled_block integerValue]){
                return 181;
            }else{
                return 140;
            }
            
        }else{
            return 161;
        }
        
    }else if([channel.state integerValue] == 6||[channel.state integerValue] == 7||[channel.state integerValue] == 11||[channel.state integerValue] == 12){
        return 181;
    }
    return 83;
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

- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
