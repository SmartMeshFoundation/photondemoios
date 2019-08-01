//
//  ClosedAlertView.m
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/5/8.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import "ClosedAlertView.h"

@implementation ClosedAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.9f];

        [self.closedAlertViewCancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.closedAlertViewButton setTitle:@"强制关闭" forState:UIControlStateNormal];
        
        self.bgView.backgroundColor = UIColorFromRGB(0x1B272B);
        [self.closedAlertViewCancleButton setBackgroundColor:BUTTONBGCOLOR];
        [self.closedAlertViewCancleButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        [self.closedAlertViewButton setBackgroundColor:BUTTONBGCOLOR];
        [self.closedAlertViewButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];

        self.closedAlertViewText.textColor = BUTTONBGCOLOR;
        self.closedAlertViewText2.textColor = BUTTONBGCOLOR;

        
    }
    return self;
}

@end
