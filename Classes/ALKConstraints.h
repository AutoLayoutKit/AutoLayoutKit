//  ALKConstraints.h
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

@class ALKConstraints;

/**
 This type only exists to wrap the `NSLayoutAttribute` enum which uses rather
 long names that are a hassle to type. Basically, these are just shorter names
 meaning exactly the same.
 
 @since 0.1.0
 */
typedef NS_ENUM(NSInteger, ALKAttribute) {
  /** NSLayoutAttributeLeft */            ALKLeft,
  /** NSLayoutAttributeRight */           ALKRight,
  /** NSLayoutAttributeTop */             ALKTop,
  /** NSLayoutAttributeBottom */          ALKBottom,
  /** NSLayoutAttributeLeading */         ALKLeading,
  /** NSLayoutAttributeTrailing */        ALKTrailing,
  /** NSLayoutAttributeWidth */           ALKWidth,
  /** NSLayoutAttributeHeight */          ALKHeight,
  /** NSLayoutAttributeCenterX */         ALKCenterX,
  /** NSLayoutAttributeCenterY */         ALKCenterY,
  /** NSLayoutAttributeBaseline */        ALKBaseline,
  /** NSLayoutAttributeNotAnAttribute */  ALKNone
};

/**
 This type only exists to wrap the `NSLayoutRelation` enum which uses rather
 long names that are a hassle to type. Basically, these are just shorter names
 meaning exactly the same.
 
 @since 0.1.0
 */
typedef NS_ENUM(NSInteger, ALKRelation) {
  /** NSLayoutRelationLessThanOrEqual */    ALKLessThan,
  /** NSLayoutRelationEqual */              ALKEqualTo,
  /** NSLayoutRelationGreaterThanOrEqual */ ALKGreaterThan
};

/**
 @brief This is a special block type that is used by the DSL to create sets of
 `NSLayoutConstraints`. You don't need to care about it very much.
 
 The block receives an instance of `ALKConstraints` on which you can operate 
 within the block to create `NSLayoutConstraint` instances on the view 
 maintained by the `ALKConstraint` instance.
 
 @param[in] c The ALKConstraint instance you can create `NSLayoutConstraints` 
 with
 
 @since 0.1.0
 */
typedef void (^LKLayoutBlock)(ALKConstraints *c);

/**
 `ALKConstraints` is the heart of *AutoLayoutKit*. It provides the user with a
 brief possibility to create `NSLayoutConstraint` sets in a clear and verbose
 way. You don't need to care about the class itself as you are only going to
 use the class name `ALKConstraints` in the first row of each set.
 
 ## Subclassing Notes ##
 
 `ALKConstraints` is not intended for subclassing.
 
 ## Using AutoLayoutKit ##
 
 A default constraint set consists of **four** constraints. It is only when you
 are layouting views that have an intrinsic content size that you only need
 **two** constraint definitions.
 
 Take a look at this "normal" constraint set:
 
    [ALKConstraints layout:self.optionA do:^(ALKConstraints *c) {
      [c set:ALKHeight to:60.f name:kLKHeight];
      [c set:ALKWidth to:60.f name:kLKWidth];
      [c make:ALKRight equalTo:self.optionB s:ALKLeft plus:-10.f];
      [c make:ALKCenterY equalTo:self s:ALKCenterY];
    }];
 
 The first two are setting the height and the width of the View `optionA` while
 the third and the last are aligning the center of `optionA` to the center of
 the superview vertically (`ALKCenterY`) and the right edge of `optionA` to the
 left edge of `optionB` (with a margin of 10.f).
 
 Check the rest of the API to see what you can do using *AutoLayoutKit*.
 */
@interface ALKConstraints : NSObject

////////////////////////////////////////////////////////////////////////////////
/// @name Creating ALKConstraints
////////////////////////////////////////////////////////////////////////////////

/**
 @brief The heart of `ALKConstraints`. Every constraint set starts with a call
 to this class method.
 
 The method internally creates an instance of `ALKConstraints` and initializes 
 it with the given `view`. Then this instance is given to `layoutBlock` as 
 parameter `c` so that you can create `NSLayoutConstraints` with it.
 
 @param view The view that will be the target of all `NSLayoutConstraint` 
 instances created in `layoutBlock`
 @param layoutBlock The block wherein the created `ALKConstraints` instance 
 lives.
 
 @since 0.1.0
 */
+ (ALKConstraints *)layout:(UIView *)view do:(LKLayoutBlock)layoutBlock;

/**
 The designated initializer of `ALKConstraints`. You should never have to use 
 this.
 
 @param view view that will be the target of all `NSLayoutConstraint`
 instances created with this `ALKConstraints` instance.
 
 @since 0.1.0
 */
- (id)initWithView:(UIView *)view;

////////////////////////////////////////////////////////////////////////////////
/// @name Configuring the ALKConstrain Priorities
////////////////////////////////////////////////////////////////////////////////

