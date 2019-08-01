//
//  RaidenManager.h
//  FireFly
//
//  Created by RDP on 2018/5/9.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RAIDEN_CHANNEL_TIME @"RAIDEN_CHANNEL_TIME"
#define RAIDEN_EndPoint_KEY @"RAIDEN_EndPoint_KEY"

typedef enum RaidenStatus:NSInteger{
    RaidenStatus_Disconnected,
    RaidenStatus_Connected,
    RaidenStatus_Closed,
    RaidenStatus_Reconnecting,
    
    RaidenStatus_Unkown=-999,
}RaidenStatus;

typedef struct _RaidenConnectionStatus{
    RaidenStatus XMPPStatus;
    RaidenStatus EthStatus;
}RaidenConnectionStatus;

@interface RaidenTransferInfo:NSObject
@property(nonatomic,strong)NSString *Key;
@property(nonatomic,strong)NSString *block_number;
@property(nonatomic,strong)NSString *channel_identifier;
@property(nonatomic,strong)NSString *to_address;
@property(nonatomic,strong)NSString *from_address;
@property(nonatomic,strong)NSString *token_address;
@property(nonatomic,strong)NSString *nonce;
@property(nonatomic,strong)NSString *amount;
@end

typedef void(^RaidenResultBlock)(BOOL success ,id result, NSError* error);

@interface RaidenManager : NSObject

/** the singleton */
+ (instancetype)sharedManager;

@property(nonatomic,readonly)BOOL isMesh;
@property(nonatomic,assign)id raidenSS;

@property(nonatomic,readonly)RaidenConnectionStatus raidenStatus;

-(void)getNodeAddress:(NSString *)ownerAddress has:(NSString *)ozoneSign resultBlock:(RaidenResultBlock)resultBlock;
-(NSString *)getSystemStatusNew;
-(NSString *)getOneChannelNew:(NSString *)channelAddress;

-(NSDictionary *)getVesion;
-(void)raidenStop:(NSString *)addressIpStr has:(NSString *)passwordStr node:(NSString *)node address:(NSString *)walletAddress;

- (void)getWithdraw:(NSString*)withdrawAddres and:(NSString *)balance resultBlock:(RaidenResultBlock)resultBlock;

-(void)findPath:(NSString *)otherParty and:(NSString *)tokenAddress amout:(NSString *)amount dataStr:(NSString *)datastr resultBlock:(RaidenResultBlock)resultBlock;

-(void)SMTfindPath:(NSString *)otherParty and:(NSString *)tokenAddress amout:(NSString *)amount dataStr:(NSString *)datastr resultBlock:(RaidenResultBlock)resultBlock;

- (void)getContractCallTXQuery:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock;

- (void)getReceivedTransfers:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock;

- (void)getSentTransfers:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock;


- (void)startRaiden:(NSString *)addressIP has:(NSString *)password node:(NSString *)alertNode;
- (void)startTimer;

- (void)address:(RaidenResultBlock)resultBlock;

- (void)debugUploadLogfile:(RaidenResultBlock)resultBlock;



- (void)closeChannel:(NSString*)channelAddres has:(BOOL)force resultBlock:(RaidenResultBlock)resultBlock;

- (void)depositChannel:(NSString*)channelAddres balanceStr:(NSString*)balanceStr typeTOken:(NSString *)token resultBlock:(RaidenResultBlock)resultBlock;

- (void)getChannelList:(NSString *)tokenAddress block:(RaidenResultBlock)resultBlock;

- (void)getOneChannel:(NSString*)channelAddress resultBlock:(RaidenResultBlock)resultBlock;

- (void)getSystemStatus:(NSString*)channelAddress resultBlock:(RaidenResultBlock)resultBlock;


- (void)networkEvent:(int64_t)fromBlock toBlock:(int64_t)toBlock resultBlock:(RaidenResultBlock)resultBlock;

- (void)openChannel:(NSString*)partnerAddress tokenAddress:(NSString*)tokenAddress settleTimeout:(long)settleTimeout balanceStr:(NSString*)balanceStr resultBlock:(RaidenResultBlock)resultBlock;

- (void)registerToken:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock;

- (void)settleChannel:(NSString*)channelAddres resultBlock:(RaidenResultBlock)resultBlock;

- (void)stop;


- (void)tokenPartners:(NSString*)tokenAddress resultBlock:(RaidenResultBlock)resultBlock;

- (void)tokens:(NSString*)tokenAddress token:(RaidenResultBlock)resultBlock;

- (void)getAssetsOnToken:(NSString*)tokenAddress token:(RaidenResultBlock)resultBlock;


- (void)transfers:(NSString*)tokenAddress targetAddress:(NSString*)targetAddress amountstr:(NSString*)amountstr feestr:(NSString*)feestr id_:(int64_t)id_ resultBlock:(RaidenResultBlock)resultBlock;


-(void)transfersNew:(NSString *)tokenAddress and:(NSString *)otherParty amout:(NSString *)amount dataStr:(NSString *)datastr jsonStr:(NSString *)jsonStr resultBlock:(RaidenResultBlock)resultBlock;

-(void)transfersTrue:(NSString *)tokenAddress and:(NSString *)otherParty amout:(NSString *)amount dataStr:(NSString *)datastr jsonStr:(NSString *)jsonStr resultBlock:(RaidenResultBlock)resultBlock;


-(BOOL)notifyNetworkDown;
#pragma mark - 关闭通道前使用委托第三方自动结算

- (void)getRaidenMonitoringServiceChannelInfo:(NSString*)channelAddress resultBlock:(RaidenResultBlock)resultBlock;

- (void)setRaidenMonitoringServiceDelegate:(NSString*)address channelInfo:(NSDictionary*)channelInfo resultBlock:(RaidenResultBlock)resultBlock;

- (void)getRaidenMonitoringServiceDelegateInfo:(NSString*)address resultBlock:(RaidenResultBlock)resultBlock;

- (void)getRaidenMonitoringServiceDelegateFee:(NSString*)address resultBlock:(RaidenResultBlock)resultBlock;

- (void)addWalletAddressToMeshBox:(NSString*)address mac:(NSString*)mac resultBlock:(RaidenResultBlock)resultBlock;

- (void)checkWalletAddressOnlineToMeshBox:(NSString*)address resultBlock:(RaidenResultBlock)resultBlock;

- (void)getWalletAddressOnlineInMeshBoxResultBlock:(RaidenResultBlock)resultBlock;

- (void)getDeviceMacFromMeshBox:(NSString*)ip resultBlock:(RaidenResultBlock)resultBlock;
@end
