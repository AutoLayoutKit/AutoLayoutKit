//  LayoutTests.m
//  AutoLayoutKitTests
//
//  Copyright (c) 2013 Florian Krueger <florian.krueger@projectserver.org>
//  Created on 1/14/14.
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

#import <XCTest/XCTest.h>
#import "AutoLayoutKit.h"

NSString * const kALKTestLayoutConstraint = @"ALKTestConstraint";
NSUInteger const tag = 1234;

@interface LayoutTests : XCTestCase

@property (nonatomic, strong, readwrite) UIView *view;

@end

@implementation LayoutTests

- (void)setUp
{
  [super setUp];
  self.view = [self newEmptyView];
}

- (void)tearDown
{
  self.view = nil;
  [super tearDown];
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

#pragma mark - Testfields

- (NSArray *)setTestFields
{
  return @[
           @[@(ALKWidth),     @(NSLayoutAttributeWidth),          @( 1.f), @(3.f)],
           @[@(ALKHeight),    @(NSLayoutAttributeHeight),         @( 2.f), @(6.f)]
           ];
}

- (NSArray *)makeTestFields
{
  return @[
           @[@(ALKLeft),      @(NSLayoutAttributeLeft),           @( 1.f), @( 3.f)],
           @[@(ALKRight),     @(NSLayoutAttributeRight),          @( 2.f), @( 6.f)],
           @[@(ALKTop),       @(NSLayoutAttributeTop),            @( 3.f), @( 9.f)],
           @[@(ALKBottom),    @(NSLayoutAttributeBottom),         @( 4.f), @(12.f)],
           @[@(ALKLeading),   @(NSLayoutAttributeLeading),        @( 5.f), @(15.f)],
           @[@(ALKTrailing),  @(NSLayoutAttributeTrailing),       @( 6.f), @(18.f)],
           @[@(ALKWidth),     @(NSLayoutAttributeWidth),          @( 7.f), @(21.f)],
           @[@(ALKHeight),    @(NSLayoutAttributeHeight),         @( 8.f), @(24.f)],
           @[@(ALKCenterX),   @(NSLayoutAttributeCenterX),        @( 9.f), @(27.f)],
           @[@(ALKCenterY),   @(NSLayoutAttributeCenterY),        @(10.f), @(30.f)],
           @[@(ALKBaseline),  @(NSLayoutAttributeBaseline),       @(11.f), @(33.f)]
           ];
}

#pragma mark - Layout Tests (SET)

- (void)testSet
{
  NSArray *testFields = [self setTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *view = [self newEmptyView];
    
    ALKAttribute alk_a      = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute alk_b = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat alk_c           = (CGFloat)[testField[2] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:view do:^(ALKConstraints *c) {
      [c set:alk_a to:alk_c];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:view]
                 withItem:view
                attribute:alk_b
                relatedBy:NSLayoutRelationEqual
                   toItem:nil
                attribute:NSLayoutAttributeNotAnAttribute
               multiplier:1.f
                 constant:alk_c];
    
  }
}

- (void)testSetNamed
{
  NSArray *testFields = [self setTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *view = [self newEmptyView];

    ALKAttribute alk_a      = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute alk_b = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat alk_c           = (CGFloat)[testField[2] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:view do:^(ALKConstraints *c) {
      [c set:alk_a to:alk_c name:kALKTestLayoutConstraint];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[view alk_constraintWithName:kALKTestLayoutConstraint]
                 withItem:view
                attribute:alk_b
                relatedBy:NSLayoutRelationEqual
                   toItem:nil
                attribute:NSLayoutAttributeNotAnAttribute
               multiplier:1.f
                 constant:alk_c];

  }
}

#pragma mark - Layout Tests (MAKE/EQL)

- (void)testMakeEqlMultiConst
{
  NSArray *testFields = [self makeTestFields];

  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier plus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeEqlMultiConstTV
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier plus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeEqlMultiConstTVName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier plus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeEqlConstTV
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute plus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeEqlConstTVName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute plus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}
  
- (void)testMakeEqlMultiTV
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}
  
- (void)testMakeEqlMultiTVName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}
 
- (void)testMakeEqlTV
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}
 
- (void)testMakeEqlTVName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

- (void)testMakeEqlMultiConstName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier plus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeEqlConst
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute plus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeEqlConstName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat constant                  = (CGFloat)[testField[2] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute plus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}
 
- (void)testMakeEqlMulti
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}
 
- (void)testMakeEqlMultiName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    CGFloat multiplier                = (CGFloat)[testField[3] floatValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}
 
- (void)testMakeEql
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}
 
- (void)testMakeEqlName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute equalTo:parentView s:alkAttribute name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

/*
// MAKE (LT)
 
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant
on:(UIView *)targetView;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant
on:(UIView *)targetView
name:(NSString *)name;
 
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant
on:(UIView *)targetView;
 
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant
on:(UIView *)targetView
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
on:(UIView *)targetView;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
on:(UIView *)targetView
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
on:(UIView *)targetView;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
on:(UIView *)targetView
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute;
  
  - (void)make:(ALKAttribute)attribute
lessThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
name:(NSString *)name;
  
// MAKE (GT)
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant
on:(UIView *)targetView;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant
on:(UIView *)targetView
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant
on:(UIView *)targetView;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant
on:(UIView *)targetView
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
on:(UIView *)targetView;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
on:(UIView *)targetView
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
on:(UIView *)targetView;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
on:(UIView *)targetView
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
plus:(CGFloat)constant
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
plus:(CGFloat)constant
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
times:(CGFloat)multiplier
name:(NSString *)name;
  
  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute;

  - (void)make:(ALKAttribute)attribute
greaterThan:(id)relatedItem
s:(ALKAttribute)relatedAttribute
name:(NSString *)name;

 */
 
@end