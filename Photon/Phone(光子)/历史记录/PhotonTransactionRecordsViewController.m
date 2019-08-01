//
//  PhotonTransactionRecordsViewController.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/1.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "PhotonTransactionRecordsViewController.h"
#import "SpectrumTradingTableViewCell.h"
#import "ChannelController.h"

#import "PhotonNoDataTableViewCell.h"
#import "SupplementTableViewCell.h"
#import "PhoneTransferViewController.h"


@interface PhotonTransactionRecordsViewController ()
{
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态
}
@property (weak, nonatomic) IBOutlet UIButton *photonButton;
@property (weak, nonatomic) IBOutlet UIButton *spectrum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHigTop;
@property (weak, nonatomic) IBOutlet UIView *titleViewBg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopHig;
@property (weak, nonatomic) IBOutlet UILabel *photonLabel;
@property (weak, nonatomic) IBOutlet UILabel *spectrumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic,strong)SpectrumTradingTableViewCell *spectrumCell;
@property (nonatomic,strong)NSMutableArray *transactionArray;
@property (nonatomic,strong)NSArray *dataArraytransaction;
@property (nonatomic,assign)BOOL isTrading;
@property (nonatomic,strong)PhotonNoDataTableViewCell *nodataCell;
@property (nonatomic,strong)SupplementTableViewCell *supplementCell;
@property (nonatomic,strong)NSString *tokenStrAddress;


@end

@implementation PhotonTransactionRecordsViewController

- (instancetype)init{
    // 设置导航栏
    _statusBarStyle = UIStatusBarStyleLightContent;
    return  [super init];
}
#pragma mark -- 设置导航栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}
- (IBAction)tradingButtonClick:(UIButton *)sender {
    
    if(sender.tag == 1891){
//        [self.photonButton setTitleColor:BGTEXT forState:UIControlStateNormal];
        self.photonButton.alpha = 1;
        self.spectrum.alpha = 0.5;
        self.photonLabel.hidden = NO;
        self.spectrumLabel.hidden = YES;
        self.isTrading = NO;
         [self updataPhoton];
    }else{
        self.isTrading = YES;
        self.photonButton.alpha = 0.5;
        self.spectrum.alpha = 1;
//        [self.spectrum setTitleColor:UIColorFromRGB(0x3F7AE0) forState:UIControlStateNormal];
        self.spectrumLabel.hidden = NO;
//        [self.photonButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        self.photonLabel.hidden = YES;
        [self updataSpectrum];
    }
}

-(void)updataSpectrum{
    self.transactionArray = [[NSMutableArray alloc]init];
    self.dataArraytransaction = [[NSMutableArray alloc]init];
    [[RaidenManager sharedManager]getContractCallTXQuery:@"" resultBlock:^(BOOL success, id result, NSError *error) {
//        [self.tableVIew.mj_header endRefreshing];
        if(success){
            if([[NSString stringWithFormat:@"%@",[result objectForKey:@"data"]]isEqualToString:@"<null>"]){
                
            }else{
                NSArray *receidArray = [result objectForKey:@"data"];
                for(NSDictionary * dict in receidArray){
                    
                    if([[dict objectForKey:@"type"] isEqualToString:@"ApproveDeposit"]){
                        if([[dict objectForKey:@"tx_status"] isEqualToString:@"success"]){
                            
                        }else{
                            [self.transactionArray addObject:dict];
                        }
                    }else{
                        [self.transactionArray addObject:dict];
                    }
                }
            }
            
            NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"call_time" ascending:NO]];
            self.dataArraytransaction = [self.transactionArray sortedArrayUsingDescriptors:sortDesc];
            [_tableVIew reloadData];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navTopHig.constant = 88;
    }
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if(self.isPhoton == YES){
        self.isTrading = YES;
        [self tradingButtonClick:self.spectrum];
    }else{
        self.isTrading = NO;
        [self updataPhoton];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)backPush:(id)sender {

//    [self.navigationController popViewControllerAnimated:YES];
    
    if(self.isPop == YES){
            for (UIViewController *controller in self.navigationController.viewControllers) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.transferPhoton == NO){
                        if ([controller isKindOfClass:[ChannelController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }else{
                        if ([controller isKindOfClass:[PhoneTransferViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                });
            }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{

            [self.navigationController popViewControllerAnimated:YES];
            });
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if([self.itemCurrent isEqualToString:@"SMT"]){
//        self.tokenStrAddress = RAIDEN_SMT_CONTRACT_ADDRESS;
//    }else{
//        self.tokenStrAddress = RAIDEN_MESH_CONTRACT_ADDRESS;
//    }
    
    self.titleLabel.text = DDYLocalStr(@"WalletTransaction");
    
    self.titleLabel.textColor = BGTEXT;
    self.titleViewBg.backgroundColor = BGCOLOT;
    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navTopHig.constant = 88;
    }
    self.view.backgroundColor = BGCOLOT;
    
    self.tableVIew.backgroundColor = BGCOLOT;
    [self.photonButton setTitleColor:BGTEXT forState:UIControlStateNormal];
    [self.spectrum setTitleColor:BGTEXT forState:UIControlStateNormal];

    self.photonButton.alpha = 1;
    self.spectrum.alpha = 0.5;
    [self.photonButton setTitle:DDYLocalStr(@"photon") forState:UIControlStateNormal];
    [self.spectrum setTitle:DDYLocalStr(@"spectrum") forState:UIControlStateNormal];
    self.photonLabel.backgroundColor = BUTTONBGCOLOR;
    self.spectrumLabel.backgroundColor = BUTTONBGCOLOR;
    self.tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupRefresh];
    
    //通知中心是个单例
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"NOTAAIFY" object:nil];
}

- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveNotification:(NSNotification *)noti{
        dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dataDict = noti.userInfo;
        if([[dataDict objectForKey:@"type"] integerValue]==4){
            if([[NSString stringWithFormat:@"%@",[[dataDict objectForKey:@"message"] objectForKey:@"type"]]isEqualToString:@"ChannelDeposit"]){
                [self popVC];
            }
        }
    });
}

