//  ALKConstraints+Convenience.m
//  AutoLayoutKit
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

#import "ALKConstraints+Convenience.h"

@implementation ALKConstraints (Convenience)

- (void)alignAllEdgesTo:(UIView *)relatedView
{
  [self make:ALKLeft    equalTo:relatedView s:ALKLeft];
  [self make:ALKTop     equalTo:relatedView s:ALKTop];
  [self make:ALKRight   equalTo:relatedView s:ALKRight];
  [self make:ALKBottom  equalTo:relatedView s:ALKBottom];
}

- (void)alignAllEdgesTo:(UIView *)relatedView edgeInsets:(UIEdgeInsets)insets
{
  [self make:ALKLeft    equalTo:relatedView s:ALKLeft     plus:insets.left];
  [self make:ALKTop     equalTo:relatedView s:ALKTop      plus:insets.top];
  [self make:ALKRight   equalTo:relatedView s:ALKRight    minus:insets.right];
  [self make:ALKBottom  equalTo:relatedView s:ALKBottom   minus:insets.bottom];
}

- (void)centerIn:(UIView *)relatedView
{
  [self make:ALKCenterX  equalTo:relatedView s:ALKCenterX];
  [self make:ALKCenterY  equalTo:relatedView s:ALKCenterY];
}

- (void)setSize:(CGSize)size
{
  [self set:ALKHeight to:size.height];
  [self set:ALKWidth  to:size.width];
}

@end
