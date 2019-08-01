//
//  ClosedAlertView.h
//  MeshBoxManager
//
//  Created by 薛海新 on 2019/5/8.
//  Copyright © 2019 MeshBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosedAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *closedAlertViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *closedAlertViewText;
@property (weak, nonatomic) IBOutlet UIButton *closedAlertViewCancleButton;
@property (weak, nonatomic) IBOutlet UIButton *closedAlertViewButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *closedAlertViewText2;

@end
