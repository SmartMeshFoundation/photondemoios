//
//  DDYTextView.h
//  DDYProject
//
//  Created by Megan on 17/7/27.
//  Copyright © 2017 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MintAnnotation : NSObject

@property(nonatomic, strong) NSString *usr_id;
@property(nonatomic, strong) NSString *usr_name;

@end

@interface DDYTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderTextColor;

/** 文字 */
@property (nonatomic, assign, readonly) CGSize textSize;

@property(nonatomic,strong) NSMutableArray *annotationList;


- (void)addAnnotation:(MintAnnotation *)newAnnoation;

//- (void)removeAnnota

+ (instancetype)textView;

+ (instancetype)textViewPlaceholder:(NSString *)placeholder font:(UIFont *)font;

+ (instancetype)textViewPlaceholder:(NSString *)placeholder font:(UIFont *)font frame:(CGRect)frame;
 
/** 调整高宽适应规定高度 */
- (void)heightFitMinHeight:(CGFloat)minH maxHeight:(CGFloat)maxH;

- (BOOL)shouldChangeTextInRange:(NSRange)editingRange replacementText:(NSString *)text;

@end
