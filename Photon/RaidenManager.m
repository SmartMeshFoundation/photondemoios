//
//  RaidenManager.m
//  FireFly
//
//  Created by RDP on 2018/5/9.
//  Copyright © 2018年 NAT. All rights reserved.
//
#define RAIDEN_Contract_Token @"0x242e0de2B118279D1479545A131a90A8f67A2512"//正式
#define FFUserPath [NSString stringWithFormat:@"%@/%@/", DDYPathDocument, [[FFLoginDataBase sharedInstance].loginUser.localID ddy_MD5]]

#define RAIDEN_SMT_CONTRACT_ADDRESS @"0x6601F810eaF2fa749EEa10533Fd4CC23B8C791dc"//正式
#define LC_NSSTRING_FORMAT(s,...) [NSString stringWithFormat:s,##__VA_ARGS__]


#import "RaidenManager.h"
#import <Mobile/Mobile.h>


//#import "RChannelModel.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "NSObject+MJKeyValue.h"

#define RaidenMonitoringServiceIP @""
#define RaidenMonitoringServiceDelegateAddress @""



@implementation RaidenTransferInfo
@end

@interface RaidenManager ()<MobileNotifyHandler>
{
    NSTimer *_timer;
    BOOL _isMesh;
    RaidenConnectionStatus _raidenStatus;
}

@property(nonatomic,strong)MobileAPI *raidenRpc;

@property(nonatomic,strong)MobileSubscription *subscription;


@end

@implementation RaidenManager

static RaidenManager *_instanceRaiden;



+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceRaiden = [[self alloc] init];
    });
    return _instanceRaiden;
}

-(BOOL)isMesh{
    return _isMesh;
}

-(RaidenConnectionStatus)raidenStatus{
    return _raidenStatus;
}


- (nullable NSString*)getCurrentLocalIP//获取Wi-Fi地址
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (nullable NSString *)getCurreWiFiSsid {///获取Wi-Fi名称
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"SSID"];
}

-(void)raidenStop:(NSString *)addressIpStr has:(NSString *)passwordStr node:(NSString *)node address:(NSString *)walletAddress{

        RaidenConnectionStatus tmpRaidenStatus={RaidenStatus_Closed,RaidenStatus_Closed};
        _raidenStatus=tmpRaidenStatus;
        
        [self startRaiden:addressIpStr has:passwordStr node:node address:walletAddress];


}

- (void)getADataFromOtherOperationQueue:(RaidenResultBlock)successBlock
{
   
    [self.subscription unsubscribe];
    [self.raidenRpc stop];

    successBlock(YES,nil,nil);
}




