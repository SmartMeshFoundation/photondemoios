//
//  RSMTAddNewViewController.m
//  FireFly
//
//  Created by 薛海新 on 2019/3/28.
//  Copyright © 2019 NAT. All rights reserved.
//
#define APP_MAIN_COLOR [UIColor colorWithRed:248/255.0 green:220/255.0 blue:74/255.0 alpha:1.0]

#import "RSMTAddNewViewController.h"
//#import "AlertChannelToast.h"
//#import "RaidenManager.h"
#import "PhotonTransactionRecordsViewController.h"
#import "ExtractAlertView.h"
#import <ethers/Payment.h>

@interface RSMTAddNewViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSArray *_arrayM;
    UIStatusBarStyle    _statusBarStyle;        // 顶部状态栏状态

}
@property (weak, nonatomic) IBOutlet UILabel *toAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *smtLabel;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueToAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueToAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueBalanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueAddLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (nonatomic ,strong)NSString *tokenStrAddress;///smt&mesh
@property (nonatomic ,strong)UIView *toastView;///smt&mesh
//@property (nonatomic ,strong)AlertChannelToast *alertChannel;///smt&mesh
@property (nonatomic ,strong)ExtractAlertView *extractView;///smt&mesh
@property (nonatomic ,strong)NSMutableArray *dataArray;///smt&mesh


@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navhigTop;
@property (nonatomic,assign)BOOL isNetWork;


@end

@implementation RSMTAddNewViewController
- (IBAction)backPush:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonClick:(id)sender {

    if(self.isNetWork == NO){
//    if([self.valueAddLabel.text doubleValue]>=0.01){
//
//    }else{
//        [self ff_HudText:DDYLocalStr(@"createrDeposits") isLoading:NO hideDelay:2];
//
//        return;
//    }
    

    
    NSString *balance = self.itemCurrent.balance;
    
    
//    if(([self.valueAddLabel.text doubleValue])>=[balance doubleValue]){
//        [self ff_HudText:DDYLocalStr(@"createrInsufficientbalance") isLoading:NO hideDelay:2];
//
//        return;
//    }
    
    self.toastView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    self.toastView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    [self.view.window addSubview:self.toastView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeztoastView:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    tapGestureRecognizer.delegate =self;
    [self.toastView addGestureRecognizer:tapGestureRecognizer];
    
    
    self.extractView = [[ExtractAlertView alloc]initWithFrame:CGRectMake(25, _toastView.frame.size.height/2-90, ScreenWidth-50, 184)];
    self.extractView.extractLabel.text = DDYLocalStr(@"lognotice");
    self.extractView.extractToastLabel.text = DDYLocalStr(@"createrdeposittoast");
    [self.extractView.extracetCancelButton addTarget:self action:@selector(canleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.extractView.extracetDetermineButton addTarget:self action:@selector(determineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [Tool animationAlert:self.extractView];
    [_toastView addSubview:self.extractView];

    }else{
        [self ff_HudText:DDYLocalStr(@"photonNetwork") isLoading:NO hideDelay:2];
    }
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.valueAddLabel resignFirstResponder];
}

-(void)canleButtonClick{
    [self.toastView removeFromSuperview];
}

-(void)raidenStatusReload{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([RaidenManager sharedManager].raidenStatus.EthStatus==RaidenStatus_Connected) {
            self.isNetWork = NO;
        }
        else if([RaidenManager sharedManager].raidenStatus.EthStatus==RaidenStatus_Unkown){
            self.isNetWork = YES;
        }
        else{
            self.isNetWork = YES;
        }
    });
}

-(void)determineButtonClick{
    self.tokenStrAddress = RAIDEN_SMT_CONTRACT_ADDRESS;

    [self.toastView removeFromSuperview];
    
    ////Get the balance
    [[RaidenManager sharedManager]getAssetsOnToken:@"" token:^(BOOL success, id result, NSError *error) {
        if (success) {
            
            
            if(![[NSString stringWithFormat:@"%@",[result objectForKey:@"data"]]isEqualToString:@"<null>"]){
                
                NSArray *array = [result objectForKey:@"data"];
                
                for(NSDictionary *dict in array){
                    if([[[dict objectForKey:@"token_address"]lowercaseString] isEqualToString:[RAIDEN_SMT_CONTRACT_ADDRESS lowercaseString]]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if([[Tool powStr:[dict objectForKey:@"balance_on_chain"] has:18] doubleValue]>=0.01){
                                //Supplementary balance
                                //_channel.partner_address。address
                                //_channel.token_address。 Channel address, unique
                                [[RaidenManager sharedManager] depositChannel:_channel.partner_address balanceStr:self.valueAddLabel.text typeTOken:_channel.token_address resultBlock:^(BOOL success, id result, NSError *error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
//                                        [self dismissLoading];
                                        
                                        if (success) {
                                            ////Enter transaction record
                                            [self pushPhoton];
                                            
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
                                            
                                        }else{
                                            [self ff_HudText:[NSString stringWithFormat:@"%@",[result objectForKey:@"error_message"]] isLoading:NO hideDelay:2];
                                        }
                                    });
                                }];
                                
                            }else{
                                [self ff_HudText:DDYLocalStr(@"createrDeposits") isLoading:NO hideDelay:2];

                            }
                        });
                        
                    }
                }
                
            }
        }
    }];

}

