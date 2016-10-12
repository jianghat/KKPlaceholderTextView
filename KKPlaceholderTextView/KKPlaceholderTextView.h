//
//  KKPlaceholderTextView.h
//  Demo
//
//  Created by jianghat on 16/10/11.
//  Copyright © 2016年 jianghat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKPlaceholderTextView;

typedef void(^KKPlaceholderTextViewHandler)(KKPlaceholderTextView *textView);

@interface KKPlaceholderTextView : UITextView

@property (nonatomic, assign) NSUInteger maxLength; //最大限制文本长度, 默认为无穷大(即不限制).

@property (nonatomic, assign) CGFloat    cornerRadius; //圆角半径.
@property (nonatomic, assign) CGFloat    borderWidth; //边框宽度.
@property (nonatomic, strong) UIColor   *borderColor; //边框颜色.

@property (nonatomic, copy)   NSString *placeholder; //placeholder, 会自适应TextView宽高以及横竖屏切换, 字体默认和TextView一致.
@property (nonatomic, strong) UIColor  *placeholderColor; //placeholder文本颜色, 默认为#C7C7CD.
@property (nonatomic, strong) UIFont   *placeholderFont; //placeholder文本字体, 默认为UITextView的默认字体.


/*! @brief 设定文本改变Block回调. (切记弱化引用, 以免造成内存泄露.)
 */
- (void)addTextDidChangeHandler:(KKPlaceholderTextViewHandler)eventHandler;

/*! @brief 设定达到最大长度Block回调. (切记弱化引用, 以免造成内存泄露.)
 */
- (void)addTextLengthDidMaxHandler:(KKPlaceholderTextViewHandler)maxHandler;

@end
