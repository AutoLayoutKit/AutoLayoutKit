//
//  AutoLayoutKitTests.m
//  AutoLayoutKitTests
//
//  Created by Florian Krüger on 12/01/14.
//  Copyright (c) 2014 projectserver.org. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoLayoutKit.h"

@interface AutoLayoutKitTests : XCTestCase

@end

@implementation AutoLayoutKitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStopsTranslatingAutoresizingMasks
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  
  XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints, @"Translation is already off before applying ALK");
  
  [ALKConstraints layout:view do:^(ALKConstraints *c) {}];
  
  XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, @"Translation isn't off after applying ALK");
}

@end
