//
//  DDYTextView.m
//  DDYProject
//
//  Created by Megan on 17/7/27.
//  Copyright © 2017 Starain. All rights reserved.
//

#import "DDYTextView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation MintAnnotation

@end

static NSString* const keyModelId = @"mintACV_id";

@interface DDYTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end


@implementation DDYTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

+ (instancetype)textView
{
    return [[self alloc] init];
}

+ (instancetype)textViewPlaceholder:(NSString *)placeholder font:(UIFont *)font
{
    return [[self alloc] initWithPlaceholder:placeholder font:font frame:CGRectZero];
}

+ (instancetype)textViewPlaceholder:(NSString *)placeholder font:(UIFont *)font frame:(CGRect)frame
{
    return [[self alloc] initWithPlaceholder:placeholder font:font frame:frame];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder font:(UIFont *)font frame:(CGRect)frame
{
    if (self = [self initWithFrame:frame])
    {
        self.placeholder = placeholder;
        self.placeholderTextColor = TEXTALPHA;
        self.font = font;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // layoutManager(NSLayoutManager)的是否非连续布局属性，默认YES，设置为NO就不会再自己重置滑动了。
        self.layoutManager.allowsNonContiguousLayout = NO;
        // 如果存在占位字符则默认浅灰色
        self.placeholderTextColor = [UIColor lightGrayColor];
            self.layer.borderWidth=0.5f;
            self.layer.borderColor=DDYRGBA(44, 63, 62, 1).CGColor;
//            DDYBorderRadius(_inputView, 4, 0, [UIColor whiteColor]);
//        self.layer.cornerRadius = 2;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return self;
}

- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel)
    {
        _placeHolderLabel = [[UILabel alloc] init];
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(NSClassFromString(@"UITextView"), &count);
        for(int i =0; i < count; i ++)
        {
            NSString *ivarName = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
            if ([ivarName isEqualToString:@"_placeholderLabel"])
            {
                _placeHolderLabel.numberOfLines = 0;
                _placeHolderLabel.font = self.font;
                _placeHolderLabel.ddy_x = 5;
                _placeHolderLabel.ddy_y = 8;
                _placeHolderLabel.textAlignment = self.textAlignment;
                [self addSubview:_placeHolderLabel];
                [self setValue:_placeHolderLabel forKey:@"_placeholderLabel"];
            }
        }
        free(ivars);
    }
    return _placeHolderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeHolderLabel.text = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    [self setNeedsDisplay];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)changePlaceholderLocation
{
    if (!self.font) {
//        DDYInfoLog(@"请先设置DDYTextView对象的font");
        self.font = DDYFont(12);
    }
    _placeHolderLabel.textColor = self.placeholderTextColor;
    _placeHolderLabel.font = self.font;
    _placeHolderLabel.ddy_x = self.textContainerInset.left;
    _placeHolderLabel.ddy_w = self.ddy_w - self.textContainerInset.left - self.textContainerInset.right;
    _placeHolderLabel.ddy_y = self.textContainerInset.top;
    _placeHolderLabel.ddy_h = self.ddy_h - self.textContainerInset.top - self.textContainerInset.bottom;
    [_placeHolderLabel sizeToFit];
}

- (void)addAnnotation:(MintAnnotation *)newAnnoation
{
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
    
    //Check aleady imported
    for (MintAnnotation *annotation in self.annotationList) {
        
        if ([annotation.usr_id isEqualToString:newAnnoation.usr_id])
        {
            return;
        }
    }
    
    // Add
    if (!self.annotationList) self.annotationList = [[NSMutableArray alloc] init];
    [self.annotationList addObject:newAnnoation];
    
    // Insert Plain user name text
    NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary:[self defaultAttributedString]];
    [attr setObject:newAnnoation.usr_id forKey:keyModelId];
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc]
                                             initWithString:[NSString stringWithFormat:@"%@", newAnnoation.usr_name]
                                             attributes:attr];
    
    NSMutableAttributedString *spaceStringPefix = nil;
    NSString *tempCommentWriting = self.text;
    
    NSInteger cursor = self.selectedRange.location;
    // display name
    
    // Add Last
    if (cursor >= self.attributedText.string.length-1)
    {
        // Add Space
        if (tempCommentWriting.length > 0){
            
            NSString *prevString = [tempCommentWriting substringFromIndex:tempCommentWriting.length-1];
            
            if (![prevString isEqualToString:@"\n"])
            {
            }
        }
        
        NSMutableAttributedString *conts = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        if (spaceStringPefix)
            [conts appendAttributedString:spaceStringPefix];
        [conts appendAttributedString:nameString];
        NSMutableAttributedString *afterBlank = [[NSMutableAttributedString alloc] initWithString:@" "
                                                                                       attributes:[self defaultAttributedString]];
        [conts appendAttributedString:afterBlank];
        
        self.attributedText = conts;
        
    }
    // Insert in text
    else
    {
        self.attributedText = [self attributedStringInsertString:nameString at:cursor];
    }
    
    [self setNeedsDisplay];
    
    // Pass Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)])
        [self.delegate textViewDidChange:self];
}

