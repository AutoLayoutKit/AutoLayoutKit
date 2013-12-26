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

#import "LKPTextViewContainer.h"

NSString * const kLKPTextFieldViewKeyboardHeight   = @"keyboardHeight";

@interface LKPTextFieldView ()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@property (nonatomic, strong, readwrite) LKPTextViewContainer *textViewContainer;

@property (nonatomic, assign, readwrite) BOOL registered;

@end

@implementation LKPTextFieldView

#pragma mark - Memory Management

- (void)dealloc
{
    [self tearDownNotifications];
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
    [self setRegistered:FALSE];
    [self setupNotifications];
    
    [self setupSubviews];
    [self setupLayout];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *ui = notification.userInfo;
    NSValue *frameValue = ui[UIKeyboardFrameEndUserInfoKey];
    NSNumber *durationNumber = ui[UIKeyboardAnimationDurationUserInfoKey];
    
    CGRect frame = [frameValue CGRectValue];
    NSTimeInterval duration = [durationNumber doubleValue];
    
    [self setKeyboardHeight:frame.size.height
                   animated:TRUE
          animationDuration:duration];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *ui = notification.userInfo;
    NSNumber *durationNumber = ui[UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval duration = [durationNumber doubleValue];
    
    [self setKeyboardHeight:0.f
                   animated:TRUE
          animationDuration:duration];
}

- (void)setKeyboardHeight:(CGFloat)height
                 animated:(BOOL)animated
        animationDuration:(NSTimeInterval)animationDuration
{
    NSLayoutConstraint *c = [self alk_constraintWithName:kLKPTextFieldViewKeyboardHeight];
    c.constant = (-1) * height;
    [self setNeedsUpdateConstraints];
    
    if (animated) {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             [self layoutIfNeeded];
                         }];
    } else {
        [self layoutIfNeeded];
    }
}

#pragma mark - Setup & Init (Private)

- (void)setupSubviews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.scrollView.layer setBorderColor:[UIColor redColor].CGColor];
    [self.scrollView.layer setBorderWidth:1.f];
    [self addSubview:self.scrollView];
    
    self.textViewContainer = [[LKPTextViewContainer alloc] initWithFrame:CGRectZero];
    [self.textViewContainer setBackgroundColor:[UIColor blueColor]];
    [self.scrollView addSubview:self.textViewContainer];
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

    [ALKConstraints layout:self.textViewContainer do:^(ALKConstraints *c) {
        [c make:ALKTop      equalTo:self.scrollView s:ALKTop];
        [c make:ALKWidth    equalTo:self.scrollView s:ALKWidth];
        [c make:ALKCenterX  equalTo:self.scrollView s:ALKCenterX];
        [c make:ALKBottom   equalTo:self.scrollView s:ALKBottom];
    }];
}

- (void)setupNotifications
{
    if (self.registered) { return; }
    
    self.registered = TRUE;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
}

- (void)tearDownNotifications
{
    if (!self.registered) { return; }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc removeObserver:self
                  name:UIKeyboardWillShowNotification
                object:nil];
    
    [nc removeObserver:self
                  name:UIKeyboardWillHideNotification
                object:nil];
    
    self.registered = FALSE;
}

@end
