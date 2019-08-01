//
//  DDYButton.m
//  DDYProject
//
//  Created by Megan on 17/7/20.
//  Copyright © 2017 Starain. All rights reserved.
//

#import "DDYButton.h"
#import <objc/runtime.h>

@implementation DDYButton

+ (instancetype)customDDYBtn
{
    return [[self class] buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.padding = 5;
        self.btnStyle = DDYBtnStyleImgLeft;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image && self.titleLabel.text)
    {
        [self setAttributes];
        switch (self.btnStyle)
        {
            case DDYBtnStyleImgRight:
                [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgLeft:
                [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            case DDYBtnStyleImgTop:
                [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
                break;
            case DDYBtnStyleImgDown:
                [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
                break;
            case DDYBtnStyleNaturalImgLeft:
                [self layoutNaturalWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            case DDYBtnStyleNaturalImgRight:
                [self layoutNaturalWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgLeftThenLeft:
                [self layoutLeftStyleWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            case DDYBtnStyleImgRightThenLeft:
                [self layoutLeftStyleWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgRightThenRight:
                [self layoutRightStyleWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgLeftThenRight:
                [self layoutRightStyleWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            default:
                break;
        }
    }
}

- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView
{
    CGFloat totalW = leftView.ddy_w + self.padding + rightView.ddy_w;
    
    leftView.ddy_x = (self.ddy_w - totalW)/2.0;
    leftView.ddy_y = (self.ddy_h - leftView.ddy_h)/2.0;
    
    rightView.ddy_x = leftView.ddy_right + self.padding;
    rightView.ddy_y = (self.ddy_h - rightView.ddy_h)/2.0;
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView
{
    CGFloat totalH = upView.ddy_h + self.padding + downView.ddy_h;
    
    upView.ddy_x = (self.ddy_w - upView.ddy_w)/2.0;
    upView.ddy_y = (self.ddy_h - totalH)/2.0;
    
    downView.ddy_x = (self.ddy_w - downView.ddy_w)/2.0;
    downView.ddy_y = upView.ddy_bottom + self.padding;
}

- (void)layoutNaturalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView
{
    leftView.ddy_x = 0;
    rightView.ddy_right = self.ddy_w;
}

- (void)layoutLeftStyleWithLeftView:(UIView *)leftView rightView:(UIView *)rightView
{
    leftView.ddy_x = 0;
    rightView.ddy_x = leftView.ddy_right + self.padding;
}

- (void)layoutRightStyleWithLeftView:(UIView *)leftView rightView:(UIView *)rightView
{
    rightView.ddy_right = self.ddy_w;
    leftView.ddy_right = rightView.ddy_x - self.padding;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self.imageView sizeToFit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self.titleLabel sizeToFit];
}

- (void)setAttributes
{
    if (_textFont)
    {
        self.titleLabel.font = _textFont;
    }
    [self.titleLabel sizeToFit];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.titleLabel.font = _textFont;
}

+ (instancetype)btnTitle:(NSString *)title img:(id)img target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    DDYButton *btn = [self btnTitle:title img:img target:target action:action];
    btn.tag = tag;
    return btn;
}

+ (instancetype)btnTitle:(NSString *)title img:(id)img target:(id)target action:(SEL)action
{
    DDYButton *btn = [DDYButton customDDYBtn];
    if(title.length>0){

        [btn setTitle:title forState:UIControlStateNormal];
    }
        if (img) {
        if ([img isKindOfClass:[NSString class]]) {
            [btn  setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        } else if ([img isKindOfClass:[UIImage class]]) {
            [btn  setImage:img forState:UIControlStateNormal];
        }
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end

