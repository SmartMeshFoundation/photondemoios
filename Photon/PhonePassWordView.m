//
//  PhonePassWordView.m
//  FireFly
//
//  Created by 薛海新 on 2019/5/11.
//  Copyright © 2019 NAT. All rights reserved.
//

#import "PhonePassWordView.h"

@implementation PhonePassWordView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.7];
        self.bgView.backgroundColor = UIColorFromRGB(0x1B272B);
        self.titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
        self.titleLabel.text = DDYLocalStr(@"LoginInputPassword");
        [self.cancleButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        [self.cancleButton setTitle:DDYLocalStr(@"ChatRegistMIDCancel") forState:UIControlStateNormal];
        [self.cancleButton setBackgroundColor:BUTTONBGCOLOR];
         [self.determineButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        [self.determineButton setTitle:DDYLocalStr(@"ChatRegistMIDOK") forState:UIControlStateNormal];
        [self.determineButton setBackgroundColor:BUTTONBGCOLOR];
        self.passWordTextField.secureTextEntry = YES;

        NSString *holderText = DDYLocalStr(@"LoginPassword");
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:BUTTONBGCOLOR
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        self.passWordTextField.attributedPlaceholder = placeholder;
        self.passWordTextField.alpha = 0.3;
        self.passWordTextField.textColor = BUTTONBGCOLOR;
        
    }
    return self;
}


@end
