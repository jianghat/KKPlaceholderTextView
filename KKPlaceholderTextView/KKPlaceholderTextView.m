//
//  KKPlaceholderTextView.m
//  Demo
//
//  Created by jianghat on 16/10/11.
//  Copyright © 2016年 jianghat. All rights reserved.
//

#import "KKPlaceholderTextView.h"

CGFloat const kTextViewPlaceholderVerticalMargin  = 8.0; ///< placeholder垂直方向边距
CGFloat const kTextViewPlaceholderHorizontalMargin = 6.0; ///< placeholder水平方向边距

@interface KKPlaceholderTextView ()

@property (nonatomic, copy) KKPlaceholderTextViewHandler changeHandler; //文本改变Block
@property (nonatomic, copy) KKPlaceholderTextViewHandler maxHandler; //达到最大限制字符数Block
@property (nonatomic, strong) UILabel *placeholderLabel; //placeholderLabel

@end

@implementation KKPlaceholderTextView

- (void)awakeFromNib {
  [super awakeFromNib];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
    [self layoutIfNeeded];
  }
  [self initialize];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initialize];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _changeHandler = NULL;
  _maxHandler = NULL;
}

- (void)initialize {
  // 监听文本变化
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
  
  // 基本配置
  _maxLength = NSUIntegerMax;
  
  // 基本设定
  self.backgroundColor = [UIColor whiteColor];
  self.font = [UIFont systemFontOfSize:15.f];
  
  // placeholderLabel
  [self addSubview:self.placeholderLabel];
  
  // constraint
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeTop
                                                  multiplier:1.0
                                                    constant:kTextViewPlaceholderVerticalMargin]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                   attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeLeft
                                                  multiplier:1.0
                                                    constant:kTextViewPlaceholderHorizontalMargin]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1.0
                                                    constant:-kTextViewPlaceholderHorizontalMargin*2]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeHeight
                                                  multiplier:1.0
                                                    constant:-kTextViewPlaceholderVerticalMargin*2]];
}

- (void)addTextDidChangeHandler:(KKPlaceholderTextViewHandler)changeHandler {
  _changeHandler = [changeHandler copy];
}

- (void)addTextLengthDidMaxHandler:(KKPlaceholderTextViewHandler)maxHandler {
  _maxHandler = [maxHandler copy];
}

#pragma mark - NSNotification

- (void)textDidChange:(NSNotification *)notification {
  // 根据字符数量显示或者隐藏placeholderLabel
  _placeholderLabel.hidden = [@(self.text.length) boolValue];
  
  // 禁止第一个字符输入空格或者换行
  if (self.text.length == 1) {
    if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
      self.text = @"";
    }
  }
  
  if (_maxLength != NSUIntegerMax) { // 只有当maxLength字段的值不为无穷大整型时才计算限制字符数.
    NSString    *toBeString    = self.text;
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position   = [self positionFromPosition:selectedRange.start offset:0];
    if (!position) {
      if (toBeString.length > _maxLength) {
        self.text = [toBeString substringToIndex:_maxLength]; // 截取最大限制字符数.
        _maxHandler?_maxHandler(self):NULL; // 回调达到最大限制的Block.
      }
    }
  }
  
  // 回调文本改变的Block.
  _changeHandler?_changeHandler(self):NULL;
}


#pragma mark- Custom Access

- (UILabel *)placeholderLabel {
  if (!_placeholderLabel) {
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = self.font;
    _placeholderLabel.textColor = self.placeholderColor;
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _placeholderLabel;
}

- (UIColor *)placeholderColor {
  if (!_placeholder) {
    _placeholderColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.000];
  }
  return _placeholderColor;
}

- (void)setText:(NSString *)text {
  [super setText:text];
  self.placeholderLabel.hidden = [@(text.length) boolValue];
}

- (void)setFont:(UIFont *)font {
  [super setFont:font];
  self.placeholderLabel.font = font;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
  if (borderColor) {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
  }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  _borderWidth = borderWidth;
  self.layer.borderWidth = _borderWidth;
}

- (void)setPlaceholder:(NSString *)placeholder {
  if (placeholder) {;
    _placeholder = placeholder;
    if (_placeholder.length > 0) {
      self.placeholderLabel.text = _placeholder;
    }
  }
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
  if (placeholderFont) {
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = _placeholderFont;
  }
}

@end
