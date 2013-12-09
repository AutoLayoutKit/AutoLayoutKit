//  UIView+ALKNamedConstraints.m
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
