//
//  WithdrawalAlertView.m
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/5/8.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import "WithdrawalAlertView.h"

@implementation WithdrawalAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;


        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.9f];
        
        self.bgView.backgroundColor = UIColorFromRGB(0x1B272B);
        
        [self.withdrawalAlertCancleButton setBackgroundColor:BUTTONBGCOLOR];
        [self.withdrawalAlertCancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.withdrawalAlertCancleButton setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];
        [self.withdrawalAlertShutDown setBackgroundColor:BUTTONBGCOLOR];
        [self.withdrawalAlertShutDown setTitle:@"确定" forState:UIControlStateNormal];

        [self.withdrawalAlertShutDown setTitleColor:BUTTONTEXTCOLOR forState:UIControlStateNormal];

        self.textLabel.textColor = BUTTONBGCOLOR;
        //        //        self.layer.cornerRadius = 5.0f;
        //        CAGradientLayer *gradient = [CAGradientLayer layer];
        //        gradient.frame = self.gradientBlueView.bounds;
        //        gradient.colors = [NSArray arrayWithObjects:
        //                           (id)[UIColor colorWithRed:58/255.0 green:115/255.0 blue:254/255.0 alpha:1.0].CGColor,
        //                           (id)[UIColor colorWithRed:114/255.0 green:161/255.0 blue:252/255.0 alpha:1.0].CGColor, nil];
        //        gradient.locations = @[@0, @1.0];
        //        gradient.startPoint = CGPointMake(0, 0);
        //        gradient.endPoint = CGPointMake(1.0, 0);
        //        gradient.frame = CGRectMake(0, 0, frame.size.width, self.gradientBlueView.height);
        //        [self.gradientBlueView.layer addSublayer:gradient];//        self.cancelButton.backgroundColor = UIColorFromRGB(0xEEF3FE);
        //
        //        UIImageView *versionImage = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-80)/2-94.5, 0, 189, 180)];
        //        versionImage.image = [UIImage imageNamed:@"appVesion"];
        //        [self.gradientBlueView addSubview:versionImage];
        
        //        self.versonButton.layer.cornerRadius = 5.0f;
        //        [self.versonButton setBackgroundColor:[UIColor colorWithRed:75/255.0 green:123/255.0 blue:217/255.0 alpha:1.0] forState:UIControlStateNormal];
        //        self.versonButton.layer.masksToBounds = YES;
        //
        //        self.nextTimeButton.layer.cornerRadius = 5.0f;
        //        [self.nextTimeButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:243/255.0 blue:253/255.0 alpha:1.0] forState:UIControlStateNormal];
        //        self.nextTimeButton.layer.masksToBounds = YES;
        //
        //        self.immediatelyButton.layer.cornerRadius = 5.0f;
        //        [self.immediatelyButton setBackgroundColor:[UIColor colorWithRed:75/255.0 green:123/255.0 blue:217/255.0 alpha:1.0] forState:UIControlStateNormal];
        //        self.immediatelyButton.layer.masksToBounds = YES;
        
        
    }
    return self;
}


@end
