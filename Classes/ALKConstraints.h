//  ALKConstraints.h
//  AutoLayoutKit
//
//  Copyright (c) 2013 Florian Krueger <florian.krueger@projectserver.org>
//  Created on 07/03/13.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
