# AutoLayoutKit

[![Version](https://cocoapod-badges.herokuapp.com/v/AutoLayoutKit/badge.png)](http://cocoadocs.org/docsets/AutoLayoutKit)
[![Platform](https://cocoapod-badges.herokuapp.com/p/AutoLayoutKit/badge.png)](http://cocoadocs.org/docsets/AutoLayoutKit)
[![Build Status](https://travis-ci.org/floriankrueger/AutoLayoutKit.png?branch=master)](https://travis-ci.org/floriankrueger/AutoLayoutKit)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/floriankrueger/autolayoutkit/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

## Announcement: Manuscript

You think about using AutoLayoutKit in one of your shiny new swift-only Apps? Well, now you can.

Introducing [Manuscript](https://github.com/floriankrueger/Manuscript), the fancy successor of AutoLayoutKit written in pure Swift. (Carthage compatible, still under development)

## Usage

For a very basic running example check out the example app. Clone the repo and run `pod install` from the Project directory first.

Let me give you a quick example on how easy it is to create NSLayoutConstraints in code using ALK.

```Objective-C
[ALKConstraints layout:childView do:^(ALKConstraints *c) {
  [c make:ALKCenterX equalTo:self s:ALKCenterX];
  [c make:ALKCenterY equalTo:self s:ALKCenterY];
  [c set:ALKWidth to:30.f];
  [c set:ALKHeight to:30.f];
}];
```

Curious what the same code looks without ALK? Check out [this](https://github.com/floriankrueger/AutoLayoutKit/wiki/Without-AutoLayoutKit).

### New in Version 0.6.0: Convenience Methods

Entering Version 0.6.0, the basic sample from above can be improved even further.

```Objective-C
[ALKConstraints layout:childView do:^(ALKConstraints *c) {
  [c centerIn:self];
  [c setSize:CGSizeMake(30.f, 30.f)];
}];
```

### New in Version 1.0.0:
#### Using with Swift without optional chaining
```Swift
ALKConstraints.layout(titleLabel) { c in
  c.make(.trailing, equalTo: self, s: .trailing, minus: 10)
}
```

#### Store newly created active constraint to block valiable
```Objective-C
__block NSLayoutConstraint * heightConstraint = nil;
[ALKConstraints layout:self.view do:^(ALKConstraints * c) {
  heightConstraint = [c set:ALKHeight to:100.f];
}];
```
```Swift
var leadingConstraint: NSLayoutConstraint? = nil
ALKConstraints.layout(titleLabel) { c in
  leadingConstraint = c.make(.leading, equalTo: self, s: .leading, plus: 10)
}
```

#### Using iOS 11 [Safe Area](https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area)

> In case of iOS version less than 11, default `make...` methods will be used as fallback.

> All [Safe Area](https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area) methods uses times value as 1.0.

```Objective-C
[ALKConstraints layout:titleLabel do:^(ALKConstraints * c) {
  [c make:ALKLeading equalToSafeArea:self.view s:ALKLeading plus:8];
  [c make:ALKTrailing equalToSafeArea:self.view s:ALKTrailing minus:8];
}];
```
```Swift
ALKConstraints.layout(titleLabel) { c in
  c.make(.leading, equalToSafeArea: self, s: .leading, plus: 8)
  c.make(.trailing, equalToSafeArea: self, s: .trailing, minus: 8)
}
```


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
