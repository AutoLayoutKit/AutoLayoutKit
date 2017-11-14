//  PriorityTests.m
//  AutoLayoutKitTests
//
//  Copyright (c) 2013 Florian Krueger <florian.krueger@projectserver.org>
//  Created on 1/28/14.
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

@interface PriorityTests : XCTestCase

@property (nonatomic, strong) UIView *view;

@end

@implementation PriorityTests

- (void)setUp
{
    [super setUp];
    self.view = [[UIView alloc] init];
}

- (void)tearDown
{
    self.view = nil;
    [super tearDown];
}

- (void)testDefaultPriority
{
    [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
        [c set:ALKWidth to:100.f name:@"default"];
    }];
    
    NSLayoutConstraint *c = [self.view alk_constraintWithName:@"default"];
    
    XCTAssertEqualWithAccuracy(c.priority,
                               UILayoutPriorityRequired,
                               .0001f,
                               @"");
}

- (void)testSetPriorityExplicit
{
    [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
        [c setPriority:123];
        [c set:ALKHeight to:100.f name:@"constraint"];
    }];
    
    NSLayoutConstraint *c = [self.view alk_constraintWithName:@"constraint"];
    
    XCTAssertEqualWithAccuracy(c.priority,
                               123,
                               .0001f,
                               @"");
}

- (void)testResetPriority
{
    [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
        [c setPriority:123];
        [c set:ALKHeight to:100.f];
        
        [c setPriorityRequired];
        [c set:ALKWidth to:100.f name:@"constraint"];
    }];
    
    NSLayoutConstraint *c = [self.view alk_constraintWithName:@"constraint"];
    
    XCTAssertEqualWithAccuracy(c.priority,
                               UILayoutPriorityRequired,
                               .0001f,
                               @"");
}

- (void)testSetPriorityRequired
{
    [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
        [c setPriorityRequired];
        [c set:ALKHeight to:100.f name:@"constraint"];
    }];
    
    NSLayoutConstraint *c = [self.view alk_constraintWithName:@"constraint"];
    
    XCTAssertEqualWithAccuracy(c.priority,
                               UILayoutPriorityRequired,
                               .0001f,
                               @"");
}

- (void)testSetPriorityDefaultHigh
{
    [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
        [c setPriorityDefaultHigh];
        [c set:ALKHeight to:100.f name:@"constraint"];
    }];
    
    NSLayoutConstraint *c = [self.view alk_constraintWithName:@"constraint"];
    
    XCTAssertEqualWithAccuracy(c.priority,
                               UILayoutPriorityDefaultHigh,
                               .0001f,
                               @"");
}

- (void)testSetPriorityDefaultLow
{
    [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
        [c setPriorityDefaultLow];
        [c set:ALKHeight to:100.f name:@"constraint"];
    }];
    
    NSLayoutConstraint *c = [self.view alk_constraintWithName:@"constraint"];
    
    XCTAssertEqualWithAccuracy(c.priority,
                               UILayoutPriorityDefaultLow,
                               .0001f,
                               @"");
}

- (void)testSetPriorityFittingSizeLevel
{
    [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
        [c setPriorityFittingSizeLevel];
        [c set:ALKHeight to:100.f name:@"constraint"];
    }];
    
    NSLayoutConstraint *c = [self.view alk_constraintWithName:@"constraint"];
    
    XCTAssertEqualWithAccuracy(c.priority,
                               UILayoutPriorityFittingSizeLevel,
                               .0001f,
                               @"");
}

- (void)testDefaultPriorityUsingBlockConstraint
{
  __block NSLayoutConstraint * constraint = nil;
  [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
    constraint = [c set:ALKWidth to:100.f];
  }];
  
  XCTAssertNotNil(constraint);
  XCTAssertEqualWithAccuracy(constraint.priority,
                             UILayoutPriorityRequired,
                             .0001f,
                             @"");
}

- (void)testSetPriorityExplicitUsingBlockConstraint
{
  __block NSLayoutConstraint * constraint = nil;
  [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
    [c setPriority:123];
    constraint = [c set:ALKHeight to:100.f];
  }];
  
  XCTAssertNotNil(constraint);
  XCTAssertEqualWithAccuracy(constraint.priority,
                             123,
                             .0001f,
                             @"");
}

- (void)testResetPriorityUsingBlockConstraint
{
  __block NSLayoutConstraint * constraint = nil;
  [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
    [c setPriority:123];
    [c set:ALKHeight to:100.f];
    
    [c setPriorityRequired];
    constraint = [c set:ALKWidth to:100.f];
  }];
  
  XCTAssertNotNil(constraint);
  XCTAssertEqualWithAccuracy(constraint.priority,
                             UILayoutPriorityRequired,
                             .0001f,
                             @"");
}

- (void)testSetPriorityRequiredUsingBlockConstraint
{
  __block NSLayoutConstraint * constraint = nil;
  [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
    [c setPriorityRequired];
    constraint = [c set:ALKHeight to:100.f];
  }];
  
  XCTAssertNotNil(constraint);
  XCTAssertEqualWithAccuracy(constraint.priority,
                             UILayoutPriorityRequired,
                             .0001f,
                             @"");
}

- (void)testSetPriorityDefaultHighUsingBlockConstraint
{
  __block NSLayoutConstraint * constraint = nil;
  [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
    [c setPriorityDefaultHigh];
    constraint = [c set:ALKHeight to:100.f];
  }];
  
  XCTAssertNotNil(constraint);
  XCTAssertEqualWithAccuracy(constraint.priority,
                             UILayoutPriorityDefaultHigh,
                             .0001f,
                             @"");
}

- (void)testSetPriorityDefaultLowUsingBlockConstraint
{
  __block NSLayoutConstraint * constraint = nil;
  [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
    [c setPriorityDefaultLow];
    constraint = [c set:ALKHeight to:100.f];
  }];
  
  XCTAssertNotNil(constraint);
  XCTAssertEqualWithAccuracy(constraint.priority,
                             UILayoutPriorityDefaultLow,
                             .0001f,
                             @"");
}

- (void)testSetPriorityFittingSizeLevelUsingBlockConstraint
{
  __block NSLayoutConstraint * constraint = nil;
  [ALKConstraints layout:self.view do:^(ALKConstraints *c) {
    [c setPriorityFittingSizeLevel];
    constraint = [c set:ALKHeight to:100.f];
  }];
  
  XCTAssertNotNil(constraint);
  XCTAssertEqualWithAccuracy(constraint.priority,
                             UILayoutPriorityFittingSizeLevel,
                             .0001f,
                             @"");
}


@end
