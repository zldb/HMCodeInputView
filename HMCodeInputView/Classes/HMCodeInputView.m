//
//  HMCodeInputView.m
//  HMCodeInputView
//
//  Created by JK on 2018/8/1.
//

#import "HMCodeInputView.h"

@interface HMCodeInputView () <UITextViewDelegate>

/**
 背景textView输入框
 */
@property (nonatomic, strong) UITextView * textView;

/**
 输入的验证码标签数组
 */
@property (nonatomic, strong) NSMutableArray * labelArr;

/**
 闪烁线位置数组
 */
@property (nonatomic, strong) NSMutableArray * pointLineArr;

/**
 键盘模式
 */
@property (nonatomic, assign) UIKeyboardType keyBoardType;

/**
 验证码的最大长度
 */
@property (nonatomic, assign) NSInteger maxLength;

/**
 未选中下的label的borderColor
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 选中下的label的borderColor
 */
@property (nonatomic, strong) UIColor *borderColorHL;

/**
 输入文字回调
 */
@property (nonatomic, copy) void(^CodeBlock)(NSString *text);

@end

@implementation HMCodeInputView

- (instancetype)initWithFrame:(CGRect)frame
                    maxLength:(NSInteger)maxLength
                  borderColor:(UIColor *)borderColor
                borderColorHL:(UIColor *)borderColorHL
                 keyboardType:(UIKeyboardType)keyboardType
                    codeBlock:(void (^)(NSString *))codeBlock {
    if (self = [super initWithFrame:frame]) {
        self.keyBoardType           = keyboardType;
        self.maxLength              = maxLength;
        self.borderColorHL          = borderColorHL;
        self.borderColor            = borderColor;
        self.CodeBlock              = codeBlock;
        [self configCodeLabelWithFrame:frame];
    }
    return self;
}

#pragma mark 初始化验证码显示框
- (void)configCodeLabelWithFrame:(CGRect)frame {
    if (self.maxLength <= 0) {
        return;
    }
    
    self.textView = [[UITextView alloc] init];
    self.textView.tintColor = [UIColor clearColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor clearColor];
    self.textView.delegate = self;
    self.textView.keyboardType  = self.keyBoardType;
    self.textView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self addSubview:self.textView];
    
    CGFloat padding = (CGRectGetWidth(frame) - self.maxLength * CGRectGetHeight(frame)) / (self.maxLength - 1);
    CGFloat height = frame.size.height;
    self.labelArr = [NSMutableArray array];
    self.pointLineArr = [NSMutableArray array];
    for (int i = 0; i < self.maxLength; i++) {
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.backgroundColor = [UIColor whiteColor];
        subLabel.layer.cornerRadius = 4;
        subLabel.layer.borderWidth = (0.5);
        subLabel.layer.borderColor = self.borderColor.CGColor;
        subLabel.userInteractionEnabled = NO;
        [self addSubview:subLabel];
        subLabel.frame = CGRectMake((i * (padding + height)), 0, height, height);
        subLabel.textAlignment = NSTextAlignmentCenter;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((CGRectGetHeight(frame) - 2) / 2, 10, 2,(CGRectGetHeight(self.frame) - 20))];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor = self.borderColorHL.CGColor;
        [subLabel.layer addSublayer:line];
        if (i == 0) {//初始化第一个view为选择状态
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            line.hidden = NO;
            subLabel.layer.borderColor = self.borderColorHL.CGColor;
        } else {
            line.hidden = YES;
            subLabel.layer.borderColor = self.borderColorHL.CGColor;
        }
        
        [self.labelArr addObject:subLabel];
        [self.pointLineArr addObject:line];
    }
}

#pragma mark 中间线动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *verStr = textView.text;
    //有空格去掉空格
    verStr = [verStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (verStr.length >= self.maxLength) {
        verStr = [verStr substringToIndex:self.maxLength];
        [self endEditing:YES];
    }
    textView.text = verStr;
    
    for (int i= 0; i < self.labelArr.count; i++) {
        //以text为中介区分
        UILabel *label = self.labelArr[i];
        if (i < verStr.length) {
            [self changeViewLayerIndex:i pointHidden:YES];
            label.text = [verStr substringWithRange:NSMakeRange(i, 1)];
            
        }else{
            [self changeViewLayerIndex:i pointHidden:i == verStr.length?NO:YES];
            if (!verStr&&verStr.length == 0) {//textView的text为空的时候
                [self changeViewLayerIndex:0 pointHidden:NO];
            }
            label.text = @"";
        }
    }
    
    if (self.CodeBlock) {
        //将textView的值传出去
        self.CodeBlock(verStr);
    }
}

// 改变闪烁线位置
- (void)changeViewLayerIndex:(NSInteger)index pointHidden:(BOOL)hidden {
    
    UIView *view = self.labelArr[index];
    view.layer.borderColor = hidden ? self.borderColor.CGColor : self.borderColorHL.CGColor;
    CAShapeLayer *line = self.pointLineArr[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    line.hidden = hidden;
    
}

@end