- (NSAttributedString *) attributedStringInsertString:(NSAttributedString*)insertingStr at:(NSInteger)position
{
    /*
     Insert str within text at position
     with blank
     -> head + blank + insertingStr + blank + tail
     */
    
    // Cutting Heads
    NSAttributedString *head = nil;
    if (position > 0 && self.attributedText.string.length > 0)
        head = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, position)];
    else if (position > 0)
        head = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    
    
    // Cutting Tail
    NSAttributedString *tail = nil;
    if (position + 1 < self.attributedText.string.length)
        tail = [self.attributedText attributedSubstringFromRange:NSMakeRange(position,
                                                                             self.attributedText.length - position)];
    else{
        tail = [[NSMutableAttributedString alloc] initWithString:@" " attributes:[self defaultAttributedString]];
    }
    
    NSMutableAttributedString *conts = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    
    if (head)
    {
        [conts appendAttributedString:head];
        [conts appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:[self defaultAttributedString]]];
    }
    
    [conts appendAttributedString:insertingStr];
    
    if (tail)
    {
        //[conts appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:[self defaultAttributedString]]];
        [conts appendAttributedString:tail];
    }
    
    return conts;
}

- (NSDictionary*) defaultAttributedString
{
    return @{NSFontAttributeName : self.font};
}

- (BOOL) shouldChangeTextInRange:(NSRange)editingRange replacementText:(NSString *)text
{
    __block BOOL result = YES;
    
    // ALl clear
    if (editingRange.location == 0 && editingRange.length == self.attributedText.string.length && text.length == 0)
    {
        
        /*
         清空键盘
         
         [self clearAll];
         NSLog(@"<<<<<< --- all cleared by keyboard");
         
         */
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            
            [self.delegate textViewDidChange:self];
        }
        
        return YES;
    }
    
    // Checking Trying to insert within tag
    if (text.length > 0)
    {
        NSRange rangeOfCheckingEditingInTag = editingRange;
        if (rangeOfCheckingEditingInTag.location + rangeOfCheckingEditingInTag.length <= self.attributedText.length)
        {
            rangeOfCheckingEditingInTag.length = 1;
            rangeOfCheckingEditingInTag.location-=1;
            
            //            NSLog(@"<<<<< ----------- 1");
            
            //
            NSInteger totalLength = rangeOfCheckingEditingInTag.location + rangeOfCheckingEditingInTag.length;
            if (totalLength > self.attributedText.length)
            {
                rangeOfCheckingEditingInTag = NSMakeRange(0, 0);
                //                NSLog(@"<<<<< ----------- 2");
            }
            else if (totalLength < 1)
            {
                rangeOfCheckingEditingInTag = NSMakeRange(0, 0);
                //                NSLog(@"<<<<< -------------3");
            }
        }
        
        
        [self.attributedText enumerateAttributesInRange:rangeOfCheckingEditingInTag options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            if ([attrs objectForKey:keyModelId] && [self annotationForId:[attrs objectForKey:keyModelId]])
            {
                NSLog(@"------- Editing In Tag");
                result = NO;
            }
            
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            
            [self.delegate textViewDidChange:self];
        }
        
        return result;
    }
    // Deleting
    else
    {
        editingRange.location-=1;
        if (editingRange.location == -1)
            editingRange.location = 0;
        
        if (editingRange.length == 0)
        {
            //            NSLog(@"location >>>> 0");
            
            if (self.attributedText.length == 0)
            {
                [self clearAllAttributedStrings];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
                
                [self.delegate textViewDidChange:self];
            }
            
            return YES;
            
        }
        //        NSLog(@"editingRange :%d, %d",editingRange.location, editingRange.length);
        
        [self.attributedText enumerateAttributesInRange:editingRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            if ([attrs objectForKey:keyModelId] && [self annotationForId:[attrs objectForKey:keyModelId]])
            {
                MintAnnotation * mint = [self annotationForId:[attrs objectForKey:keyModelId]];
                
                NSRange tagRange = [self findTagPosition:mint];
                
                self.attributedText = [self attributedStringWithCutOutOfRange:tagRange];
                self.selectedRange = NSMakeRange(tagRange.location + 1, 0);
                
                [self.annotationList removeObject:[self annotationForId:[attrs objectForKey:keyModelId]]];
                [self setNeedsDisplay];
            }
            
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            
            [self.delegate textViewDidChange:self];
        }
        
        return YES;
        
    }
    
}

