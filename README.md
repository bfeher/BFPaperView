BFPaperView
=============
[![CocoaPods](https://img.shields.io/cocoapods/v/BFPaperView.svg?style=flat)](https://github.com/bfeher/BFPaperView)

> A flat view inspired by Google Material Design's Paper theme.

![Animated Screenshot](https://raw.githubusercontent.com/bfeher/BFPaperView/master/BFPaperViewDemoGif.gif "Animated Screenshot")


About
---------
_BFPaperView_ is a subclass of UIView that behaves much like the new paper views from Google's Material Design Labs.
All animation are asynchronous and are performed on sublayers.
BFPaperViews work right away with pleasing default behaviors, however they can be easily customized! The corner radius, tap-circle color, background fade color, and tap-circle diameter are all readily customizable via public properties.

BFPaperViews come in 2 flavors, Flat or Raised. 
Flat BFPaperViews have no shadow and will remain flat through all animations. Flat views can be transparent, in which case the background will also fade a little when tapped.
Raised BFPaperViews have a drop shadow that animates along with a tap, giving it the feeling of raising up with your touch. Raised BFPaperViews do not look good with a clear background color since it will expose their shadow layer underneath.

By default, BFPaperViews use "Smart Color" which will match the tap-circle and background fade colors to the color of the `titleLabel`.
You can turn off Smart Color by setting the property, `.usesSmartColor` to `NO`. If you disable Smart Color, a gray color will be used by default for both the tap-circle and the background color fade.
You can set your own colors via: `.tapCircleColor` and `.backgroundFadeColor`. Note that setting these disables Smart Color.

## Properties
`CGFloat cornerRadius` <br />
The corner radius which propagates through to the sub layers.

`UIColor *tapCircleColor` <br />
The UIColor to use for the circle which appears where you tap. NOTE: Setting this defeats the "Smart Color" ability of the tap circle. Alpha values less than 1 are recommended.

`UIColor *backgroundFadeColor` <br />
The UIColor to fade clear backgrounds to. NOTE: Setting this defeats the "Smart Color" ability of the background fade. An alpha value of 1 is recommended, as the fade is a constant (clearBGFadeConstant) defined in the BFPaperView.m. This bothers me too.

`CGFloat tapCircleDiameter` <br />
The CGFloat value representing the Diameter of the tap-circle. By default it will be calculated to almost be big enough to cover up the whole background. Any value less than zero will result in default being used. Three pleasing sizes, `BFPaperView_tapCircleDiameterSmall`, `BFPaperView_tapCircleDiameterMedium`, and `BFPaperView_tapCircleDiameterLarge` are also available for use.

`BOOL rippleFromTapLocation`<br />
A flag to set to YES to have the tap-circle ripple from point of touch. If this is set to NO, the tap-circle will always ripple from the center of the view. Default is YES.

`BOOL rippleBeyondBounds`<br />
A flag to set to YES to have the tap-circle ripple beyond the bounds of the view. If this is set to NO, the tap-circle will be clipped to the view's bounds. Default is NO.

`BOOL isRaised`<br />
A flag to set to YES to CHANGE a flat view to raised, or set to NO to CHANGE a raised view to flat. If you used one of the provided custom initializers, you should probably leave this parameter alone. If you instantiated via storyboard or IB and want to change from riased to flat, this is the parameter for you!


### Notes on RAISED vs FLAT:
####RAISED
Has a shadow, so a clear background will look silly. It has only a tap-circle color. No background-fade.
 
####FLAT
Has no shadow, therefore clear backgrounds look fine. If the background is clear, it also has a background-fade color to help visualize the view and its frame.


Usage
---------
Add the _BFPaperView_ header and implementation file to your project. (.h & .m)

### Creating a Flat BFPaperView
```objective-c
BFPaperView *flatPaperView = [[BFPaperView alloc] initWithFrame:rect raised:NO];
```

### Creating a Raised BFPaperView
```objective-c
BFPaperView *raisedPaperView = [[BFPaperView alloc] initWithFrame:rect raised:YES];
```

### Customized Example
```objective-c
BFPaperView *paperView = [[BFPaperView alloc] initWithFrame:CGRectMake(116, 468, 86, 86) raised:YES];
paperView.backgroundColor = [UIColor colorWithRed:0.3 green:0 blue:1 alpha:1];
paperView.tapCircleColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.6];  // Setting this color overrides "Smart Color".
paperView.cornerRadius = paperView.frame.size.width / 2;
paperView.rippleFromTapLocation = NO;
paperView.rippleBeyondBounds = YES;
paperView.tapCircleDiameter = MAX(paperView.frame.size.width, paperView.frame.size.height) * 1.3;
[self.view addSubview:paperView];
```

Cocoapods
-------

CocoaPods are the best way to manage library dependencies in Objective-C projects.
Learn more at http://cocoapods.org

Add this to your podfile to add BFPaperView to your project.
```ruby
platform :ios, '7.0'
pod 'BFPaperView', '~> 1.0.3'
```


License
--------
_BFPaperView_ uses the MIT License:

> Please see included [LICENSE file](https://raw.githubusercontent.com/bfeher/BFPaperView/master/LICENSE.md).
