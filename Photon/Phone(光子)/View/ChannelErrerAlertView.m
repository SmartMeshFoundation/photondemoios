//
//  ChannelErrerAlertView.m
//  FireFly
//
//  Created by 薛海新 on 2019/6/13.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "ChannelErrerAlertView.h"

@implementation ChannelErrerAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
        
        
        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.9f];
        
        self.bgView.backgroundColor = UIColorFromRGB(0x1B272B);
        
        [self.okButton setBackgroundColor:BUTTONBGCOLOR];
        [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.okButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        self.textLabel.textColor = BUTTONBGCOLOR;
        
    }
    return self;
}

@end
