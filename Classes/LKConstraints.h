//
//  LKConstraints.h
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 07/03/13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKConstraints;

typedef enum
{
    LK_left,
    LK_right,
    LK_top,
    LK_bottom,
    LK_leading,
    LK_trailing,
    LK_width,
    LK_height,
    LK_center_x,
    LK_center_y,
    LK_baseline,
    LK_na,
} LK_attribute;

typedef enum
{
    LK_less_than,
    LK_equal_to,
    LK_greater_than,
} LK_relation;

typedef void (^LKLayoutBlock)(LKConstraints *c);

@interface LKConstraints : NSObject

+ (LKConstraints *)layout:(UIView *)view do:(LKLayoutBlock)layoutBlock;
- (id)initWithView:(UIView *)view;

- (void)set:(LK_attribute)attribute to:(CGFloat)constant;
- (void)set:(LK_attribute)attribute to:(CGFloat)constant name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute on:(UIView *)targetView;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute on:(UIView *)targetView name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier name:(NSString *)name;

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute;
- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute name:(NSString *)name;

@end