-(void)popVC{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChannelController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)updataPhoton{

    self.transactionArray = [[NSMutableArray alloc]init];
    self.dataArraytransaction = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    });

    [[RaidenManager sharedManager]getReceivedTransfers:@"" resultBlock:^(BOOL success, id result, NSError *error) {//+
//        [self.tableVIew.mj_header endRefreshing];
        
        if(success){
            if([[NSString stringWithFormat:@"%@",[result objectForKey:@"data"]]isEqualToString:@"<null>"]){
                [_tableVIew reloadData];
            }else{
                NSArray *receidArray = [result objectForKey:@"data"];
                for(NSDictionary * dict in receidArray){
                    NSMutableDictionary *mut = [[NSMutableDictionary alloc]initWithDictionary:dict];
                    
                    [mut setObject:@"+"forKey:@"type"];
                    if([dict objectForKey:@"finish_time"]){
                        [mut setObject:[NSString stringWithFormat:@"%ld",[[dict objectForKey:@"finish_time"] integerValue]]forKey:@"time"];
                    }else{
                        [mut setObject:[NSString stringWithFormat:@"%ld",[[dict objectForKey:@"time_stamp"] integerValue]]forKey:@"time"];
                    }
                    [self.transactionArray addObject:mut];
                }
            }
            
            [[RaidenManager sharedManager]getSentTransfers:@"" resultBlock:^(BOOL success, id result, NSError *error) {///-
                if(success){
                    if([[NSString stringWithFormat:@"%@",[result objectForKey:@"data"]]isEqualToString:@"<null>"]){
                        [_tableVIew reloadData];
                    }else{
                        NSArray *receidArray = [result objectForKey:@"data"];
                        for(NSMutableDictionary * dict in receidArray){
                            NSMutableDictionary *mut = [[NSMutableDictionary alloc]initWithDictionary:dict];
                            [mut setObject:@"-"forKey:@"type"];
                            [mut setObject:[NSString stringWithFormat:@"%ld",[[dict objectForKey:@"sending_time"] integerValue]]forKey:@"time"];
                            [self.transactionArray addObject:mut];
                        }
                        
                        NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
                        self.dataArraytransaction = [self.transactionArray sortedArrayUsingDescriptors:sortDesc];
                        [_tableVIew reloadData];
                    }
                }
            }];
        }
    }];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataArraytransaction objectAtIndex:indexPath.section];
    
    if(self.isTrading == NO){
     
        
       
            self.nodataCell = [PhotonNoDataTableViewCell initPhotonNoDataTableViewCellTableViewCell:tableView];
            self.nodataCell.backgroundColor = [UIColor clearColor];
            NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
            if([type isEqualToString:@"(null)"]||[type integerValue]==3){
                self.nodataCell.nodataTypeLabel.text = DDYLocalStr(@"successfuldeal");//@"交易成功";
            }else if([type integerValue]==0||[type integerValue]==1||[type integerValue]==2){
                self.nodataCell.nodataTypeLabel.text = DDYLocalStr(@"thetransfer");//@"转账中";
            }else{
                self.nodataCell.nodataTypeLabel.text = DDYLocalStr(@"transactionfailure");//@"交易失败";
            }
            
            if([type isEqualToString:@"(null)"]){///接收地址
                self.nodataCell.nodataTimeLabel.text = [Tool strTime:[NSString stringWithFormat:@"%@",[dict objectForKey:@"time_stamp"]]];
                self.nodataCell.nodataAddressLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"initiator_address"]];
            }else{
                self.nodataCell.nodataTimeLabel.text = [Tool strTime:[NSString stringWithFormat:@"%@",[dict objectForKey:@"sending_time"]]];
                self.nodataCell.nodataAddressLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"target_address"]];
            }
            self.nodataCell.nodataAmountLabel.text = [NSString stringWithFormat:@"%@%@",[dict objectForKey:@"type"],[Tool powStr:[NSString stringWithFormat:@"%@",[dict objectForKey:@"amount"]] has:18]];
            return self.nodataCell;

        
    }else{
//        ChannelSettle结算
//        settle_timeout = 0存款  不等于0创建。
        // tx_status 当前状态ddy_JsonStrToDict
        
        NSDictionary *dataStr = [self dictionaryWithJsonString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"tx_params"]]];
        
        self.spectrumCell = [SpectrumTradingTableViewCell initSpectrumTradingTableViewCellTableViewCell:tableView];
        self.spectrumCell.backgroundColor = [UIColor clearColor];
        
        NSString *typestatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tx_status"]];

        if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"ChannelDeposit"]||[[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"ApproveDeposit"]){
            self.supplementCell = [SupplementTableViewCell initSupplementTableViewCellTableViewCell:tableView];
            self.supplementCell.backgroundColor = [UIColor clearColor];
            self.supplementCell.supplementTimeLabel.text = [Tool strTime:[NSString stringWithFormat:@"%@",[dict objectForKey:@"call_time"]]];

            NSString *settle_timeout = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"settle_timeout"]];
 
            if([settle_timeout integerValue]==0){//存款
                if([typestatus isEqualToString:@"success"]){
                    typestatus = DDYLocalStr(@"deposittocomplete");//@"补充完成";
                }else if([typestatus isEqualToString:@"pending"]){
                    typestatus = DDYLocalStr(@"thedeposit");//@"补充中";
                }else{
                    typestatus = DDYLocalStr(@"depositfailure");//@"补充失败";
                }
                self.supplementCell.supplementAmount.text = DDYLocalStr(@"addChainadd");
//                self.supplementCell.supplementTimeLabel.text = [Tool strTime:[NSString stringWithFormat:@"%@",[dict objectForKey:@"call_time"]]];
                self.supplementCell.supplementTypeLabel.text = typestatus;
                self.supplementCell.supplementAmountLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",[dataStr objectForKey:@"amount"]] has:18];
                return self.supplementCell;
            }else{//创建
                if([typestatus isEqualToString:@"success"]){
                    typestatus = DDYLocalStr(@"beencreated");//@"创建完成";
                }else if([typestatus isEqualToString:@"pending"]){
                    typestatus = DDYLocalStr(@"SignupCreating");//@"创建中";
                }else{
                    typestatus = DDYLocalStr(@"createfailure");//@"创建失败";
                }

            }
            self.spectrumCell.SpectrumTypeLabel.text = typestatus;
            self.spectrumCell.SpectrumAddressLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",[dataStr objectForKey:@"amount"]] has:18];
            
            self.spectrumCell.SpectrumAddressLabel.alpha = 1;
            self.spectrumCell.SpectrumAddressLabel.textColor = BGTEXT;

            self.spectrumCell.SpectrumAddress.text = DDYLocalStr(@"reasdeposit");//@"余额";
            self.spectrumCell.SpectrumAmount.text = DDYLocalStr(@"addAddress");//@"对方";
            self.spectrumCell.SpectrumAmountLabel.text = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"partner_address"]];
            self.spectrumCell.SpectrumAmountLabel.textColor = UIColorFromRGB(0xBAFFEC);
            self.spectrumCell.SpectrumAmountLabel.alpha = 0.5;


        }else if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"ChannelClose"]){
            if([typestatus isEqualToString:@"success"]){
                typestatus = DDYLocalStr(@"forcedshutdownsuccessful");//@"强制关闭成功";
            }else if([typestatus isEqualToString:@"pending"]){
                typestatus = DDYLocalStr(@"forcedclosing");//@"强制关闭中";
            }else{
                typestatus = DDYLocalStr(@"forcedshutdownfailed");//@"强制关闭失败";
            }
            self.spectrumCell.SpectrumAmount.text = @"";
            self.spectrumCell.SpectrumTypeLabel.text = typestatus;
            self.spectrumCell.SpectrumAddressLabel.text = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"partner_address"]];
            self.spectrumCell.SpectrumAmountLabel.text = @"";
        }else if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"CooperateSettle"]){
            if([typestatus isEqualToString:@"success"]){
                typestatus = DDYLocalStr(@"closesuccess");//@"关闭成功";
            }else if([typestatus isEqualToString:@"pending"]){
                typestatus = DDYLocalStr(@"chanleclosedinthe");//@"关闭中";
            }else{
                typestatus = DDYLocalStr(@"chanlewClosefailure");//@"关闭失败";
            }
            self.spectrumCell.SpectrumTypeLabel.text = typestatus;
            self.spectrumCell.SpectrumAddressLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",[dataStr objectForKey:@"p1_balance"]] has:18];
            self.spectrumCell.SpectrumAddressLabel.alpha = 1;
            self.spectrumCell.SpectrumAddressLabel.textColor = BGTEXT;
            self.spectrumCell.SpectrumAddress.text = DDYLocalStr(@"channebalance");//@"余额";
            self.spectrumCell.SpectrumAmount.text = DDYLocalStr(@"addAddress");//@"对方";
            self.spectrumCell.SpectrumAmountLabel.text = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"p2_address"]];
            self.spectrumCell.SpectrumAmountLabel.alpha = 0.5;
            self.spectrumCell.SpectrumAmountLabel.textColor = UIColorFromRGB(0xBAFFEC);
            
        }else if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"Withdraw"]){
            self.supplementCell = [SupplementTableViewCell initSupplementTableViewCellTableViewCell:tableView];
            self.supplementCell.supplementTimeLabel.text = [Tool strTime:[NSString stringWithFormat:@"%@",[dict objectForKey:@"call_time"]]];
            self.supplementCell.backgroundColor = [UIColor clearColor];
            
            if([typestatus isEqualToString:@"success"]){
                typestatus = DDYLocalStr(@"withdrawalcomplete");//@"提现完成";
            }else if([typestatus isEqualToString:@"pending"]){
                typestatus = DDYLocalStr(@"chanleWithdrawalof");//@"提现中";
            }else{
                typestatus = DDYLocalStr(@"withdrawalcofailed");//@"提现失败";
            }
            self.supplementCell.supplementTypeLabel.text = typestatus;
            self.supplementCell.supplementAmount.text = DDYLocalStr(@"withdrawallogin");//@"余额";
            
            self.supplementCell.supplementAmountLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",[dataStr objectForKey:@"p1_balance"]] has:18];
            
            return self.supplementCell;
        }
        else if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"ChannelSettle"]){
            if([typestatus isEqualToString:@"success"]){
                typestatus = DDYLocalStr(@"settlementcompletion");//@"结算完成";
            }else if([typestatus isEqualToString:@"pending"]){
                typestatus = DDYLocalStr(@"thesettlement");//@"结算中";
            }else{
                typestatus = DDYLocalStr(@"chanleSettlementfailures");//@"结算失败";
            }
            self.spectrumCell.SpectrumTypeLabel.text = typestatus;
            self.spectrumCell.SpectrumAddressLabel.text = [Tool powStr:[NSString stringWithFormat:@"%@",[dataStr objectForKey:@"p1_balance"]] has:18];
            
            self.spectrumCell.SpectrumAddressLabel.alpha = 1;
            self.spectrumCell.SpectrumAddressLabel.textColor = BGTEXT;

            self.spectrumCell.SpectrumAddress.text = DDYLocalStr(@"channebalance");//@"余额";
            self.spectrumCell.SpectrumAmount.text = DDYLocalStr(@"addAddress");//@"对方";
            self.spectrumCell.SpectrumAmountLabel.text = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"p2_address"]];
            self.spectrumCell.SpectrumAmountLabel.alpha = 0.5;
            self.spectrumCell.SpectrumAmountLabel.textColor = UIColorFromRGB(0xBAFFEC);

        }
        self.spectrumCell.SpectrumTimeLabel.text = [Tool strTime:[NSString stringWithFormat:@"%@",[dict objectForKey:@"call_time"]]];
        
        return self.spectrumCell;
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)setupRefresh
{
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadChannels)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    header.automaticallyChangeAlpha = YES;
//    self.tableVIew.mj_header = header;
}

-(void)loadChannels{
    if(self.isTrading == NO){
        [self updataPhoton];
    }else{
        [self updataSpectrum];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArraytransaction.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataArraytransaction objectAtIndex:indexPath.section];
    
    if(self.isTrading == NO){

        return 122;

        
    }else{
        
        if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"ChannelDeposit"]||[[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"ApproveDeposit"]){
            
                NSDictionary *dataStr = [self dictionaryWithJsonString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"tx_params"]]];
                NSString *settle_timeout = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"settle_timeout"]];

                if([settle_timeout integerValue]==0){//存款
                    return 95;
                }else{
                    return 121;
                }
            
            }else if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"Withdraw"]){
                
                
                return 95;
            }else if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"ChannelClose"]){
                return 95;
            }else if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]isEqualToString:@"Withdraw"]){
                return 95;
            }else{
                return 121;
            }
    }
    
    return 121;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
