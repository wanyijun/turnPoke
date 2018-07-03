//
//  UIView+GetFrameProperty.m
//  ShangPinFamily
//
//  Created by mac2 on 16/9/7.
//  Copyright © 2016年 shenyanlong. All rights reserved.
//

#import "UIView+GetFrameProperty.h"

@implementation UIView (GetFrameProperty)
-(void)setX:(CGFloat)X {
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(X, origionRect.origin.y, origionRect.size.width, origionRect.size.height);
    self.frame = newRect;
}
-(CGFloat)X {
    return self.frame.origin.x;
}


-(void)setY:(CGFloat)Y {
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, Y, origionRect.size.width, origionRect.size.height);
    self.frame = newRect;
}
-(CGFloat)Y {
    return self.frame.origin.y;
}

-(void)setW:(CGFloat)W {
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y,W, origionRect.size.height);
    self.frame = newRect;
}
-(CGFloat)W {
    return self.frame.size.width;
}

-(void)setH:(CGFloat)H {
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y,origionRect.size.width, H);
    self.frame = newRect;
}
-(CGFloat)H {
    return self.frame.size.height;
}
#pragma mark - Shortcuts for frame properties

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
#pragma mark - Shortcuts for positions

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}
+ (instancetype)viewFromXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
@end
