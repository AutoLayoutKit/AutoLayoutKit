//
//  LKConstraints.m
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 07/03/13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import "LKConstraints.h"
#import "UIView+LKNamedConstraints.h"

@interface LKConstraints ()

@property (nonatomic, strong) UIView *item;

@end

@implementation LKConstraints

+ (LKConstraints *)layout:(UIView *)view do:(LKLayoutBlock)layoutBlock;
{
    LKConstraints *c = [[LKConstraints alloc] initWithView:view];
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

- (void)set:(LK_attribute)attribute to:(CGFloat)constant
{
    set(self.item, attribute, constant, nil);
}

- (void)set:(LK_attribute)attribute to:(CGFloat)constant name:(NSString *)name
{
    set(self.item, attribute, constant, name);
}

#pragma mark - DSL (MAKE)

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView
{
    make(self.item, attribute, LK_equal_to, relatedItem, relatedAttribute, multiplier, constant, targetView, nil);
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name
{
    make(self.item, attribute, LK_equal_to, relatedItem, relatedAttribute, multiplier, constant, targetView, name);
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:targetView];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant on:(UIView *)targetView name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:targetView
          name:name];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:targetView];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier on:(UIView *)targetView name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:targetView
          name:name];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute on:(UIView *)targetView
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:0.f
            on:targetView];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute on:(UIView *)targetView name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:0.f
            on:targetView
          name:name];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:constant
            on:self.item.superview];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier plus:(CGFloat)constant name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:constant
            on:self.item.superview
          name:name];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:self.item.superview];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute plus:(CGFloat)constant name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:constant
            on:self.item.superview
          name:name];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:self.item.superview];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute times:(CGFloat)multiplier name:(NSString *)name
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:multiplier
          plus:0.f
            on:self.item.superview
          name:name];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute
{
    [self make:attribute
       equalTo:relatedItem
             s:relatedAttribute
         times:1.f
          plus:0.f
            on:self.item.superview];
}

- (void)make:(LK_attribute)attribute equalTo:(id)relatedItem s:(LK_attribute)relatedAttribute name:(NSString *)name
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
          LK_attribute itemAttribute,
          CGFloat constant,
          NSString *name)
{
    createLayoutConstraint(item, itemAttribute, LK_equal_to, nil, LK_na, 1.f, constant, item, name);
}

void make(UIView *item,
          LK_attribute itemAttribute,
          LK_relation relation,
          id relatedItem,
          LK_attribute relatedItemAttribute,
          CGFloat multiplier,
          CGFloat constant,
          UIView *targetItem,
          NSString *name)
{
    createLayoutConstraint(item, itemAttribute, relation, relatedItem, relatedItemAttribute, multiplier, constant, targetItem, name);
}

NSLayoutConstraint * createLayoutConstraint(UIView *item,
                                            LK_attribute itemAttribute,
                                            LK_relation relation,
                                            id relatedItem,
                                            LK_attribute relatedItemAttribute,
                                            CGFloat multiplier,
                                            CGFloat constant,
                                            UIView *targetItem,
                                            NSString *name)
{
    NSLayoutAttribute itemAttributeValue = [LKConstraints enumToAttribute:itemAttribute];
    NSLayoutRelation relationValue = [LKConstraints enumToRelation:relation];
    NSLayoutAttribute relatedItemAttributeValue = [LKConstraints enumToAttribute:relatedItemAttribute];
    
    NSLayoutConstraint *lc = [NSLayoutConstraint constraintWithItem:item
                                                          attribute:itemAttributeValue
                                                          relatedBy:relationValue
                                                             toItem:relatedItem
                                                          attribute:relatedItemAttributeValue
                                                         multiplier:multiplier
                                                           constant:constant];
    
    if (nil != name) {
        [targetItem addConstraint:lc withName:name];
    } else {
        [targetItem addConstraint:lc];
    }
    
    return lc;
}

#pragma mark - ENUM Conversion

+ (NSLayoutAttribute)enumToAttribute:(LK_attribute)attribute
{
    switch (attribute) {
        case LK_left:
            return NSLayoutAttributeLeft;
        case LK_right:
            return NSLayoutAttributeRight;
        case LK_top:
            return NSLayoutAttributeTop;
        case LK_bottom:
            return NSLayoutAttributeBottom;
        case LK_leading:
            return NSLayoutAttributeLeading;
        case LK_trailing:
            return NSLayoutAttributeTrailing;
        case LK_width:
            return NSLayoutAttributeWidth;
        case LK_height:
            return NSLayoutAttributeHeight;
        case LK_center_x:
            return NSLayoutAttributeCenterX;
        case LK_center_y:
            return NSLayoutAttributeCenterY;
        case LK_baseline:
            return NSLayoutAttributeBaseline;
        case LK_na:
            return NSLayoutAttributeNotAnAttribute;
    }
}

+ (NSLayoutRelation)enumToRelation:(LK_relation)relation
{
    switch (relation) {
        case LK_less_than:
            return NSLayoutRelationLessThanOrEqual;
        case LK_equal_to:
            return NSLayoutRelationEqual;
        case LK_greater_than:
            return NSLayoutRelationGreaterThanOrEqual;
    }
}

@end
