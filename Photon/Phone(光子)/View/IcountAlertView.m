//
//  IcountAlertView.m
//  FireFly
//
//  Created by 薛海新 on 2019/5/31.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "IcountAlertView.h"

@implementation IcountAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.5f];
        self.extractLabel.text = DDYLocalStr(@"channel_quedingtixian");
        self.bgView.backgroundColor = UIColorFromRGB(0x1B272B);
        [self.extracetDetermineButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.extracetCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.extracetCancelButton setBackgroundColor:BUTTONBGCOLOR];
        [self.extracetCancelButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        [self.extracetDetermineButton setBackgroundColor:BUTTONBGCOLOR];
        [self.extracetDetermineButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        self.extractLabel.textColor = UIColorFromRGB(0xFFFFFF);
        self.extractToastLabel.textColor = BUTTONBGCOLOR;

        
    }
    return self;
}

@end