- (void)startRaiden:(NSString *)addressIP has:(NSString *)password node:(NSString *)alertNode address:(NSString *)walletAddress{
    
    
    /*
        The first time you start a photon must be in a networked environment.
     
     It is not possible to restart the photon repeatedly, and the photon must be stopped before it can be started again.
     
     Stop photon
     
     */
//    CFRunLoopRun();
    NSString *ipAddress = [self getCurrentLocalIP];

    //复制本地的keystore

    NSString *activeAddress = walletAddress;
           
    NSString *addressString = [activeAddress substringFromIndex:2];


    
    NSString *raidenDataPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/raiden/data"];
    //Photon log
    NSString *raidenLogPath=[NSString stringWithFormat:@"%@/Documents/raiden/log_%@.string",NSHomeDirectory(),addressString];
    NSString *raidenPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/raiden"];
    ////A UTC file will be generated under the keystore path.
    NSString *raidenKeystorePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/raiden/keystore"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:raidenPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:raidenPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:raidenDataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:raidenDataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:raidenLogPath]) {
        [[NSFileManager defaultManager] createFileAtPath:raidenLogPath contents:[NSData data] attributes:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:raidenKeystorePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:raidenKeystorePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    
    NSString *savepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:LC_NSSTRING_FORMAT(@"%@.json", walletAddress)];
    
    ////////////。raidenKeystorePath Generated UTC file
    ///Files needed for photon startup
    NSData *keystoreData = [NSData dataWithContentsOfFile:savepath];
    [keystoreData writeToFile:[NSString stringWithFormat:@"%@/UTC--2017-07-17T08-46-39.151000000Z--%@", raidenKeystorePath, addressString] atomically:YES];
    /////node
    NSString *endPoint=@"http://transport01.smartmesh.cn:44444";

    NSString *listenAddress;
    if(ipAddress.length>6){
        
        listenAddress =[ipAddress stringByAppendingString:@":40001"];
        
    }else{
        listenAddress =[@"0.0.0.1" stringByAppendingString:@":40001"];
        
    }
    
    NSString *apiAddress=@"127.0.0.1:5001";

    _raidenStatus.EthStatus=RaidenStatus_Unkown;
    _raidenStatus.XMPPStatus=RaidenStatus_Unkown;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        
        
        MobileStrings* otherArgs = MobileNewStrings(1);
        [otherArgs set:0 str:@"--xmpp" error:nil];
        
        //raidenKeystorePath UTC path
        //error Error message
        self.raidenRpc = MobileStartUp(activeAddress, raidenKeystorePath, endPoint, raidenDataPath, password, apiAddress, listenAddress, raidenLogPath, RAIDEN_Contract_Token,otherArgs, &error);
        
    ///////After raidenRpc starts, you need to start subscription to complete the startup photon.
        
        if(self.raidenRpc){
            self.raidenSS = self.raidenRpc;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RAIDENRPCSUCCESS" object:nil];
            
            self.subscription=[self.raidenRpc subscribe:self error:&error];
            
            if (error) {
                [self stop];
//                [self showErrorText:@"光子启动失败！"];
                _raidenStatus.EthStatus=RaidenStatus_Disconnected;
                _raidenStatus.XMPPStatus=RaidenStatus_Disconnected;
            }else{

            }
            
        }else{
            
            /////The first time I started, I didn’t go back here.
            
            NSDictionary * errorInfo = error.userInfo;
            if ([[errorInfo allKeys] containsObject: @"NSLocalizedDescription"]){
                NSString *jsonResult = [errorInfo objectForKey:@"NSLocalizedDescription"];
                NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
                if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"error_code"]]isEqualToString:@"3"]){
//                    [self showErrorText:@"第一次启动光子，需要连接互联网。"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ISPHOTONLODING" object:nil];

                }
            }
           
//            [self showErrorText:@"光子启动失败！"];
            [self stop];
            _raidenStatus.EthStatus=RaidenStatus_Disconnected;
            _raidenStatus.XMPPStatus=RaidenStatus_Disconnected;
        }
    });
}


#pragma mark - MobileNotifyHandler
- (void)onError:(long)errCode failure:(NSString*)failure{
    _raidenStatus.EthStatus=RaidenStatus_Disconnected;
    _raidenStatus.XMPPStatus=RaidenStatus_Disconnected;
}

- (void)onReceivedTransfer:(NSString*)tr{
    RaidenTransferInfo *transferInfo=[[RaidenTransferInfo alloc] mj_setKeyValues:tr context:nil];
//    [self postNotification:FFAddSmartRaidenTransactionRecordNotification withObject:transferInfo];
}

- (void)onSentTransfer:(NSString*)tr{
    RaidenTransferInfo *transferInfo=[[RaidenTransferInfo alloc] mj_setKeyValues:tr context:nil];
//    [self postNotification:FFAddSmartRaidenTransactionRecordNotification withObject:transferInfo];
}

- (void)onStatusChange:(NSString*)s{
    NSDictionary *dic=[s mj_JSONObject];

    RaidenConnectionStatus tmpRaidenStatus={dic[@"xmpp_status"]?[dic[@"xmpp_status"] integerValue]:0,dic[@"eth_status"]?[dic[@"eth_status"] integerValue]:0};
    _raidenStatus=tmpRaidenStatus;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RaidenStatusChange" object:nil];
    }];
}

//////Photon channel change push
-(void)onNotify:(long)level info:(NSString *)info{
    //////创建通道成功后返回的信息  然后跳转到通道列表页面.
    
    NSDictionary *dictData = [self ddy_JsonStrToDict:info];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"NOTAAIFY" object:nil userInfo:dictData];

}



- (void)address:(RaidenResultBlock)resultBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *jsonResult = [self.raidenRpc address];
        if (resultBlock) {
            BOOL success=jsonResult&&jsonResult.length>1;
            if (!success) {
//                [self showText:DDYLocalStr(@"channel_photon")];
            }
            resultBlock(success,jsonResult,nil);
        }

    });
    
}

-(NSDictionary *)getVesion{
   NSString *ste  = [self.raidenRpc version];
    NSDictionary *dictData = [self ddy_JsonStrToDict:ste];
    return dictData;
}

