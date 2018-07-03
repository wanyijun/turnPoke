//
//  UIView+GetFrameProperty.h
//  ShangPinFamily
//
//  Created by mac2 on 16/9/7.
//  Copyright © 2016年 shenyanlong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (GetFrameProperty)
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat  X;
@property (nonatomic, assign) CGFloat  Y;
@property (nonatomic, assign) CGFloat  W;
@property (nonatomic, assign) CGFloat  H;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;
/**
 * 从xib初始化控件
 */
+ (instancetype)viewFromXib;
@end
