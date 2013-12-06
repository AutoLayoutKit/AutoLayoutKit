//
//  UIView+ALKNamedConstraints.m
//  AutoLayoutKit
//
//  Created by Florian Krüger on 07/03/13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+ALKNamedConstraints.h"

NSString * const kALKNamedConstraints = @"kALKNamedConstraints";

@implementation UIView (ALKNamedConstraints)

#pragma mark - Public API

- (NSLayoutConstraint *)alk_addConstraint:(NSLayoutConstraint *)constraint withName:(NSString *)name
{
    if ((nil == constraint) || (nil == name)) return FALSE;
    
    NSMutableDictionary *namedConstraints = [self alk_namedConstraints];
    
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

- (NSLayoutConstraint *)alk_constraintWithName:(NSString *)name
{
    if (nil == name) return nil;
    
    id obj = self.alk_namedConstraints[name];
    
    if ([obj isKindOfClass:[NSLayoutConstraint class]]) {
        return (NSLayoutConstraint *)obj;
    }
    
    return nil;
}

- (void)alk_removeConstraintsWithNames:(NSArray *)names
{
    for (id obj in names) {
        if ([obj isKindOfClass:[NSString class]]) {
            [self alk_removeConstraintWithName:(NSString *)obj];
        }
    }
}

- (void)alk_removeConstraintWithName:(NSString *)name
{
    if (nil == name) return;
    
    NSLayoutConstraint *constraint = [self alk_constraintWithName:name];
    
    if (nil != constraint) {
        [self removeConstraint:constraint];
        [self.alk_namedConstraints removeObjectForKey:name];
    }
}

#pragma mark - Getter & Setter LK_namedConstraints

- (void)alk_setNamedConstraints:(NSMutableDictionary *)namedConstraintsDict
{
	objc_setAssociatedObject(self, (__bridge const void *)(kALKNamedConstraints), namedConstraintsDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)alk_namedConstraints
{
    NSMutableDictionary *namedConstraints = objc_getAssociatedObject(self, (__bridge const void *)(kALKNamedConstraints));
    
    // there is no namedConstraints dictionary yet -> create one
    if (nil == namedConstraints) {
        namedConstraints = [NSMutableDictionary dictionary];
        [self alk_setNamedConstraints:namedConstraints];
    }
    
    // the retrieved object is not the expected NSMutableDictionary -> overwrite it with a new one
    else if (![namedConstraints isKindOfClass:[NSMutableDictionary class]]) {
        namedConstraints = [NSMutableDictionary dictionary];
        [self alk_setNamedConstraints:namedConstraints];
    }
    
	return namedConstraints;
}

@end