-(void)getWithdraw:(NSString *)withdrawAddres and:(NSString *)balance resultBlock:(RaidenResultBlock)resultBlock{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSError *error=nil;
        NSString *jsonResult = [self.raidenRpc withdraw:withdrawAddres amountstr:balance op:@""];
        //        NSString *jsonResult = [self.raidenRpc closeChannel:channelAddres force:false error:&error];
        NSDictionary *dictData = [self ddy_JsonStrToDict:jsonResult];

        if([[dictData objectForKey:@"error_code"] integerValue]==0){
            resultBlock(YES,dictData,nil);
        }else{
            resultBlock(NO,dictData,nil);
        }
        
    });
    
}

-(void)closeChannel:(NSString *)channelAddres has:(BOOL)force resultBlock:(RaidenResultBlock)resultBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSString *jsonResult = [self.raidenRpc closeChannel:channelAddres force:force];
        //        NSString *jsonResult = [self.raidenRpc closeChannel:channelAddres force:false error:&error];
        NSDictionary *dictData = [self ddy_JsonStrToDict:jsonResult];
        
        if([[dictData objectForKey:@"error_code"] integerValue]==0){
            resultBlock(YES,dictData,nil);
        }else{
            resultBlock(NO,dictData,nil);
        }

        
    });
}

- (void)debugUploadLogfile:(RaidenResultBlock)resultBlock{
    NSString *jsonResult = [self.raidenRpc debugUploadLogfile];
    NSDictionary *dictData = [self ddy_JsonStrToDict:jsonResult];
    if([[dictData objectForKey:@"error_code"] integerValue]==0){
        resultBlock(YES,dictData,nil);
    }else{
        resultBlock(NO,nil,nil);
    }

}

- (void)getContractCallTXQuery:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock{
    NSString *jsonResult = [self.raidenRpc contractCallTXQuery:@"" openBlockNumber:0 tokenAddressStr:tokenAddress txTypeStr:@"ChannelDeposit,ChannelClose,ChannelSettle,CooperateSettle,Withdraw,ApproveDeposit" txStatusStr:@""];

    NSDictionary *dictData = [self ddy_JsonStrToDict:jsonResult];
    
    if([[dictData objectForKey:@"error_code"] integerValue]==0){
        resultBlock(YES,dictData,nil);
    }else{
        resultBlock(NO,nil,nil);
    }

}

-(void)findPath:(NSString *)otherParty and:(NSString *)tokenAddress amout:(NSString *)amount dataStr:(NSString *)datastr resultBlock:(RaidenResultBlock)resultBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

  NSString *jsonResult = [self.raidenRpc findPath:otherParty tokenStr:tokenAddress amountStr:[[Payment parseEther:amount] decimalString]];
        
    NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
    if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]||[[dict objectForKey:@"error_code"] integerValue]== 4000 ||[[dict objectForKey:@"error_code"] integerValue]== -1 ||[[dict objectForKey:@"error_code"] integerValue]== 0){
        resultBlock(YES,dict,nil);

    }else{
        resultBlock(NO,dict,nil);
    }
    });
}

-(void)transfersNew:(NSString *)tokenAddress and:(NSString *)otherParty amout:(NSString *)amount dataStr:(NSString *)datastr jsonStr:(NSString *)jsonStr resultBlock:(RaidenResultBlock)resultBlock{
    NSString *jsonResult;
    if([datastr integerValue] == -1||[datastr integerValue] == 4000){
      jsonResult  = [self.raidenRpc transfers:tokenAddress targetAddress:otherParty amountstr:[[Payment parseEther:amount] decimalString] secretStr:@"" isDirect:true data:nil routeInfoStr:jsonStr];

    }else{
        jsonResult  = [self.raidenRpc transfers:tokenAddress targetAddress:otherParty amountstr:[[Payment parseEther:amount] decimalString] secretStr:@"" isDirect:false data:nil routeInfoStr:jsonStr];

    }
    
    NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
    if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
        resultBlock(YES,dict,nil);
    }else{
        resultBlock(NO,nil,nil);
    }
}


-(void)transfersTrue:(NSString *)tokenAddress and:(NSString *)otherParty amout:(NSString *)amount dataStr:(NSString *)datastr jsonStr:(NSString *)jsonStr resultBlock:(RaidenResultBlock)resultBlock{
    NSString *jsonResult;
        jsonResult  = [self.raidenRpc transfers:tokenAddress targetAddress:otherParty amountstr:[[Payment parseEther:amount] decimalString] secretStr:@"" isDirect:true data:nil routeInfoStr:@""];
    NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
    
    if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
        resultBlock(YES,dict,nil);
    }else{
        resultBlock(NO,dict,nil);
    }
}


