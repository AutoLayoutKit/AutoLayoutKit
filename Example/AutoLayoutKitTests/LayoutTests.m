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

#import "ALKTestCase.h"
#import "AutoLayoutKit.h"

NSString * const kALKTestLayoutConstraint = @"ALKTestConstraint";

@interface LayoutTests : ALKTestCase

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

#pragma mark - Layout Tests (MAKE/EQL/MINUS)

- (void)testMakeEqMinusMultiConst
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier minus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeEqlMinusMultiConstTV
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier minus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeEqlMinusMultiConstTVName
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier minus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeEqlMinusConstTV
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute minus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeEqlMinusConstTVName
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute minus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeEqlMinusMultiConstName
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute times:multiplier minus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeEqlMinusConst
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute minus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeEqlMinusConstName
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
      [c make:alkAttribute equalTo:parentView s:alkAttribute minus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

#pragma mark - Layout Tests (MAKE/LT)

- (void)testMakeLTMultiConst
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier plus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeLTMultiConstTV
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier plus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeLTMultiConstTVName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier plus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeLTConstTV
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute plus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeLTConstTVName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute plus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeLTMultiTV
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeLTMultiTVName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeLTTV
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute lessThan:parentView s:alkAttribute on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

- (void)testMakeLTTVName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute lessThan:parentView s:alkAttribute on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

- (void)testMakeLTMultiConstName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier plus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeLTConst
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute plus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeLTConstName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute plus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeLTMulti
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeLTMultiName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeLT
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute lessThan:parentView s:alkAttribute];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

- (void)testMakeLTName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute lessThan:parentView s:alkAttribute name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

#pragma mark - Layout Tests (MAKE/LT/MINUS)

- (void)testMakeLTMinusMultiConst
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier minus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeLTMinusMultiConstTV
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier minus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeLTMinusMultiConstTVName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier minus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeLTMinusConstTV
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute minus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeLTMinusConstTVName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute minus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeLTMinusMultiConstName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute times:multiplier minus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeLTMinusConst
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute minus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeLTMinusConstName
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
      [c make:alkAttribute lessThan:parentView s:alkAttribute minus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationLessThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

#pragma mark - Layout Tests (MAKE/GT)

- (void)testMakeGTMultiConst
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier plus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeGTMultiConstTV
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier plus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeGTMultiConstTVName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier plus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeGTConstTV
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute plus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeGTConstTVName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute plus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeGTMultiTV
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeGTMultiTVName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeGTTV
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute greaterThan:parentView s:alkAttribute on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

- (void)testMakeGTTVName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute greaterThan:parentView s:alkAttribute on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

- (void)testMakeGTMultiConstName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier plus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:constant];
  }
}

- (void)testMakeGTConst
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute plus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeGTConstName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute plus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:constant];
  }
}

- (void)testMakeGTMulti
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeGTMultiName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:multiplier
                 constant:0.f];
  }
}

- (void)testMakeGT
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute greaterThan:parentView s:alkAttribute];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[self firstConstraint:parentView]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

- (void)testMakeGTName
{
  NSArray *testFields = [self makeTestFields];
  
  for (NSArray *testField in testFields) {
    UIView *parentView = [self newTwoTierViewHierarchy];
    UIView *childView = [parentView viewWithTag:tag];
    
    ALKAttribute alkAttribute         = (ALKAttribute)[testField[0] integerValue];
    NSLayoutAttribute uikitAttribute  = (NSLayoutAttribute)[testField[1] integerValue];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [ALKConstraints layout:childView do:^(ALKConstraints *c) {
      [c make:alkAttribute greaterThan:parentView s:alkAttribute name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkConstraint:[parentView alk_constraintWithName:@"name"]
                 withItem:childView
                attribute:uikitAttribute
                relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:parentView
                attribute:uikitAttribute
               multiplier:1.f
                 constant:0.f];
  }
}

#pragma mark - Layout Tests (MAKE/GT/MINUS)

- (void)testMakeGTMinusMultiConst
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier minus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeGTMinusMultiConstTV
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier minus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeGTMinusMultiConstTVName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier minus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeGTMinusConstTV
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute minus:constant on:parentView];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeGTMinusConstTVName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute minus:constant on:parentView name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeGTMinusMultiConstName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute times:multiplier minus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:multiplier
                      constant:constant];
  }
}

- (void)testMakeGTMinusConst
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute minus:constant];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[self firstConstraint:parentView]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

- (void)testMakeGTMinusConstName
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
      [c make:alkAttribute greaterThan:parentView s:alkAttribute minus:constant name:@"name"];
      dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self checkMinusConstraint:[parentView alk_constraintWithName:@"name"]
                      withItem:childView
                     attribute:uikitAttribute
                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                        toItem:parentView
                     attribute:uikitAttribute
                    multiplier:1.f
                      constant:constant];
  }
}

@end
