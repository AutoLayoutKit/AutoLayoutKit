//
//  ALKConstraints.h
//  AutoLayoutKit
//
//  Created by Florian Krüger on 07/03/13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALKConstraints;

typedef NS_ENUM(NSInteger, ALKAttribute) {
    ALKLeft,
    ALKRight,
    ALKTop,
    ALKBottom,
    ALKLeading,
    ALKTrailing,
    ALKWidth,
    ALKHeight,
    ALKCenterX,
    ALKCenterY,
    ALKBaseline,
    ALKNone
};

typedef NS_ENUM(NSInteger, ALKRelation) {
    ALKLessThan,
    ALKEqualTo,
    ALKGreaterThan
};

typedef void (^LKLayoutBlock)(ALKConstraints *c);

@interface ALKConstraints : NSObject

+ (ALKConstraints *)layout:(UIView *)view do:(LKLayoutBlock)layoutBlock;
- (id)initWithView:(UIView *)view;

- (void)set:(ALKAttribute)attribute to:(CGFloat)constant;
- (void)set:(ALKAttribute)attribute to:(CGFloat)constant name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute on:(UIView *)targetView;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute on:(UIView *)targetView name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier name:(NSString *)name;

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute;
- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute name:(NSString *)name;

@end