-(void)SMTfindPath:(NSString *)otherParty and:(NSString *)tokenAddress amout:(NSString *)amount dataStr:(NSString *)datastr resultBlock:(RaidenResultBlock)resultBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *jsonResult = [self.raidenRpc findPath:otherParty tokenStr:tokenAddress amountStr:[[Payment parseEther:amount] decimalString]];
        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]||[[dict objectForKey:@"error_code"] integerValue]== 4000 ||[[dict objectForKey:@"error_code"] integerValue]== 3003||[[dict objectForKey:@"error_code"] integerValue]== -1){
            NSString *jsonStr;
            if([[dict objectForKey:@"error_code"] integerValue]== 4000||[[dict objectForKey:@"error_code"] integerValue]== 3003||[[dict objectForKey:@"error_code"] integerValue]== -1){
                jsonStr = @"";
            }else{
                NSData *data=[NSJSONSerialization dataWithJSONObject:[dict objectForKey:@"data"] options:NSJSONWritingPrettyPrinted error:nil];
                jsonStr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            }
            //        NSArray n*array = [dict objectForKey:@"data"];
            //        NSString *fee = [NSString stringWithFormat:@"%@",[[array objectAtIndex:0] objectForKey:@"fee"]];
            
//            BOOL isDirect=(_raidenStatus.EthStatus==RaidenStatus_Connected&&_raidenStatus.XMPPStatus==RaidenStatus_Connected&&[[LC_Network LCInstance] isNetwork])?NO:YES;

            NSString *jsonResultTrans;
            if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]||[[dict objectForKey:@"error_code"] integerValue]== 4000 ||[[dict objectForKey:@"error_code"] integerValue]== 3003||[[dict objectForKey:@"error_code"] integerValue]== -1){
                
                   jsonResultTrans = [self.raidenRpc transfers:tokenAddress targetAddress:otherParty amountstr:[[Payment parseEther:amount] decimalString] secretStr:@"" isDirect:true data:nil routeInfoStr:jsonStr];

            }else{
                jsonResultTrans = [self.raidenRpc transfers:tokenAddress targetAddress:otherParty amountstr:[[Payment parseEther:amount] decimalString] secretStr:@"" isDirect:false data:nil routeInfoStr:jsonStr];

            }
            
            NSDictionary *dictTrans = [self ddy_JsonStrToDict:jsonResultTrans];
            
            if([[dictTrans objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
                
                resultBlock(YES,dictTrans,nil);
                
            }else{
                resultBlock(NO,dictTrans,nil);
                //                [self showErrorText:@"转账失败"];
            }
        }else{
            resultBlock(NO,nil,nil);
            
//            [self showErrorText:@"转账失败"];
        }
        
    });
    
}


- (void)depositChannel:(NSString*)channelAddres balanceStr:(NSString*)balanceStr typeTOken:(NSString *)token resultBlock:(RaidenResultBlock)resultBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        
        NSString *jsonResult = [self.raidenRpc deposit:channelAddres tokenAddress:token settleTimeout:0 balanceStr:[[Payment parseEther:balanceStr] decimalString] newChannel:false];
        
        
        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
            resultBlock(YES,dict,nil);
        }else{
            resultBlock(NO,dict,error);
        }
        

    });
}

- (NSString *)formatJsonString:(NSString *)jsonString withKeyWordString:(NSString *)keyString
{
    NSRange balanceRange = [jsonString rangeOfString:keyString];
    NSUInteger loc = balanceRange.location + balanceRange.length;
    
    NSUInteger endLoc = [jsonString rangeOfString:@"}"].location;
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSBackwardsSearch range:NSMakeRange(loc, endLoc - loc)];
    
    return jsonString;
}


- (void)getReceivedTransfers:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock{
    NSString *jsonResult = [self.raidenRpc getReceivedTransfers:tokenAddress from:-1 to:-1];
    
    NSDictionary *dictData = [self ddy_JsonStrToDict:jsonResult];

    if([[dictData objectForKey:@"error_code"] integerValue]==0){
        resultBlock(YES,dictData,nil);
    }else{
        resultBlock(NO,nil,nil);
    }
}

