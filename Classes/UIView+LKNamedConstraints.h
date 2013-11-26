//
//  UIView+LKNamedConstraints.h
//  LayoutKitPrototype
//
//  Created by Florian Krüger on 07/03/13.
//  Copyright (c) 2013 projectserver.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LKNamedConstraints)

@property (nonatomic, retain) NSMutableDictionary* LK_namedConstraints;

/** Tries to add a constraint to the `UIView` while remembering the `constraint_name` for future
 *  reference.
 *
 *  @param name The identifier that the constraint should be identified with.
 *
 *  @return The added constraint or `nil` if the name is already used.
 */
- (NSLayoutConstraint *)addConstraint:(NSLayoutConstraint *)constraint withName:(NSString *)name;

/** Looks in the named constraints for a constraint named `name` and returns it when found, `nil`
 *  otherwise.
 *  
 *  @param name The identifier that was used during creation of the constraint.
 *
 *  @return The constrainted with the identifier `name` or `nil` if the name is not used for a 
 *  constraint.
 */
- (NSLayoutConstraint *)constraintWithName:(NSString *)name;

/** Takes an array of names and tries to remove all `NSLayoutConstraint` instances from the receiver
 *  which are referenced by the given names. If a name does not refer to a `NSLayoutConstraint`, it
 *  is simply ignored.
 *
 *  @param names The names of `NSLayoutConstraint` instances that have been added to the receiver 
 *  before, using {#addConstraint}:`withName:`.
 *
 *  @see removeConstraintWithName:
 */
- (void)removeConstraintsWithNames:(NSArray *)names;

/** Takes as single name and tries to remove the `NSLayoutConstraint` instance from the receiver
 *  which is referenced by the given name. If the name does not refer to a `NSLayoutConstraint`, it
 *  is simply ignored.
 *
 *  @param name The name of `NSLayoutConstraint` instances that have been added to the receiver
 *  before, using `addConstraint:withName:`.
 *
 *  @see removeConstraintsWithNames:
 */
- (void)removeConstraintWithName:(NSString *)name;

@end
