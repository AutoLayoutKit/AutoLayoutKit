//  LKPTextFieldView.m
//  AutoLayoutKitPrototype
//
//  Copyright (c) 2013 Florian Krueger <florian.krueger@projectserver.org>
//  Created on 12/26/13.
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

#import "LKPTextFieldView.h"

#import "AutoLayoutKit.h"
#import <QuartzCore/QuartzCore.h>

NSString * const kLKPTextFieldViewKeyboardHeight   = @"keyboardHeight";

@interface LKPTextFieldView ()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@end

@implementation LKPTextFieldView

#pragma mark - Memory Management

- (void)dealloc
{
    
}

#pragma mark - Setup & Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self setupSubviews];
    [self setupLayout];
}

#pragma mark - Setup & Init (Private)

- (void)setupSubviews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.scrollView.layer setBorderColor:[UIColor redColor].CGColor];
    [self.scrollView.layer setBorderWidth:1.f];
    [self addSubview:self.scrollView];
}

- (void)setupLayout
{
    [ALKConstraints layout:self.scrollView do:^(ALKConstraints *c) {
        [c make:ALKTop      equalTo:self s:ALKTop];
        [c make:ALKLeft     equalTo:self s:ALKLeft];
        [c make:ALKRight    equalTo:self s:ALKRight];
        [c make:ALKBottom   equalTo:self s:ALKBottom
           name:kLKPTextFieldViewKeyboardHeight];
    }];
}

@end