/**
 @brief Sets the priority of all upcoming `ALKConstraints` to `priority`.
 
 By default, all created constraints are `UILayoutPriorityRequired`.
 
 Because priorities must be set on `UILayoutConstraint`s before they are added
 to any view, the priority parameter has to be set before the constraints are
 created. This way you might also "group" your constraints based on their 
 priority. All constraints you create *after* you've called this method will 
 have the changed priority value until you reset the priority to 1000.
 
    [ALKConstraints layout:self.optionA do:^(ALKConstraints *c) {
      // this constraint has a priority of 1000 (required)
      [c set:ALKHeight to:60.f name:kLKHeight];
 
      [c setPriority:500];
 
      // this constraint has a priority of 500
      [c set:ALKWidth to:60.f name:kLKWidth];
    }];
 
 @param priority A `UILayoutPriority` (a.k.a. `float`) between 0 and
 UILayoutPriorityRequired (1000).
 
 @see -setPriorityRequired
 @see -setPriorityDefaultHigh
 @see -setPriorityDefaultLow
 @see -setPriorityFittingSizeLevel
 
 @since 0.5.0
 */
- (void)setPriority:(UILayoutPriority)priority;

/**
 @brief Sets the priority of all upcoming `ALKConstraints` to 
 `UILayoutPriorityRequired`.
 
 This is the default setting.
 
 @see -setPriority:
 @see -setPriorityDefaultHigh
 @see -setPriorityDefaultLow
 @see -setPriorityFittingSizeLevel
 
 @since 0.5.0
 */
- (void)setPriorityRequired;

/**
 @brief Sets the priority of all upcoming `ALKConstraints` to
 `UILayoutPriorityDefaultHigh`.
 
 This equals a value of 750.
 
 @see -setPriorityRequired
 @see -setPriority:
 @see -setPriorityDefaultLow
 @see -setPriorityFittingSizeLevel
 
 @since 0.5.0
 */
- (void)setPriorityDefaultHigh;

/**
 @brief Sets the priority of all upcoming `ALKConstraints` to
 `UILayoutPriorityDefaultLow`.
 
 This equals a value of 250.
 
 @see -setPriorityRequired
 @see -setPriorityDefaultHigh
 @see -setPriority:
 @see -setPriorityFittingSizeLevel
 
 @since 0.5.0
 */
- (void)setPriorityDefaultLow;

/**
 @brief Sets the priority of all upcoming `ALKConstraints` to
 `UILayoutPriorityFittingSizeLevel`.
 
 This equals a value of 50.
 
 @see -setPriorityRequired
 @see -setPriorityDefaultHigh
 @see -setPriorityDefaultLow
 @see -setPriority:
 
 @since 0.5.0
 */
- (void)setPriorityFittingSizeLevel;

////////////////////////////////////////////////////////////////////////////////
/// @name Setting Unrelated Constraints
////////////////////////////////////////////////////////////////////////////////

/**
 Creates an *unrelated* constraint on the target view meaning the constraint 
 doesn't relate to any other view. This is useful for setting `width` and 
 `height` for example.
 
 The constraint will be added to the target itself.
 
 @param attribute The `NSLayoutAttribute` that is influenced by the created 
 constraint. You need to use `ALKAttribute` names.
 @param constant The value of the constraint. Set this to 10.f for example to
 make a view 10.f wide.
 
 @see -set:to:name:
 
 @since 0.1.0
 */
- (void)set:(ALKAttribute)attribute
         to:(CGFloat)constant;

/**
 Creates an *unrelated* constraint on the target view meaning the constraint
 doesn't relate to any other view. This is useful for setting `width` and
 `height` for example.
 
 The constraint will be added to the target itself.
 
 @param attribute The `NSLayoutAttribute` that is influenced by the created
 constraint. You need to use `ALKAttribute` names.
 @param constant The value of the constraint. Set this to 10.f for example to
 make a view 10.f wide.
 @param name The name of the created constraint. You can fetch the created 
 constraint later on using `constraintWithName:` on the target view.
 
 @see -set:to:
 
 @since 0.1.0
 */
- (void)set:(ALKAttribute)attribute
         to:(CGFloat)constant
       name:(NSString *)name;

////////////////////////////////////////////////////////////////////////////////
/// @name Make Equal to (Related Constraints)
////////////////////////////////////////////////////////////////////////////////

