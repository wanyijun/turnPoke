//
//  ViewController.m
//  PokerAnimation
//
//  Created by liby on 2018/5/25.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "ViewController.h"
#import "UIView+GetFrameProperty.h"
#import <math.h>

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//弧度转角度
#define Radians_To_Degrees(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define Degrees_To_Radians(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()
@property (nonatomic, strong) UIImageView *backImgv;
@property (nonatomic, strong) UIImageView *frontImgv;

@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) UIImage *frontImage;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat radians;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGAffineTransform transform;

@property (nonatomic, assign) BOOL isInRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.bounds = CGRectMake(-200, -200, kWidth, kHeight);
    
    //从Bundle中读取图片
    self.backImage = [UIImage imageNamed:@"back"];
    self.frontImage = [UIImage imageNamed:@"1-9"];
    self.width = self.backImage.size.width;
    self.height = self.backImage.size.height;
    
    
    //创建UIImageView并显示在界面上
    self.backImgv = [[UIImageView alloc] initWithImage:self.backImage];
    [self.view addSubview:self.backImgv];
    self.frontImgv = [[UIImageView alloc] initWithImage:self.frontImage];
    self.transform = self.frontImgv.transform;
    self.frontImgv.hidden = YES;
    [self.view addSubview:self.frontImgv];
    
}

- (UIImage *)drawImageV:(NSArray *)arr image:(UIImage *)img {
    
    //开始绘制图片
    UIGraphicsBeginImageContext(self.backImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    // 绘制Clip区域
    if (arr) {
        CGPoint p1, p2;
        if ([img isEqual:self.backImage]) {
            p1 = [arr[0] CGPointValue];
            p2 = [arr[1] CGPointValue];
        } else {
            p1 = [arr[2] CGPointValue];
            p2 = [arr[3] CGPointValue];
        }
        CGContextMoveToPoint(gc, 0, 0);
        CGContextAddLineToPoint(gc, p1.x, p1.y);
        CGContextAddLineToPoint(gc, p2.x, p2.y);
        CGContextAddLineToPoint(gc, self.width, 0);
        CGContextClosePath(gc);
        CGContextClip(gc);
    }
    
    //坐标系转换
    //因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    CGContextTranslateCTM(gc, 0, self.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, self.width, self.height), [img CGImage]);
    
    //结束绘画
    UIImage *destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImg;
}

- (NSArray *)calculat:(CGPoint)location {
    CGFloat a = 0;
    CGFloat b = self.height;
    CGFloat c = location.x;
    CGFloat d = location.y;
    CGFloat x1 = 0;
    CGFloat y1 = [self backYWithA:a B:b C:c D:d X:x1];
    CGPoint p1 = CGPointMake(x1, y1);
    CGPoint p3 = CGPointMake(x1, self.height - y1);
    CGFloat x2 = self.width;
    CGFloat y2 = [self backYWithA:a B:b C:c D:d X:x2];
    CGPoint p2 = CGPointMake(x2, y2);
    CGPoint p4 = CGPointMake(x2, self.height - y2);
    self.radians = [self getAnglesWithThreePoint:CGPointZero pointB:p1 pointC:location];
    self.center = [self getCenterWithPoint:p1 location:location];
    return @[[NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2], [NSValue valueWithCGPoint:p3], [NSValue valueWithCGPoint:p4]];
}
- (CGFloat)backYWithA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c D:(CGFloat)d X:(CGFloat)x {
    return ((a - c)*(x - (a + c) / 2) / (d - b) + (d + b) / 2);
}

- (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC {
    
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    if (pointB.y < 0) {
        angle = M_PI - angle;
    }
    return angle;
}
- (CGPoint)getCenterWithPoint:(CGPoint)p1 location:(CGPoint)location  {
    // location.y > p1.y
    if (location.y > p1.y) {
        CGFloat radian1 = M_PI - self.radians;
        CGFloat x1 = sin(radian1) * self.height;
        CGFloat x2 = cos(radian1) * self.width;
        CGFloat x = location.x - (x1 + x2) * 0.5;
        CGFloat distance = sqrt(pow((p1.x - location.x), 2) + pow((p1.y - location.y), 2));
        CGFloat ys = cos(radian1) * (self.height - distance);
        CGFloat y1 = cos(radian1) * self.height;
        CGFloat y2 = sin(radian1) * self.width;
        CGFloat y = (p1.y - ys ) + (y1 + y2) * 0.5;
        return CGPointMake(x, y);
    } else {
        CGFloat x1 = sin(self.radians) * self.height;
        CGFloat x2 = cos(self.radians) * self.width;
        CGFloat x = location.x - x1 + (x1 + x2) * 0.5;
        CGFloat y1 = cos(self.radians) * self.height;
        CGFloat y2 = sin(self.radians) * self.width;
        CGFloat y = location.y + (y1 + y2) * 0.5;
        return CGPointMake(x, y);
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    if (location.x > 0 && location.y > self.height - 20 && location.x < 20 && location.y < self.height && touches.count == 1) {
        self.isInRect = YES;
        if (self.frontImgv.hidden) {
            self.frontImgv.hidden = NO;
        }
        self.backImgv.image = [self drawImageV:[self calculat:location] image:self.backImage];
        self.frontImgv.image = [self drawImageV:[self calculat:location] image:self.frontImage];
        self.frontImgv.transform = CGAffineTransformRotate(self.transform, self.radians);
        self.frontImgv.center = self.center;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isInRect) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    if (location.x < 0) {
        location = CGPointMake(0, location.y);
    } else if (location.x > self.width) {
        location = CGPointMake(self.width, location.y);
    }
    if (location.y < 0) {
        location = CGPointMake(location.x, 0);
    } else if (location.y > self.height) {
        location = CGPointMake(location.x, self.height - 1);
    }
    self.backImgv.image = [self drawImageV:[self calculat:location] image:self.backImage];
    self.frontImgv.image = [self drawImageV:[self calculat:location] image:self.frontImage];
    self.frontImgv.transform = CGAffineTransformRotate(self.transform, self.radians);
    self.frontImgv.center = self.center;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isInRect) {
        return;
    }
    self.isInRect = NO;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    if (location.y < self.height * 0.3) {
        self.frontImgv.image = self.frontImage;
        self.frontImgv.transform = CGAffineTransformIdentity;
        self.frontImgv.frame = self.backImgv.frame;
    } else {
        self.frontImgv.hidden = YES;
        self.backImgv.image = self.backImage;
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


@end
