# AutoLayoutKit

[![Version](https://cocoapod-badges.herokuapp.com/v/AutoLayoutKit/badge.png)](http://cocoadocs.org/docsets/AutoLayoutKit)
[![Platform](https://cocoapod-badges.herokuapp.com/p/AutoLayoutKit/badge.png)](http://cocoadocs.org/docsets/AutoLayoutKit)
[![Build Status](https://travis-ci.org/floriankrueger/AutoLayoutKit.png?branch=master)](https://travis-ci.org/floriankrueger/AutoLayoutKit)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/floriankrueger/autolayoutkit/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

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
