//
//  ALKTestCase.h
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 13/04/14.
//  Copyright (c) 2014 projectserver.org. All rights reserved.
//

#import <XCTest/XCTest.h>

FOUNDATION_EXTERN NSUInteger const tag;

@interface ALKTestCase : XCTestCase

/// View Factory

- (UIView *)newEmptyView;

- (UIView *)newTwoTierViewHierarchy;

/// Check Helper

- (void)checkConstraint:(NSLayoutConstraint *)constraint
               withItem:(id)item
              attribute:(NSLayoutAttribute)attribute
              relatedBy:(NSLayoutRelation)relation
                 toItem:(id)relItem
              attribute:(NSLayoutAttribute)relAttribute
             multiplier:(CGFloat)multiplier
               constant:(CGFloat)constant;

- (void)checkMinusConstraint:(NSLayoutConstraint *)constraint
                    withItem:(id)item
                   attribute:(NSLayoutAttribute)attribute
                   relatedBy:(NSLayoutRelation)relation
                      toItem:(id)relItem
                   attribute:(NSLayoutAttribute)relAttribute
                  multiplier:(CGFloat)multiplier
                    constant:(CGFloat)constant;

/// Constraint Finder

- (NSLayoutConstraint *)firstConstraint:(UIView *)view;

- (NSLayoutConstraint *)constraintOn:(UIView *)view
                  withFirstAttribute:(NSLayoutAttribute)attribute;

@end