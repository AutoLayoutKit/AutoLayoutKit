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

@property (nonatomic, strong, nonnull) UIView * item;
@property (nonatomic, assign) UILayoutPriority priority;

@end

@implementation ALKConstraints

+ (nonnull ALKConstraints *) layout:(nonnull UIView *) view do:(nonnull LKLayoutBlock) layoutBlock {
    ALKConstraints *c = [[ALKConstraints alloc] initWithView:view];
    layoutBlock(c);
    
    return c;
}

- (nonnull instancetype) initWithView:(nonnull UIView *) view {
    self = [super init];
    if (self) {
        self.item = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.priority = UILayoutPriorityRequired;
    }
    
    return self;
}

#pragma mark - PRIORITY

- (void) setPriorityRequired {
    [self setPriority:UILayoutPriorityRequired];
}

- (void) setPriorityDefaultHigh {
    [self setPriority:UILayoutPriorityDefaultHigh];
}

- (void) setPriorityDefaultLow {
    [self setPriority:UILayoutPriorityDefaultLow];
}

- (void) setPriorityFittingSizeLevel {
    [self setPriority:UILayoutPriorityFittingSizeLevel];
}

#pragma mark - DSL (SET)

- (nonnull NSLayoutConstraint *) set:(ALKAttribute) attribute to:(CGFloat) constant {
    return set(self.item, attribute, constant, nil, self.priority);
}

- (nonnull NSLayoutConstraint *) set:(ALKAttribute) attribute to:(CGFloat) constant name:(nullable NSString *) name {
    return set(self.item, attribute, constant, name, self.priority);
}

