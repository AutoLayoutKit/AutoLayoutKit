//
//  UIView+LKNamedConstraints.m
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 07/03/13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+LKNamedConstraints.h"

NSString * const kLKNamedConstraints = @"kLKNamedConstraints";

@implementation UIView (LKNamedConstraints)

#pragma mark - Public API

- (NSLayoutConstraint *)addConstraint:(NSLayoutConstraint *)constraint withName:(NSString *)name
{
    if ((nil == constraint) || (nil == name)) return FALSE;
    
    NSMutableDictionary *namedConstraints = [self LK_namedConstraints];
    
    // try to load existing constraint as we don't want to simply overwrite old constraints
    NSLayoutConstraint *oldConstraint = namedConstraints[name];
    
    if (nil == oldConstraint) {
        namedConstraints[name] = constraint;
        [self addConstraint:constraint];
        return constraint;
    } else {
        NSLog(@"Layout Constraint with name \"%@\" already exists", name);
        return nil;
    }
}

- (NSLayoutConstraint *)constraintWithName:(NSString *)name
{
    if (nil == name) return nil;
    
    id obj = self.LK_namedConstraints[name];
    
    if ([obj isKindOfClass:[NSLayoutConstraint class]]) {
        return (NSLayoutConstraint *)obj;
    }
    
    return nil;
}

- (void)removeConstraintsWithNames:(NSArray *)names
{
    for (id obj in names) {
        if ([obj isKindOfClass:[NSString class]]) {
            [self removeConstraintWithName:(NSString *)obj];
        }
    }
}

- (void)removeConstraintWithName:(NSString *)name
{
    if (nil == name) return;
    
    NSLayoutConstraint *constraint = [self constraintWithName:name];
    
    if (nil != constraint) {
        [self removeConstraint:constraint];
        [self.LK_namedConstraints removeObjectForKey:name];
    }
}

#pragma mark - Getter & Setter LK_namedConstraints

- (void)setLK_namedConstraints:(NSMutableDictionary *)namedConstraintsDict
{
	objc_setAssociatedObject(self, (__bridge const void *)(kLKNamedConstraints), namedConstraintsDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)LK_namedConstraints
{
    NSMutableDictionary *namedConstraints = objc_getAssociatedObject(self, (__bridge const void *)(kLKNamedConstraints));
    
    // there is no namedConstraints dictionary yet -> create one
    if (nil == namedConstraints) {
        namedConstraints = [NSMutableDictionary dictionary];
        [self setLK_namedConstraints:namedConstraints];
    }
    
    // the retrieved object is not the expected NSMutableDictionary -> overwrite it with a new one
    else if (![namedConstraints isKindOfClass:[NSMutableDictionary class]]) {
        namedConstraints = [NSMutableDictionary dictionary];
        [self setLK_namedConstraints:namedConstraints];
    }
    
	return namedConstraints;
}

@end