- (void)getSentTransfers:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock{
    NSString *jsonResult = [self.raidenRpc getSentTransfers:tokenAddress from:-1 to:-1];
    NSDictionary *dictData = [self ddy_JsonStrToDict:jsonResult];
    
    if([[dictData objectForKey:@"error_code"] integerValue]==0){
        resultBlock(YES,dictData,nil);
    }else{
        resultBlock(NO,nil,nil);
    }

}



-(void)getNodeAddress:(NSString *)ownerAddress has:(NSString *)ozoneSign resultBlock:(RaidenResultBlock)resultBlock{
    NSError *error=nil;

    NSString *nodeAddress = MobileGetMinerFromSignature(ownerAddress, ozoneSign, &error);
    if(nodeAddress.length>18){
        resultBlock(YES,nodeAddress,nil);
    }else{
        resultBlock(NO,nil,nil);
    }

    
}

////通道列表

-(void)getChannelList:(NSString *)tokenAddress block:(RaidenResultBlock)resultBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *jsonResult = [self.raidenRpc getChannelList];
        
        NSDictionary *dictData = [self ddy_JsonStrToDict:jsonResult];
        
        if(dictData){
            
            if([[dictData objectForKey:@"error_code"] integerValue]==0){
                NSArray *channels = nil;
                
                NSMutableArray *tempChannelsM = [NSMutableArray array];
                if([[NSString stringWithFormat:@"%@",[dictData objectForKey:@"data"]]isEqualToString:@"<null>"]){
                    
                    resultBlock(NO,nil,nil);
//                [self showText:DDYLocalStr(@"channel_photon")];


                }else{
                    
                    NSArray *arryData = [dictData objectForKey:@"data"];
                    channels = [arryData copy];
                    resultBlock(YES,channels,nil);
                }
            }else{
                
                resultBlock(NO,nil,nil);
            }
            
        }else{
            
            resultBlock(NO,nil,nil);
        }
    });
    
}



- (void)getOneChannel:(NSString*)channelAddress resultBlock:(RaidenResultBlock)resultBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        NSString *jsonResult = [self.raidenRpc getOneChannel:channelAddress];

        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
            resultBlock(YES,[dict objectForKey:@"data"],nil);
        }else{
            resultBlock(NO,nil,error);
        }
    });
}

-(NSString *)getOneChannelNew:(NSString *)channelAddress{
    NSString *jsonResult = [self.raidenRpc getOneChannel:channelAddress];
    
    NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
    if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
        return [[dict objectForKey:@"data"] objectForKey:@"settled_block"];
    }else{
        return @"";
    }
}


-(NSString *)getSystemStatusNew{
    NSString *jsonResult = [self.raidenRpc getSystemStatus];
    
    NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
    if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
        return [[dict objectForKey:@"data"] objectForKey:@"block_number"];
    }else{
        return @"";
    }
}

- (void)getSystemStatus:(NSString*)channelAddress resultBlock:(RaidenResultBlock)resultBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        NSString *jsonResult = [self.raidenRpc getSystemStatus];
        //        NSString *jsonResult = [self.raidenRpc getOneChannel:channelAddress error:&error];
        
        
        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
            resultBlock(YES,[dict objectForKey:@"data"],nil);
        }else{
//            [self showText:DDYLocalStr(@"channel_photon")];
            resultBlock(NO,nil,error);
        }
    });
}



- (void)networkEvent:(int64_t)fromBlock toBlock:(int64_t)toBlock resultBlock:(RaidenResultBlock)resultBlock
{
    
}


- (void)openChannel:(NSString*)partnerAddress tokenAddress:(NSString*)tokenAddress settleTimeout:(long)settleTimeout balanceStr:(NSString*)balanceStr resultBlock:(RaidenResultBlock)resultBlock
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        ///正式 46666；
         NSString *jsonResult = [self.raidenRpc deposit:partnerAddress tokenAddress:tokenAddress settleTimeout:46666 balanceStr:[[Payment parseEther:balanceStr] decimalString] newChannel:true];
        
        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
            resultBlock(YES,dict,nil);
        }else{
            resultBlock(NO,dict,error);
        }

    });
}

- (void)registerToken:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        NSString *jsonResult = @"";

        if (resultBlock) {
            BOOL success=jsonResult&&jsonResult.length>1;
            if (!success) {
            }
            
            NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
            
            resultBlock(success,dict,error);
        }

    });
}