#pragma mark - DSL (MAKE)

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return make(self.item, attribute, ALKEqualTo, relatedItem, relatedAttribute, multiplier, constant, targetView, nil, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return make(self.item, attribute, ALKEqualTo, relatedItem, relatedAttribute, multiplier, ((-1) * constant), targetView, nil, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return make(self.item, attribute, ALKEqualTo, relatedItem, relatedAttribute, multiplier, constant, targetView, name, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return make(self.item, attribute, ALKEqualTo, relatedItem, relatedAttribute, multiplier, ((-1) * constant), targetView, name, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier on:(nonnull UIView *) targetView {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute on:(nonnull UIView *) targetView {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                minus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                minus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute equalTo:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute name:(nullable NSString *) name {
    return [self make:attribute
              equalTo:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:self.item.superview
                 name:name];
}

#pragma mark - DSL (MAKE/LESSTHAN)

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return make(self.item, attribute, ALKLessThan, relatedItem, relatedAttribute, multiplier, constant, targetView, nil, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return make(self.item, attribute, ALKLessThan, relatedItem, relatedAttribute, multiplier, ((-1) * constant), targetView, nil, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return make(self.item, attribute, ALKLessThan, relatedItem, relatedAttribute, multiplier, constant, targetView, name, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return make(self.item, attribute, ALKLessThan, relatedItem, relatedAttribute, multiplier, ((-1) * constant), targetView, name, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier on:(nonnull UIView *) targetView {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute on:(nonnull UIView *) targetView {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                minus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                minus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute lessThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute name:(nullable NSString *) name {
    return [self make:attribute
             lessThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:self.item.superview
                 name:name];
}

#pragma mark - DSL (MAKE/GREATERTHAN)

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return make(self.item, attribute, ALKGreaterThan, relatedItem, relatedAttribute, multiplier, constant, targetView, nil, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return make(self.item, attribute, ALKGreaterThan, relatedItem, relatedAttribute, multiplier, ((-1) * constant), targetView, nil, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return make(self.item, attribute, ALKGreaterThan, relatedItem, relatedAttribute, multiplier, constant, targetView, name, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return make(self.item, attribute, ALKGreaterThan, relatedItem, relatedAttribute, multiplier, ((-1) * constant), targetView, name, self.priority);
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant on:(nonnull UIView *) targetView {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier on:(nonnull UIView *) targetView {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute on:(nonnull UIView *) targetView {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:targetView];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute on:(nonnull UIView *) targetView name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:targetView
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                minus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier plus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier minus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                minus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute plus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute minus:(CGFloat) constant name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                minus:constant
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute times:(CGFloat) multiplier name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:multiplier
                 plus:0.f
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:self.item.superview];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute greaterThan:(nullable id) relatedItem s:(ALKAttribute) relatedAttribute name:(nullable NSString *) name {
    return [self make:attribute
          greaterThan:relatedItem
                    s:relatedAttribute
                times:1.f
                 plus:0.f
                   on:self.item.superview
                 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute
                      equalToSafeArea:(nullable id) relatedItem
                                    s:(ALKAttribute) relatedAttribute
                                 plus:(CGFloat) constant
                                 name:(nullable NSString *) name {
    NSLayoutConstraint * lc = nil;
#if defined(NSFoundationVersionNumber_iOS_9_0)
    lc = makeSafeArea(self.item, attribute, relatedItem, relatedAttribute, constant, self.item.superview, name, self.priority);
#endif
    return lc ? lc : [self make:attribute equalTo:relatedItem s:relatedAttribute times:1 plus:constant name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute
                      equalToSafeArea:(nullable id) relatedItem
                                    s:(ALKAttribute) relatedAttribute
                                minus:(CGFloat) constant
                                 name:(nullable NSString *) name {
    NSLayoutConstraint * lc = nil;
#if defined(NSFoundationVersionNumber_iOS_9_0)
    lc = makeSafeArea(self.item, attribute, relatedItem, relatedAttribute, -constant, self.item.superview, name, self.priority);
#endif
    return lc ? lc : [self make:attribute equalTo:relatedItem s:relatedAttribute times:1 minus:constant name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute
                      equalToSafeArea:(nullable id) relatedItem
                                    s:(ALKAttribute) relatedAttribute
                                 name:(nullable NSString *) name {
    NSLayoutConstraint * lc = nil;
#if defined(NSFoundationVersionNumber_iOS_9_0)
    lc = makeSafeArea(self.item, attribute, relatedItem, relatedAttribute, 0, self.item.superview, name, self.priority);
#endif
    return lc ? lc : [self make:attribute equalTo:relatedItem s:relatedAttribute times:1 plus:0 name:name];
}

- (nonnull NSLayoutConstraint *) make:(ALKAttribute) attribute
                      equalToSafeArea:(nullable id) relatedItem
                                    s:(ALKAttribute) relatedAttribute {
    NSLayoutConstraint * lc = nil;
#if defined(NSFoundationVersionNumber_iOS_9_0)
    lc = makeSafeArea(self.item, attribute, relatedItem, relatedAttribute, 0, self.item.superview, nil, self.priority);
#endif
    return lc ? lc : [self make:attribute equalTo:relatedItem s:relatedAttribute times:1 plus:0 name:nil];
}

#pragma mark - Functions

#if defined(NSFoundationVersionNumber_iOS_9_0)

static NSLayoutConstraint * _Nullable makeSafeArea(UIView * _Nonnull item,
                                                   ALKAttribute itemAttribute,
                                                   id _Nullable relatedItem,
                                                   ALKAttribute relatedItemAttribute,
                                                   CGFloat constant,
                                                   UIView * _Nonnull targetItem,
                                                   NSString * _Nullable name,
                                                   UILayoutPriority priority) {
    NSLayoutConstraint * lc = nil;
    if (@available(iOS 11, *)) {
        NSLayoutAnchor * anchor = viewLayoutAnchor(item, itemAttribute);
        NSLayoutAnchor * relatedAnchor = relatedItem ? guideLayoutAnchor(((UIView *)relatedItem).safeAreaLayoutGuide, relatedItemAttribute) : nil;
        lc = (anchor && relatedAnchor) ? [anchor constraintEqualToAnchor:relatedAnchor] : nil;
        if (lc) {
            lc.constant = constant;
            lc.priority = priority;
            if (name) {
                [targetItem alk_addConstraint:lc withName:name];
            } else {
                lc.active = YES;
            }
        }
    }
    return lc;
}

static id _Nullable viewLayoutAnchor(UIView * _Nonnull view, ALKAttribute attribute) {
    if (@available(iOS 9, *)) {
        switch (attribute) {
            case ALKLeft: return view.leftAnchor;
            case ALKRight: return view.rightAnchor;
            case ALKTop: return view.topAnchor;
            case ALKBottom: return view.bottomAnchor;
            case ALKLeading: return view.leadingAnchor;
            case ALKTrailing: return view.trailingAnchor;
            case ALKWidth: return view.widthAnchor;
            case ALKHeight: return view.heightAnchor;
            case ALKCenterX: return view.centerXAnchor;
            case ALKCenterY: return view.centerYAnchor;
            case ALKBaseline: return view.firstBaselineAnchor;
            case ALKNone: return nil;
        }
    }
    return nil;
}

static id _Nullable guideLayoutAnchor(id _Nonnull guide, ALKAttribute attribute) {
    if (@available(iOS 9, *)) {
        UILayoutGuide * layoutGuide = (UILayoutGuide *)guide;
        switch (attribute) {
            case ALKLeft: return layoutGuide.leftAnchor;
            case ALKRight: return layoutGuide.rightAnchor;
            case ALKTop: return layoutGuide.topAnchor;
            case ALKBottom: return layoutGuide.bottomAnchor;
            case ALKLeading: return layoutGuide.leadingAnchor;
            case ALKTrailing: return layoutGuide.trailingAnchor;
            case ALKWidth: return layoutGuide.widthAnchor;
            case ALKHeight: return layoutGuide.heightAnchor;
            case ALKCenterX: return layoutGuide.centerXAnchor;
            case ALKCenterY: return layoutGuide.centerYAnchor;
            case ALKBaseline:
            case ALKNone: return nil;
        }
    }
    return nil;
}

#endif

static NSLayoutConstraint * _Nonnull set(UIView * _Nonnull item,
                                         ALKAttribute itemAttribute,
                                         CGFloat constant,
                                         NSString * _Nullable name,
                                         UILayoutPriority priority) {
    return createLayoutConstraint(item, itemAttribute, ALKEqualTo, nil, ALKNone, 1.f, constant, item, name, priority);
}

static NSLayoutConstraint * _Nonnull make(UIView * _Nonnull item,
                                          ALKAttribute itemAttribute,
                                          ALKRelation relation,
                                          id _Nullable relatedItem,
                                          ALKAttribute relatedItemAttribute,
                                          CGFloat multiplier,
                                          CGFloat constant,
                                          UIView * _Nonnull targetItem,
                                          NSString * _Nullable name,
                                          UILayoutPriority priority) {
    return createLayoutConstraint(item, itemAttribute, relation, relatedItem, relatedItemAttribute, multiplier, constant, targetItem, name, priority);
}

static NSLayoutConstraint * _Nonnull createLayoutConstraint(UIView * _Nonnull item,
                                                            ALKAttribute itemAttribute,
                                                            ALKRelation relation,
                                                            id _Nullable relatedItem,
                                                            ALKAttribute relatedItemAttribute,
                                                            CGFloat multiplier,
                                                            CGFloat constant,
                                                            UIView * _Nonnull targetItem,
                                                            NSString * _Nullable name,
                                                            UILayoutPriority priority) {
    
    NSLayoutConstraint *lc = [NSLayoutConstraint constraintWithItem:item
                                                          attribute:(NSLayoutAttribute)itemAttribute
                                                          relatedBy:(NSLayoutRelation)relation
                                                             toItem:relatedItem
                                                          attribute:(NSLayoutAttribute)relatedItemAttribute
                                                         multiplier:multiplier
                                                           constant:constant];
    
    lc.priority = priority;
    
    if (name) {
        [targetItem alk_addConstraint:lc withName:name];
    } else {
        lc.active = YES;
    }
    
    return lc;
}

@end