/**
 Creates a *related* constraint on the target view meaning the constraint 
 relates to another view. This is useful for aligning view to each other, for 
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced 
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport` 
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the 
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this 
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be 
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:equalTo:s:times:plus:on:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:equalTo:s:times:plus:on:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:equalTo:s:times:plus:on:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:equalTo:s:times:plus:on:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:equalTo:s:plus:on:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:equalTo:s:plus:on:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:equalTo:s:plus:on:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:equalTo:s:plus:on:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:equalTo:s:times:on:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:equalTo:s:times:on:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a multiplier of `1.f`.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:equalTo:s:on:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - It assumes a multiplier of `1.f`.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:equalTo:s:on:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 
 @see -make:equalTo:s:times:plus:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 
 @see -make:equalTo:s:times:plus:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the targetView.
 
 @see -make:equalTo:s:times:plus:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the targetView.
 
 @see -make:equalTo:s:times:plus:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 
 @see -make:equalTo:s:plus:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 
 @see -make:equalTo:s:plus:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the targetView.
 
 @see -make:equalTo:s:plus:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a multiplier of `1.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the targetView.
 
 @see -make:equalTo:s:plus:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 
 @see -make:equalTo:s:times:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the targetView.
 
 @see -make:equalTo:s:times:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a multiplier of `1.f`.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 
 @see -make:equalTo:s:name:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the center of a view equal to the center of its superview.
 
 - The constraint created by this method uses the `NSLayoutRelationEqual`
 relation.
 - The constraint will be added to the nearest common superview of the target and
 the related view. In most cases, it will be the superview of the target.
 - It assumes a multiplier of `1.f`.
 - It assumes a constant of `0.f`.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the targetView.
 
 @see -make:equalTo:s:
 
 @since 0.1.0
 */
- (void)make:(ALKAttribute)attribute
     equalTo:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        name:(NSString *)name;

////////////////////////////////////////////////////////////////////////////////
/// @name Make Less Than or Equal to (Related Constraints)
////////////////////////////////////////////////////////////////////////////////

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its 
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:lessThan:s:times:plus:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:lessThan:s:times:plus:on:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:times:plus:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:times:plus:on:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:lessThan:s:plus:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:lessThan:s:plus:on:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:plus:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:plus:on:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:lessThan:s:times:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:times:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:lessThan:s:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 
 @see -make:lessThan:s:times:plus:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 
 @see -make:lessThan:s:times:plus:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:times:plus:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:times:plus:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 
 @see -make:lessThan:s:plus:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 
 @see -make:lessThan:s:plus:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:plus:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:plus:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 
 @see -make:lessThan:s:times:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:times:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.

 
 @see -make:lessThan:s:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view smaller than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationLessThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:lessThan:s:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
    lessThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        name:(NSString *)name;

////////////////////////////////////////////////////////////////////////////////
/// @name Make Greater Than or Equal to (Related Constraints)
////////////////////////////////////////////////////////////////////////////////

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:greaterThan:s:times:plus:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:greaterThan:s:times:plus:on:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:times:plus:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:times:plus:on:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:greaterThan:s:plus:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:greaterThan:s:plus:on:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:plus:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:plus:on:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:greaterThan:s:times:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:times:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 
 @see -make:greaterThan:s:on:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
          on:(UIView *)targetView;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param targetView The view to which the constraint is added. This needs to be
 a common superview of both the target and the related view, otherwise you will
 cause exceptions.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:on:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
          on:(UIView *)targetView
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 
 @see -make:greaterThan:s:times:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 
 @see -make:greaterThan:s:times:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is added to the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:times:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        plus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param constant The constant is subtracted from the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:times:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
       minus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 
 @see -make:greaterThan:s:plus:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 
 @see -make:greaterThan:s:plus:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is added to the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:plus:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        plus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param constant The constant is subtracted from the multiplication result.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:plus:name:
 
 @since 0.5.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       minus:(CGFloat)constant
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 
 @see -make:greaterThan:s:times:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param multiplier The constant of the related view is multiplied with this
 value to determine the targets constraint.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:times:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
       times:(CGFloat)multiplier
        name:(NSString *)name;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 
 @see -make:greaterThan:s:name:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute;

/**
 Creates a *related* constraint on the target view meaning the constraint
 relates to another view. This is useful for aligning view to each other, for
 example making the width of a view greater than or equal to the width of its
 superview.
 
 - The constraint created by this method uses the `NSLayoutRelationGreaterThanOrEqual`
 relation.
 
 @param attribute The `NSLayoutAttribute` on the target view that is influenced
 by the created constraint. You need to use `ALKAttribute` names.
 @param relatedItem The view (or a class implementing the `UILayoutSupport`
 protocol) to which the constraint relates to.
 @param relatedAttribute The `NSLayoutAttribute on the related view that the
 constraint relates to. You need to use `ALKAttribute` names.
 @param name The name of the created constraint. You can fetch the created
 constraint later on using `constraintWithName:` on the `targetView`.
 
 @see -make:greaterThan:s:
 
 @since 0.4.0
 */
- (void)make:(ALKAttribute)attribute
 greaterThan:(id)relatedItem
           s:(ALKAttribute)relatedAttribute
        name:(NSString *)name;


@end
