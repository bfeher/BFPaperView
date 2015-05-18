BFPaperView
=============
[![CocoaPods](https://img.shields.io/cocoapods/v/BFPaperView.svg?style=flat)](https://github.com/bfeher/BFPaperView)

> A flat view inspired by Google Material Design's Paper theme.

![Animated Screenshot](https://raw.githubusercontent.com/bfeher/BFPaperView/master/BFPaperViewDemoGif.gif "Animated Screenshot")


Changes
--------
> Please see included [CHANGELOG file](https://github.com/bfeher/BFPaperView/blob/master/CHANGELOG.md).


About
---------
### Now with smoother animations and more public properties for even easier customization!
### Also New: Tap-Handler blocks! 


_BFPaperView_ is a subclass of UIView that behaves much like the new paper views from Google's Material Design Labs.
All animation are asynchronous and are performed on sublayers.
BFPaperViews work right away with pleasing default behaviors, however they can be easily customized! Almost every aspect about this view is customizable!

BFPaperViews come in 2 flavors, Flat or Raised. 
Flat BFPaperViews have no shadow and will remain flat through all animations. Flat views can be transparent, in which case the background will also fade a little when tapped.
Raised BFPaperViews have a drop shadow that animates along with a tap, giving it the feeling of raising up with your touch. Raised BFPaperViews do not look good with a clear background color since it will expose their shadow layer underneath.

By default, BFPaperViews use "Smart Color" which will match the tap-circle and background fade colors to the color of the `titleLabel`.
You can turn off Smart Color by setting the property, `.usesSmartColor` to `NO`. If you disable Smart Color, a gray color will be used by default for both the tap-circle and the background color fade.
You can set your own colors via: `.tapCircleColor` and `.backgroundFadeColor`. Note that setting these disables Smart Color.

## Properties
`UIColor *shadowColor` <br />
The UIColor for the shadow of a raised button. An alpha value of 1 is recommended as shadowOpacity overwrites the alpha of this color.

`CGFloat loweredShadowOpacity` <br />
A CGFLoat representing the opacity of the shadow of RAISED buttons when they are lowered (idle). Default is `0.5f`.

`CGFloat loweredShadowRadius` <br />
A CGFLoat representing the radius of the shadow of RAISED buttons when they are lowered (idle). Default is `1.5f`.

`CGSize loweredShadowOffset` <br />
A CGSize representing the offset of the shadow of RAISED buttons when they are lowered (idle). Default is `(0, 1)`.

`CGFloat liftedShadowOpacity` <br />
A CGFLoat representing the opacity of the shadow of RAISED buttons when they are lifted (on touch down). Default is `0.5f`.

`CGFloat liftedShadowRadius` <br />
A CGFLoat representing the radius of the shadow of RAISED buttons when they are lifted (on touch down). Default is `4.5f`.

`CGSize liftedShadowOffset` <br />
A CGSize representing the offset of the shadow of RAISED buttons when they are lifted (on touch down). Default is `(2, 4)`.

`CGFloat touchDownAnimationDuration` <br />
A CGFLoat representing the duration of the animations which take place on touch DOWN! Default is `0.25f` seconds. (Go Steelers)

`CGFloat touchUpAnimationDuration` <br />
A CGFLoat representing the duration of the animations which take place on touch UP! Default is `2 * touchDownAnimationDuration` seconds.

`CGFloat tapCircleDiameterStartValue` <br />
A CGFLoat representing the diameter of the tap-circle as soon as it spawns, before it grows. Default is `5.f`.

`CGFloat tapCircleDiameter` <br />
The CGFloat value representing the Diameter of the tap-circle. By default it will be the result of `MAX(self.frame.width, self.frame.height)`. `tapCircleDiameterFull` will calculate a circle that always fills the entire view. Any value less than or equal to `tapCircleDiameterFull` will result in default being used. The constants: `tapCircleDiameterLarge`, `tapCircleDiameterMedium`, and `tapCircleDiameterSmall` are also available for use. */

`CGFloat tapCircleBurstAmount` <br />
The CGFloat value representing how much we should increase the diameter of the tap-circle by when we burst it. Default is `100.f`.

`CGFloat cornerRadius` <br />
The corner radius which propagates through to the sub layers. Default is `0`.

`UIColor *tapCircleColor` <br />
The UIColor to use for the circle which appears where you tap. NOTE: Setting this defeats the "Smart Color" ability of the tap circle. Alpha values less than `1` are recommended.

`UIColor *backgroundFadeColor` <br />
The UIColor to fade clear backgrounds to. NOTE: Setting this defeats the "Smart Color" ability of the background fade. Alpha values less than `1` are recommended.

`BOOL rippleFromTapLocation` <br />
A flag to set to `YES` to have the tap-circle ripple from point of touch. If this is set to `NO`, the tap-circle will always ripple from the center of the view. Default is `YES`.

`BOOL rippleBeyondBounds` <br />
A flag to set to `YES` to have the tap-circle ripple beyond the bounds of the view. If this is set to `NO`, the tap-circle will be clipped to the view's bounds. Default is `NO`.

`(nonatomic, copy) void (^tapHandler)(CGPoint location)` <br />
A block to run on touch up, if the touch up is witin the bounds of the view. Basically turning the view into a button.

`BOOL isRaised` <br />
A flag to set to `YES` to CHANGE a flat view to raised, or set to `NO` to CHANGE a raised view to flat. If you used one of the provided custom initializers, you should probably leave this parameter alone. If you instantiated via storyboard or IB and want to CHANGE from riased to flat, this is the parameter for you! Default is `YES`.

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

### Creating a Raised BFPaperView with a Tap-Handler block (could also be flat, just change raised flag to NO)
```objective-c
BFPaperView *raisedPaperViewWithATapHanlder = [[BFPaperView alloc] initWithFrame:rect raised:YES tapHandlerBlock:someBlockToRunOnTapUp];
```

### Customized Example
```objective-c
BFPaperView *paperView = [[BFPaperView alloc] initWithFrame:CGRectMake(116, 468, 86, 86) raised:YES tapHandlerBlock:someBlockToRunOnTapUp];
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
pod 'BFPaperView', '~> 2.2.2'
```


License
--------
_BFPaperView_ uses the MIT License:

> Please see included [LICENSE file](https://raw.githubusercontent.com/bfeher/BFPaperView/master/LICENSE.md).