- (MintAnnotation *) annotationForId:(NSString*)usr_id
{
    for (MintAnnotation *annotation in self.annotationList) {
        
        if ([annotation.usr_id isEqualToString:usr_id])
            return annotation;
    }
    
    return nil;
}

- (NSRange) findTagPosition:(MintAnnotation*)annoation
{
    
    __block NSRange stringRange = NSMakeRange(0, 0);
    [self.attributedText enumerateAttribute:keyModelId inRange:NSMakeRange(0, self.attributedText.length-1)
                                    options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                        
                                        if ([value isEqualToString:annoation.usr_id])
                                        {
                                            stringRange = range;
                                            //                                            stringRange = CFRangeMake(range.location, range.location + range.length);
                                        }
                                        
                                    }];
    
    return stringRange;
    
}


- (void) clearAllAttributedStrings
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString removeAttribute: keyModelId range: NSMakeRange(0, self.text.length)];
    [self.annotationList removeAllObjects];
    [self setNeedsDisplay];
    //    NSLog(@"cleared attributes!");
}

- (void)clearAll
{
    [self clearAllAttributedStrings];
    self.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:[self defaultAttributedString]];
    [self setNeedsDisplay];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self setNeedsDisplay];
    
    // length = 0, but attributed have id
    if (self.attributedText.string.length == 0)
    {
        [self clearAllAttributedStrings];
    }
    
    return;
    
}

- (NSAttributedString *) attributedStringWithCutOutOfRange:(NSRange)cuttingRange
{
    /*
     Cut out string of range on full string
     to get head + tail without middle
     */
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [string deleteCharactersInRange:cuttingRange];
    
    return string;
    
    //    // Cutting Heads
    //    NSAttributedString *head = nil;
    //    if (cuttingRange.location > 0 && cuttingRange.length > 0)
    //        head = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, cuttingRange.location)];
    //    else
    //        head = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    //
    //
    //    // Cutting Tail
    //
    //    NSAttributedString *tail = nil;
    //    if (cuttingRange.location + cuttingRange.length <= self.attributedText.string.length)
    //        tail = [self.attributedText attributedSubstringFromRange:NSMakeRange(cuttingRange.location + cuttingRange.length,
    //                                                                             self.attributedText.length - 1 - cuttingRange.location - cuttingRange.length)];
    //
    //    NSMutableAttributedString *conts = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self defaultAttributedString]];
    //    if (head)
    //        [conts appendAttributedString:head];
    //    if (tail)
    //        [conts appendAttributedString:tail];
    //
    //    return conts;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self changePlaceholderLocation];
}

#pragma mark 文字size
- (CGSize)textSize {
    // 边框margin
    CGFloat boardMargin = self.contentInset.left
                        + self.contentInset.right
                        + self.textContainerInset.left
                        + self.textContainerInset.right
                        + self.textContainer.lineFragmentPadding
                        + self.textContainer.lineFragmentPadding;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    
    return [self.text boundingRectWithSize:CGSizeMake(self.ddy_w-boardMargin, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle}
                                           context:nil].size;
}

#pragma mark 调整高宽适应规定高度
- (void)heightFitMinHeight:(CGFloat)minH maxHeight:(CGFloat)maxH {
    // 边框margin
    CGFloat boardMargin = self.contentInset.top + self.contentInset.bottom + self.textContainerInset.top + self.textContainerInset.bottom;
    self.scrollEnabled = NO;
    if (self.textSize.height+boardMargin < minH) {
        self.ddy_h = minH;
    } else if (self.textSize.height+boardMargin > maxH) {
        self.ddy_h = maxH;
        self.scrollEnabled = YES;
    } else {
        self.ddy_h = ceilf(self.textSize.height+boardMargin);
    }
}

#pragma mark - UI层级调试时出现 -[UITextView _firstBaselineOffsetFromTop] only valid when using auto layout
- (void)_firstBaselineOffsetFromTop {}
- (void)_baselineOffsetFromBottom {}

@end
