# LayoutKit

[![Version](http://cocoapod-badges.herokuapp.com/v/LayoutKit/badge.png)](http://cocoadocs.org/docsets/LayoutKit)
[![Platform](http://cocoapod-badges.herokuapp.com/p/LayoutKit/badge.png)](http://cocoadocs.org/docsets/LayoutKit)

## Usage

For a very basic running example check out the example app. Clone the repo and run `pod install` from the Project directory first.

### NSLayoutConstraint Types

There are two types of constraints that *LayoutKit* distinguishes:

1. Related Constraints
2. Unrelated Constraints

*Related Constraints* specify a constraint of the target view that has a relation to a different view. For example "The button's width is 80% of the width of its superview." is a *related* constraint: The constraint specifies that the width of the button is relating to the width of the button's superview.

*Unrelated Constraints* are constraints that only deal with the view they belong to. All of them involve the usage of a constant. "The button's height is 44 pixels" is a *unrelated* constraint: It specifies the height of the button independently from any other view.

### Creating NSLayoutConstraint Instances

*LayoutKit* tries to provide you with a DSL that makes it possible to create layout constraints in a natural language that is (by the way) much more compact than the original APIs in NSLayoutConstraint.

A typical layout is created like this:

```Objective-C
[LKConstraints layout:self.optionA do:^(LKConstraints *c) {
    [c set:LK_height to:60.f name:kLKHeight];
    [c set:LK_width to:60.f name:kLKWidth];
    [c make:LK_right equalTo:self.optionB s:LK_left plus:-10.f];
    [c make:LK_center_y equalTo:self s:LK_center_y];
}];
```

This code does the following things for you:

1. Disable the default translation of resizing masks to layout constraints
2. Create a *unrelated* constraint on `self.optionA` that sets its `width` to 60 pixels
3. Create a *unrelated* constraint on `self.optionA` that sets its `height` to 60 pixels
4. Create a *related* constraint on `self` that aligns the right edge of `self.optionA` to the left edge of `self.optionB` minus 10 pixels (to create a margin of 10 pixels between the two buttons)
5. Create a *related* constraint on `self` that centers the button vertically in `self

Pretty neat, isn’t it? In fact, *LayoutKit* does even more: it names the two unrelated constraints `kLKHeight` and `kLKWidth` so that you can access these constraints later on for modification on runtime.

But let’s examine the basic functionality before we go into modifying the constraints. The syntax to create constraints for a view is this:

```Objective-C
[LKConstraints layout:<the receiver> do:^(LKConstraints *c) {
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

### Modifying Layout Constraints

There is little we can modify on existing NSLayoutConstraint instances and the only property we can modify is the so-called **constant**. I don’t know if Apple realized how hilarious this is when they thought for a name of this property.

Normally when dealing with constraints that you want to modify later on, you need to keep references to the constraints all the time. With *LayoutKit* you can just forget about the constraints because *LayoutKit* keeps track of them if you tell it how you want to refer to a specific constraint later on. All constraints, that are created with a name (which is optional) can be retrieved from the target view at any time using the following API:

```Objective-C
[someView constraintWithName:<some name>];
```
	
Similarly, these constraints can be removed from a target view by calling:

```Objective-C
[someView removeConstraintWithName:<some name>];
```
	
The constraints retrieved via constraintWithName: can then be modified like this:

```Objective-C
NSLayoutConstraint *height = [button constraintWithName:kLKHeight];
height.constant = 70.f;
[button setNeedsUpdateConstraints];
```
    
The first line retrieves the constraint and stores it in height. The second line modifies the constraint’s constant, the last line flags the button (the target view) that it needs to update its constraints.

Note that the changes are not effective after these lines. They become effective when you call `layoutIfNeeded` on the closest anchestor view of all affected views. This can be done within an animation block which will then animate from the last (current) constraint setting to the changed setting.

> Because you normally change more than one constraint at once, this call is not performed transparently by *LayoutKit*. You know, when all of your (simultaneous) changes are done and all affected views are marked for update. And you know, wether the changes should be applied animated or immediately.

## Requirements

## Installation

LayoutKit is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

```Ruby
pod "LayoutKit"
```

## Author

Florian Krueger, florian.krueger@projectserver.org

## License

LayoutKit is available under the MIT license. See the LICENSE file for more info.

