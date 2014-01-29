# AutoLayoutKit

[![Version](https://cocoapod-badges.herokuapp.com/v/AutoLayoutKit/badge.png)](http://cocoadocs.org/docsets/AutoLayoutKit)
[![Platform](https://cocoapod-badges.herokuapp.com/p/AutoLayoutKit/badge.png)](http://cocoadocs.org/docsets/AutoLayoutKit)
[![Build Status](https://travis-ci.org/floriankrueger/AutoLayoutKit.png?branch=master)](https://travis-ci.org/floriankrueger/AutoLayoutKit)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/floriankrueger/autolayoutkit/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/c7369c0e37dfc2c4abd9d34a4f755453 "githalytics.com")](http://githalytics.com/floriankrueger/AutoLayoutKit)

## Usage

For a very basic running example check out the example app. Clone the repo and run `pod install` from the Project directory first.

### NSLayoutConstraint Types

There are two types of constraints that *AutoLayoutKit* distinguishes:

1. Related Constraints
2. Unrelated Constraints

*Related Constraints* specify a constraint of the target view that has a relation to a different view. For example "The button's width is 80% of the width of its superview." is a *related* constraint: The constraint specifies that the width of the button is relating to the width of the button's superview.

*Unrelated Constraints* are constraints that only deal with the view they belong to. All of them involve the usage of a constant. "The button's height is 44 pixels" is a *unrelated* constraint: It specifies the height of the button independently from any other view.

### Creating NSLayoutConstraint Instances

*AutoLayoutKit* tries to provide you with a DSL that makes it possible to create layout constraints in a natural language that is (by the way) much more compact than the original APIs in NSLayoutConstraint.

A typical layout is created like this:

```Objective-C
[ALKConstraints layout:self.optionA do:^(ALKConstraints *c) {
  [c set:ALKHeight to:60.f name:kLKHeight];
  [c set:ALKWidth to:60.f name:kLKWidth];
  [c make:ALKRight equalTo:self.optionB s:ALKLeft plus:-10.f];
  [c make:ALKCenterY equalTo:self s:ALKCenterY];
}];
```

This code does the following things for you:

1. Disable the default translation of resizing masks to layout constraints
2. Create a *unrelated* constraint on `self.optionA` that sets its `width` to 60 pixels
3. Create a *unrelated* constraint on `self.optionA` that sets its `height` to 60 pixels
4. Create a *related* constraint on `self` that aligns the right edge of `self.optionA` to the left edge of `self.optionB` minus 10 pixels (to create a margin of 10 pixels between the two buttons)
5. Create a *related* constraint on `self` that centers the button vertically in `self

Pretty neat, isn’t it? In fact, *AutoLayoutKit* does even more: it names the two unrelated constraints `kLKHeight` and `kLKWidth` so that you can access these constraints later on for modification on runtime.

But let’s examine the basic functionality before we go into modifying the constraints. The syntax to create constraints for a view is this:

```Objective-C
[ALKConstraints layout:<the receiver> do:^(ALKConstraints *c) {
    <constraints specification>
}];
```

Nothing magical so far. The **receiver** is the view that is affected by the constraints. This is, however, not always the view that the constraints are added to. You’ll see how to specify the target view (the one that the constraints are added to) in a second.

There are two APIs to specify a constraint within the specification block: `set` and `make`. As you might have noticed, `set` creates *unrelated* constraints and `make` creates *related* constraints.

> With **set** you can directly **set** a layout property on a view while you can **make** layout properties of the receiver view like properties of other views using **make**.

The (main) API for **set** is:

```Objective-C
[c set:<layout attribute> to:<constant> name:<name>];
```

The (main) API for **make** is:

```Objective-C
[c make:<layout attribute> equalTo:<related view> s:<related views layout attribute> plus:<constant>];
```

There are also APIs for both **set** and **make** that don't require a name. Also, as you might have noticed in the first example, there is an API for **make** that doesn't require a constant. I've really tried to make this as convenient as possible. There is a ton of other convenience methods that default to the most common value. Just check out the header file.

### Using Priorities

By version 0.5.0, UILayoutPriorities are supported by ALK. All constraints created by ALK have the priority `UILayoutPriorityRequired` by default. You can change this by specifying a different priority *before* you create any constraints.

```Objective-C
[ALKConstraints layout:self.optionA do:^(ALKConstraints *c) {
  [c set:ALKHeight to:60.f name:kLKHeight]; // priority == 1000 (required)

  [c setPriority:500]; // set the priority to 500
  [c set:ALKWidth to:60.f name:kLKWidth]; // priority == 500
  [c make:ALKRight equalTo:self.optionB s:ALKLeft plus:-10.f]; // priority == 500

  [c setPriorityRequired]; // reset to default
  [c make:ALKCenterY equalTo:self s:ALKCenterY]; // priority == 1000 (required)
}];
```

When the priority is set by one of the five priority methods, the changes are effecting *all constraints that are created from there on* until a different priority is specified.

The five methods are:

```Objective-C
- (void)setPriority:(UILayoutPriority)priority;
- (void)setPriorityRequired;          // 1000
- (void)setPriorityDefaultHigh;       // 750
- (void)setPriorityDefaultLow;        // 250
- (void)setPriorityFittingSizeLevel;  // 50
```

### Working with Negative Constraints

Sometimes it's necessary to specify a constraint with a negative constant when you really mean to use a positive constant. This often leads to confusions and ugly code like `(-1) * myConst`. A good example for this scenario is a bottom margin of a child view to its superview.

Assume you want to create a bottom margin of 10 pixels. Instead of writing:

```Objective-C
[ALKConstraints layout:childView do:^(ALKConstraints *c) {
  [c make:ALKBottom equalTo:parentView s:ALKButton plus:((-1)*10.f)];
}];
```

You can write:

```Objective-C
[ALKConstraints layout:childView do:^(ALKConstraints *c) {
  [c make:ALKBottom equalTo:parentView s:ALKButton minus:10.f];
}];
```

This does the same thing but is much more readable. Every API that has a `plus:` also has a `minus:`.

### Modifying Layout Constraints

There is little we can modify on existing NSLayoutConstraint instances and the only property we can modify is the so-called **constant**. I don’t know if Apple realized how hilarious this is when they thought for a name of this property.

Normally when dealing with constraints that you want to modify later on, you need to keep references to the constraints all the time. With *AutoLayoutKit* you can just forget about the constraints because *AutoLayoutKit* keeps track of them if you tell it how you want to refer to a specific constraint later on. All constraints, that are created with a name (which is optional) can be retrieved from the target view at any time using the following API:

```Objective-C
[someView alk_constraintWithName:<some name>];
```
	
Similarly, these constraints can be removed from a target view by calling:

```Objective-C
[someView alk_removeConstraintWithName:<some name>];
```
	
The constraints retrieved via constraintWithName: can then be modified like this:

```Objective-C
NSLayoutConstraint *height = [button alk_constraintWithName:kLKHeight];
height.constant = 70.f;
[button setNeedsUpdateConstraints];
```
    
The first line retrieves the constraint and stores it in height. The second line modifies the constraint’s constant, the last line flags the button (the target view) that it needs to update its constraints.

Note that the changes are not effective after these lines. They become effective when you call `layoutIfNeeded` on the closest anchestor view of all affected views. This can be done within an animation block which will then animate from the last (current) constraint setting to the changed setting.

> Because you normally change more than one constraint at once, this call is not performed transparently by *AutoLayoutKit*. You know, when all of your (simultaneous) changes are done and all affected views are marked for update. And you know, wether the changes should be applied animated or immediately.

## Requirements

## Installation

*AutoLayoutKit* is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

```Ruby
pod "AutoLayoutKit"
```

## Author

Florian Krueger, florian.krueger@projectserver.org

## License

*AutoLayoutKit* is available under the MIT license. See the LICENSE file for more info.





