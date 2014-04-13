//  ConvenienceTests.m
//  AutoLayoutKitTests
//
//  Copyright (c) 2013 Florian Krueger <florian.krueger@projectserver.org>
//  Created on 13/04/14.
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

@interface ConvenienceTests : ALKTestCase

@end

@implementation ConvenienceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testAlignAllEdges
{
  UIView *parentView = [self newTwoTierViewHierarchy];
  UIView *childView = [parentView viewWithTag:tag];
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
  [ALKConstraints layout:childView do:^(ALKConstraints *c) {
    [c alignAllEdgesTo:parentView];
    dispatch_semaphore_signal(semaphore);
  }];
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  
  NSLayoutConstraint *constraint;
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeLeft];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeLeft
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeLeft
             multiplier:1.f
               constant:0.f];
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeTop];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeTop
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeTop
             multiplier:1.f
               constant:0.f];

  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeRight];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeRight
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeRight
             multiplier:1.f
               constant:0.f];

  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeBottom];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeBottom
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeBottom
             multiplier:1.f
               constant:0.f];
}

- (void)testAlignAllEdgesWithInsets
{
  UIView *parentView = [self newTwoTierViewHierarchy];
  UIView *childView = [parentView viewWithTag:tag];
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
  [ALKConstraints layout:childView do:^(ALKConstraints *c) {
    [c alignAllEdgesTo:parentView
            edgeInsets:UIEdgeInsetsMake(1.f, 2.f, 3.f, 4.f)];
    dispatch_semaphore_signal(semaphore);
  }];
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  
  NSLayoutConstraint *constraint;
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeLeft];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeLeft
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeLeft
             multiplier:1.f
               constant:2.f];
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeTop];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeTop
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeTop
             multiplier:1.f
               constant:1.f];
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeRight];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeRight
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeRight
             multiplier:1.f
               constant:-4.f];
  
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeBottom];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeBottom
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeBottom
             multiplier:1.f
               constant:-3.f];
}

- (void)testCenterIn
{
  UIView *parentView = [self newTwoTierViewHierarchy];
  UIView *childView = [parentView viewWithTag:tag];
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
  [ALKConstraints layout:childView do:^(ALKConstraints *c) {
    [c centerIn:parentView];
    dispatch_semaphore_signal(semaphore);
  }];
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  
  NSLayoutConstraint *constraint;
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeCenterX];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeCenterX
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeCenterX
             multiplier:1.f
               constant:0.f];
  
  constraint = [self constraintOn:parentView
               withFirstAttribute:NSLayoutAttributeCenterY];
  [self checkConstraint:constraint
               withItem:childView
              attribute:NSLayoutAttributeCenterY
              relatedBy:NSLayoutRelationEqual
                 toItem:parentView
              attribute:NSLayoutAttributeCenterY
             multiplier:1.f
               constant:0.f];
}

@end