/////Settle now
- (void)settleChannel:(NSString*)channelAddres resultBlock:(RaidenResultBlock)resultBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        NSString *jsonResult = [self.raidenRpc settleChannel:channelAddres];

        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
            resultBlock(YES,dict,nil);
        }else{
            if([[dict objectForKey:@"error_code"] integerValue]==2000){
            }else{

            }
            resultBlock(NO,nil,error);
        }
    });
}

- (void)stop
{
    RaidenConnectionStatus tmpRaidenStatus={RaidenStatus_Closed,RaidenStatus_Closed};
    _raidenStatus=tmpRaidenStatus;
    
    dispatch_queue_t queue = dispatch_queue_create("stop", DISPATCH_QUEUE_CONCURRENT);
    _isMesh=NO;
    
    dispatch_async(queue, ^{
        if(self.subscription&&self.subscription!=nil){
            [self.subscription unsubscribe];
            self.subscription = nil;
        }

    });
    
    dispatch_barrier_async(queue, ^{
        if(self.raidenRpc&&self.raidenRpc!=nil){
            [self.raidenRpc stop];
            self.raidenRpc = nil;
        }
    });
    
    dispatch_async(queue, ^{

    });

}

- (void)getAssetsOnToken:(NSString*)tokenAddress token:(RaidenResultBlock)resultBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        NSString *jsonResult = [self.raidenRpc getAssetsOnToken:[NSString stringWithFormat:@"%@",RAIDEN_SMT_CONTRACT_ADDRESS]];
        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_code"] integerValue]==0){
            resultBlock(YES,dict,nil);
        }else{
            resultBlock(NO,nil,nil);
        }
    });
}




#pragma mark 字典/数组转json字符串
- (NSString *)ddy_ToJsonStr:(id)obj {
    if (!obj) {
        return @"";
    }
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //        NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        return jsonTemp;
    }
    return @"";
}




-(void)tokens:(NSString *)tokenAddress token:(RaidenResultBlock)resultBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        NSString *jsonResult = [self.raidenRpc tokens];
        if (resultBlock) {
            BOOL success=jsonResult&&jsonResult.length>1;
            if (!success) {
//                [self showText:DDYLocalStr(@"channel_photon")];
            }
            BOOL hasRegistered = NO;
            if ([jsonResult containsString:tokenAddress]) {
                
                hasRegistered = YES;
            }
            
            resultBlock(success,@(hasRegistered),error);
        }
        
    });
}



-(BOOL)notifyNetworkDown{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.raidenRpc notifyNetworkDown];

    });
    return YES;
}

- (void)transfers:(NSString*)tokenAddress targetAddress:(NSString*)targetAddress amountstr:(NSString*)amountstr feestr:(NSString*)feestr id_:(int64_t)id_ resultBlock:(RaidenResultBlock)resultBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error=nil;
        BOOL isDirect=YES;
        
       NSString *jsonResult = [self.raidenRpc transfers:tokenAddress targetAddress:targetAddress amountstr:[[Payment parseEther:amountstr] decimalString] secretStr:@"" isDirect:isDirect data:nil routeInfoStr:nil];

        
        NSDictionary *dict = [self ddy_JsonStrToDict:jsonResult];
        if([[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]){
            
            NSString * locksec = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"lockSecretHash"]];
            if (dict&&locksec.length>6) {
                    NSString *channelResult=[self.raidenRpc getTransferStatus:tokenAddress lockSecretHashStr:locksec];
                    //
                    NSDictionary *channeldict = [self ddy_JsonStrToDict:channelResult];

                    
                    if (channeldict&&[[dict objectForKey:@"error_message"]isEqualToString:@"SUCCESS"]) {

                        resultBlock(YES,channeldict,nil);
                        
                        return ;
                    }
                
                resultBlock(NO,nil,error);
            }
            else{
                resultBlock(NO,nil,error);
            }
            
        }else{

            resultBlock(NO,nil,error);
            
        }

    });

}

#pragma mark json字符串转字典
- (NSDictionary *)ddy_JsonStrToDict:(NSString *)jsonStr {
    if ([self ddy_blankString:jsonStr]) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        return nil;
    }
    return dict;
}
#pragma mark 判断空字符串
- (BOOL)ddy_blankString:(NSString *)str {
    
    if (str == nil || str == NULL || [str isEqualToString:@"(null)"] || [str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


@end
