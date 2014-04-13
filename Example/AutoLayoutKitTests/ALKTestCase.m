//
//  ALKTestCase.m
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 13/04/14.
//  Copyright (c) 2014 projectserver.org. All rights reserved.
//

#import "ALKTestCase.h"

NSUInteger const tag = 1234;

@implementation ALKTestCase

#pragma mark - View Factory

- (UIView *)newEmptyView
{
  return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)newTwoTierViewHierarchy
{
  UIView *parentView = [[UIView alloc] initWithFrame:CGRectZero];
  UIView *childView = [[UIView alloc] initWithFrame:CGRectZero];
  [childView setTag:tag];
  [parentView addSubview:childView];
  return parentView;
}

#pragma mark - Check Helper

- (void)checkConstraint:(NSLayoutConstraint *)constraint
               withItem:(id)item
              attribute:(NSLayoutAttribute)attribute
              relatedBy:(NSLayoutRelation)relation
                 toItem:(id)relItem
              attribute:(NSLayoutAttribute)relAttribute
             multiplier:(CGFloat)multiplier
               constant:(CGFloat)constant
{
  XCTAssertNotNil(constraint, @"constraint must not be nil");
  
  XCTAssertEqual(constraint.firstItem,              item,                 @"");
  XCTAssertEqual(constraint.firstAttribute,         attribute,            @"");
  XCTAssertEqual(constraint.relation,               relation,             @"");
  XCTAssertEqual(constraint.secondItem,             relItem,              @"");
  XCTAssertEqual(constraint.secondAttribute,        relAttribute,         @"");
  XCTAssertEqualWithAccuracy(constraint.multiplier, multiplier, .0001f,   @"");
  XCTAssertEqualWithAccuracy(constraint.constant,   constant, .0001f,     @"");
}

- (void)checkMinusConstraint:(NSLayoutConstraint *)constraint
                    withItem:(id)item
                   attribute:(NSLayoutAttribute)attribute
                   relatedBy:(NSLayoutRelation)relation
                      toItem:(id)relItem
                   attribute:(NSLayoutAttribute)relAttribute
                  multiplier:(CGFloat)multiplier
                    constant:(CGFloat)constant
{
  XCTAssertNotNil(constraint, @"constraint must not be nil");
  
  XCTAssertEqual(constraint.firstItem,              item,                 @"");
  XCTAssertEqual(constraint.firstAttribute,         attribute,            @"");
  XCTAssertEqual(constraint.relation,               relation,             @"");
  XCTAssertEqual(constraint.secondItem,             relItem,              @"");
  XCTAssertEqual(constraint.secondAttribute,        relAttribute,         @"");
  XCTAssertEqualWithAccuracy(constraint.multiplier, multiplier, .0001f,   @"");
  XCTAssertEqualWithAccuracy(constraint.constant,   ((-1) * constant), .0001f,     @"");
}

#pragma mark - Constraint Finder

- (NSLayoutConstraint *)firstConstraint:(UIView *)view
{
  NSLayoutConstraint *c = nil;
  id item = nil;
  
  if ([view.constraints count] > 0) {
    item = view.constraints[0];
  }
  
  if ((item != nil) && ([item isKindOfClass:[NSLayoutConstraint class]])) {
    c = (NSLayoutConstraint *)item;
  }
  
  return c;
}

- (NSLayoutConstraint *)constraintOn:(UIView *)view
                  withFirstAttribute:(NSLayoutAttribute)attribute
{
  NSLayoutConstraint *constraint = nil;
  
  for (NSLayoutConstraint *aConstraint in [view constraints]) {
    if ([aConstraint firstAttribute] == attribute) {
      constraint = aConstraint;
      break;
    }
  }
  
  return constraint;
}

@end
