//  ALKConstraints+Convenience.h
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

#import "ALKConstraints.h"

@interface ALKConstraints (Convenience)

////////////////////////////////////////////////////////////////////////////////
/// @name Aligning Views to Other Views
////////////////////////////////////////////////////////////////////////////////

/**
 @brief Aligns all edges to a given view.
 
 This method is a shorthand to make all four edges of a view equal to the edges
 of a given (super-)view.
 
 Without this method you would need to write:
 
    [ALKConstraints layout:self.someView do:^(ALKConstraints *c) {
      [c make:ALKLeft   equalTo:self.someOtherView s:ALKLeft];
      [c make:ALKTop    equalTo:self.someOtherView s:ALKTop];
      [c make:ALKRight  equalTo:self.someOtherView s:ALKRight];
      [c make:ALKBottom equalTo:self.someOtherView s:ALKBottom];
    }];
 
 With this method the same code becomes:
 
    [ALKConstraints layout:self.someView do:^(ALKConstraints *c) {
      [c alignAllEdgesTo:self.someOtherView];
    }];
 
 @param relatedView An instance of a `UIView` (subclass) that needs to be 
 within the same view hierachy of the item that you're aligning to it.
 
 @see -alignAllEdgesTo:edgeInsets:
 
 @since 0.6.0
 */
- (void)alignAllEdgesTo:(UIView *)relatedView;

@end
