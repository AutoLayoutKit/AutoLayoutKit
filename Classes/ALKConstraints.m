//  ALKConstraints.m
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

#import "ALKConstraints.h"
#import "UIView+ALKNamedConstraints.h"

@interface ALKConstraints ()

@property (nonatomic, strong) UIView *item;

@end

@implementation ALKConstraints

+ (ALKConstraints *)layout:(UIView *)view do:(LKLayoutBlock)layoutBlock;
{
    ALKConstraints *c = [[ALKConstraints alloc] initWithView:view];
    layoutBlock(c);
    
    return c;
}

- (id)initWithView:(UIView *)view
{
    if (self = [super init]) {
        self.item = view;
        [self.item setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    }
    
    return self;
}

#pragma mark - DSL (SET)

- (void)set:(ALKAttribute)attribute to:(CGFloat)constant
{
    set(self.item, attribute, constant, nil);
}

- (void)set:(ALKAttribute)attribute to:(CGFloat)constant name:(NSString *)name
{
    set(self.item, attribute, constant, name);
}

#pragma mark - DSL (MAKE)

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView
{
    make(self.item, attribute, ALKEqualTo, relatedItem, relatedAttribute, multiplier, constant, targetView, nil);
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name
{
    make(self.item, attribute, ALKEqualTo, relatedItem, relatedAttribute, multiplier, constant, targetView, name);
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:targetView];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:targetView
          name:name];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:targetView];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:targetView
          name:name];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute on:(UIView *)targetView
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:0.f
            on:targetView];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute on:(UIView *)targetView name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:0.f
            on:targetView
          name:name];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:constant
            on:self.item.superview];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:constant
            on:self.item.superview
          name:name];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:self.item.superview];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute plus:(CGFloat)constant name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:self.item.superview
          name:name];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:self.item.superview];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute times:(CGFloat)multiplier name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:self.item.superview
          name:name];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:0.f
            on:self.item.superview];
}

- (void)make:(ALKAttribute)attribute equalTo:(id)relatedItem s:(ALKAttribute)relatedAttribute name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:0.f
            on:self.item.superview
          name:name];
}

#pragma mark - Functions

void set (UIView *item,
          ALKAttribute itemAttribute,
          CGFloat constant,
          NSString *name)
{
    createLayoutConstraint(item, itemAttribute, ALKEqualTo, nil, ALKNone, 1.f, constant, item, name);
}

void make(UIView *item,
          ALKAttribute itemAttribute,
          ALKRelation relation,
          id relatedItem,
          ALKAttribute relatedItemAttribute,
          CGFloat multiplier,
          CGFloat constant,
          UIView *targetItem,
          NSString *name)
{
    createLayoutConstraint(item, itemAttribute, relation, relatedItem, relatedItemAttribute, multiplier, constant, targetItem, name);
}

NSLayoutConstraint * createLayoutConstraint(UIView *item,
                                            ALKAttribute itemAttribute,
                                            ALKRelation relation,
                                            id relatedItem,
                                            ALKAttribute relatedItemAttribute,
                                            CGFloat multiplier,
                                            CGFloat constant,
                                            UIView *targetItem,
                                            NSString *name)
{
    NSLayoutAttribute itemAttributeValue = [ALKConstraints enumToAttribute:itemAttribute];
    NSLayoutRelation relationValue = [ALKConstraints enumToRelation:relation];
    NSLayoutAttribute relatedItemAttributeValue = [ALKConstraints enumToAttribute:relatedItemAttribute];
    
    NSLayoutConstraint *lc = [NSLayoutConstraint constraintWithItem:item
                                                          attribute:itemAttributeValue
                                                          relatedBy:relationValue
                                                             toItem:relatedItem
                                                          attribute:relatedItemAttributeValue
                                                         multiplier:multiplier
                                                           constant:constant];
    
    if (nil != name) {
        [targetItem alk_addConstraint:lc withName:name];
    } else {
        [targetItem addConstraint:lc];
    }
    
    return lc;
}

#pragma mark - ENUM Conversion

+ (NSLayoutAttribute)enumToAttribute:(ALKAttribute)attribute
{
    switch (attribute) {
        case ALKLeft:
            return NSLayoutAttributeLeft;
        case ALKRight:
            return NSLayoutAttributeRight;
        case ALKTop:
            return NSLayoutAttributeTop;
        case ALKBottom:
            return NSLayoutAttributeBottom;
        case ALKLeading:
            return NSLayoutAttributeLeading;
        case ALKTrailing:
            return NSLayoutAttributeTrailing;
        case ALKWidth:
            return NSLayoutAttributeWidth;
        case ALKHeight:
            return NSLayoutAttributeHeight;
        case ALKCenterX:
            return NSLayoutAttributeCenterX;
        case ALKCenterY:
            return NSLayoutAttributeCenterY;
        case ALKBaseline:
            return NSLayoutAttributeBaseline;
        case ALKNone:
            return NSLayoutAttributeNotAnAttribute;
    }
}

+ (NSLayoutRelation)enumToRelation:(ALKRelation)relation
{
    switch (relation) {
        case ALKLessThan:
            return NSLayoutRelationLessThanOrEqual;
        case ALKEqualTo:
            return NSLayoutRelationEqual;
        case ALKGreaterThan:
            return NSLayoutRelationGreaterThanOrEqual;
    }
}

@end
