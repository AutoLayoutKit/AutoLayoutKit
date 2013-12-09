//  UIView+ALKNamedConstraints.h
//  AutoLayoutKit
//
//  Copyright (c) 2013 Florian Krueger <florian.krueger@projectserver.org>
//  Created on 07/03/13.
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

#import <UIKit/UIKit.h>

/**
 The `ALKNamedConstraints` category adds a constraint store to every `UIView`
 subclass. This store can be used to remember constraints by a given name. It is
 possible to add, retrieve and remove constraints by a name that must be given
 when added.
 
 @since 0.1.0
 */
@interface UIView (ALKNamedConstraints)

/** 
 stores all the named constraints. 
 
 @since 0.1.0
 */
@property (nonatomic, retain, setter = alk_setNamedConstraints:) NSMutableDictionary* alk_namedConstraints;

/** 
 Tries to add a constraint to the `UIView` while remembering the 
 `constraint_name` for future reference.
 
 @param constraint The `NSLayoutConstraint` to be referred to with `name`.
 @param name The identifier that the constraint should be identified with.
 
 @return The added constraint or `nil` if the name is already used.
 
 @since 0.1.0
 */
- (NSLayoutConstraint *)alk_addConstraint:(NSLayoutConstraint *)constraint
                                 withName:(NSString *)name;

/** 
 Looks in the named constraints for a constraint named `name` and returns it
 when found, `nil` otherwise.
 
 @param name The identifier that was used during creation of the constraint.
 
 @return The constrainted with the identifier `name` or `nil` if the name is 
 not used for a constraint.
 
 @since 0.1.0
 */
- (NSLayoutConstraint *)alk_constraintWithName:(NSString *)name;

/** 
 Takes an array of names and tries to remove all `NSLayoutConstraint` instances 
 from the receiver which are referenced by the given names. If a name does not 
 refer to a `NSLayoutConstraint`, it is simply ignored.
 
 @param names The names of `NSLayoutConstraint` instances that have been added 
 to the receiver before, using {#addConstraint}:`withName:`.

 @see -alk_removeConstraintWithName:
 
 @since 0.1.0
 */
- (void)alk_removeConstraintsWithNames:(NSArray *)names;

/** 
 Takes as single name and tries to remove the `NSLayoutConstraint` instance from 
 the receiver which is referenced by the given name. If the name does not refer 
 to a `NSLayoutConstraint`, it is simply ignored.

 @param name The name of `NSLayoutConstraint` instances that have been added to 
 the receiver before, using `addConstraint:withName:`.

 @see -alk_removeConstraintsWithNames:
 
 @since 0.1.0
 */
- (void)alk_removeConstraintWithName:(NSString *)name;

@end
