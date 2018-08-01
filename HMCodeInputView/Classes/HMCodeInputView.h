//
//  HMCodeInputView.h
//  HMCodeInputView
//
//  Created by JK on 2018/8/1.
//

#import <UIKit/UIKit.h>

@interface HMCodeInputView : UIView

/**
 初始化创建

 @param frame 位置
 @param maxLength 验证码长度
 @param borderColor 验证码边框颜色
 @param borderColorHL 验证码选中状态下颜色
 */
- (instancetype)initWithFrame:(CGRect)frame
                    maxLength:(NSInteger)maxLength
                  borderColor:(UIColor *)borderColor
                borderColorHL:(UIColor *)borderColorHL
                 keyboardType:(UIKeyboardType)keyboardType
                    codeBlock:(void(^)(NSString *code))codeBlock;

@end
