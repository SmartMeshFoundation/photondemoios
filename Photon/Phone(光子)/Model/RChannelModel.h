//
//  RChannelModel.h
//  FireFly
//
//  Created by RDP on 2018/5/8.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum RChannelState:NSInteger{
    //StateInValid channel never exist
    RChannelState_StateInValid=0,
    //StateOpened channel is ready for transfer
    RChannelState_StateOpened,
    //StateClosed 不能再发起交易了,还可以接受交易.
    RChannelState_StateClosed,
    //StateBalanceProofUpdated 已经提交过证据,未完成的交易不再继续,不能接收 unlock 消息
    RChannelState_StateBalanceProofUpdated,
    //StateSettled 通道已经彻底结算,和 invalid 状态意义相同
    RChannelState_StateSettled,
    /*StateClosing 用户发起了关闭通道的请求,正在处理
     正在进行交易,可以继续,不再新开交易
     */
    RChannelState_StateClosing,
    /*StateSettling 用户发起了 结算请求,正在处理
     正常情况下此时不应该还有未完成交易,
     不能新开交易,正在进行的交易也没必要继续了.因为已经提交到链上了.
     */
    RChannelState_StateSettling,
    
    //StateWithdraw 用户收到或者发出了 withdraw 请求,这时候正在进行的交易只能立即放弃,因为没有任何意义了
    RChannelState_StateWithdraw,
    //StateCooprativeSettle 用户收到或者发出了 cooperative settle 请求,这时候正在进行的交易只能立即放弃,因为没有任何意义了
    RChannelState_StateCooprativeSettle,
    /*StatePrepareForCooperativeSettle 收到了用户 cooperative 请求,但是有正在处理的交易,这时候不再接受新的交易了,可以等待一段时间,然后settle
     已开始交易,可以继续
     */
    RChannelState_StatePrepareForCooperativeSettle,
    /*StatePrepareForWithdraw 收到用户请求,要发起 withdraw, 但是目前还持有锁,不再发起或者接受任何交易,可以等待一段时间进行 withdraw
     已开始交易,可以继续
     */
    RChannelState_StatePrepareForWithdraw,
    /*StateError 比如收到了明显错误的消息,又是对方签名的,如何处理?
     比如自己未发送 withdrawRequest,但是收到了 withdrawResponse
     todo 这种情况应该的实现是关闭通道.这样真的合理吗?
     */
    RChannelState_StateError

}RChannelState;

RChannelState RChannelStateValueOf(NSString *text);
NSString* RChannelStateDescription(RChannelState value);

@interface RChannelModel : NSObject

@property (nonatomic, strong) NSString *channel_identifier;
@property (nonatomic, strong) NSString *partner_address;
@property (nonatomic, strong) NSString *token_address;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) NSString *settle_timeout;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *block_number;
@property (nonatomic, strong) NSString *settled_block;
@property (nonatomic, strong) NSString *block_number_now;
@property (nonatomic, strong) NSString *block_number_channel_can_settle;


@property (nonatomic, strong) NSString *patner_balance;
@property (nonatomic, strong) NSString *locked_amount;
@property (nonatomic, strong) NSString *partner_locked_amount;
@property (nonatomic, strong) NSString *reveal_timeout;

@property (nonatomic, strong) NSString *delegate_state;




@property (nonatomic, strong) NSString *netWork;


/** 计算该模型对应的高度 */
@property (nonatomic, assign) float cellHeight;

@end
