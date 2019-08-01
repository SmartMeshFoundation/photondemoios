//
//  SettlementAlertView.m
//  FireFly
//
//  Created by 薛海新 on 2019/5/19.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "SettlementAlertView.h"

@implementation SettlementAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.9f];

        [self.settlementCancleButton setTitle:DDYLocalStr(@"ChatRegistMIDCancel") forState:UIControlStateNormal];
        [self.settlementButton setTitle:DDYLocalStr(@"SignupOK") forState:UIControlStateNormal];
        
        self.bgView.backgroundColor = UIColorFromRGB(0x1B272B);
        
        [self.settlementCancleButton setBackgroundColor:BUTTONBGCOLOR];
        [self.settlementCancleButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        [self.settlementButton setBackgroundColor:BUTTONBGCOLOR];
        [self.settlementButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];

        self.settlementText.textColor = BUTTONBGCOLOR;
        
        self.settlementTitle.text = DDYLocalStr(@"Settlement");
        self.settlementText.text = DDYLocalStr(@"thebillingchannel");

    }
    return self;
}

@end