-(void)pushPhoton{
    PhotonTransactionRecordsViewController *transaction = [[PhotonTransactionRecordsViewController alloc]init];
    transaction.isPop = YES;
    transaction.isPhoton = YES;
//    transaction.itemCurrent = self.itemCurrent;
    [self.navigationController pushViewController:transaction animated:YES];
    
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

-(void)removeztoastView:(UITapGestureRecognizer*)tap{
    [self.toastView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(raidenStatusReload) name:@"RaidenStatusChange" object:nil];
    [self raidenStatusReload];

    self.navView.backgroundColor = BGCOLOT;
    self.titleLabel.textColor = BGTEXT;
    self.titleLabel.text = DDYLocalStr(@"addnewTitle");
    self.line1.backgroundColor = UIColorFromRGB(0xBAFFEC);
    self.line2.backgroundColor = UIColorFromRGB(0xBAFFEC);
    self.bgView.backgroundColor = BGCOLOT;
    self.view.backgroundColor = BGCOLOT;
    self.valueToAddressLabel.textColor = BGTEXT;
    self.valueAddLabel.textColor = BGTEXT;
    self.valueAddLabel.alpha = 0.5;
    self.smtLabel.textColor = BGTEXT;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:DDYLocalStr(@"amountwaller") attributes:
                                             @{NSForegroundColorAttributeName:BGTEXT,
                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                             ];
    self.valueAddLabel.attributedPlaceholder = attrString;
    self.tokenStrAddress = RAIDEN_SMT_CONTRACT_ADDRESS;
    self.smtLabel.text = @"SMT";


    if([UIScreen mainScreen].bounds.size.height == 812){
        self.navhigTop.constant = 88;
    }
    
    self.toAddressLabel.text = DDYLocalStr(@"addAddress");
    self.toAmountLabel.text = DDYLocalStr(@"addchannelamount");
    self.balanceLabel.text = DDYLocalStr(@"addChainbalance");
    self.addLabel.text = DDYLocalStr(@"addChainadd");
    self.navTitle.text = DDYLocalStr(@"addChainadd");

    self.valueAddLabel.delegate = self;
    self.valueAddLabel.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.valueToAddressLabel.text = self.channel.partner_address;
    self.valueToAmountLabel.text = [Tool powStr:self.channel.balance has:18];
    self.valueToAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    self.valueAddLabel.delegate = self;

//    self.addButton.layer.cornerRadius = 5;
    [self.addButton setTitle:DDYLocalStr(@"GroupChatComplete") forState:UIControlStateNormal];
    [self.addButton setBackgroundColor:BUTTONBGCOLOR];
    [self.addButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
    self.addButton.alpha = 0.5;
    self.addButton.enabled = NO;


    // Do any additional setup after loading the view from its nib.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//获取输入值
- (void)textFieldDidChange:(UITextField *)textField
{
    if(self.valueAddLabel.text.length>0){
        self.addButton.alpha = 1;
        self.addButton.enabled = YES;
    }else{
        self.addButton.enabled = NO;
        self.addButton.alpha = 0.5;
    }
}

// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.valueAddLabel.text.length>0){
        self.addButton.alpha = 1;
        self.addButton.enabled = YES;
    }else{
        self.addButton.enabled = NO;
        self.addButton.alpha = 0.5;
    }
    [textField resignFirstResponder];
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
