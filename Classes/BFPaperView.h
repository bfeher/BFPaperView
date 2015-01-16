//
//  BFPaperView.h
//  BFPaperView
//
//  Created by Bence Feher on 9/13/14.
//  Copyright (c) 2014 Bence Feher. All rights reserved.
//

#import <UIKit/UIKit.h>


// Nice circle diameter constants with ugly names:
extern CGFloat const bfPaperView_tapCircleDiameterMedium;
extern CGFloat const bfPaperView_tapCircleDiameterSmall;
extern CGFloat const bfPaperView_tapCircleDiameterLarge;
extern CGFloat const bfPaperView_tapCircleDiameterDefault;

@interface BFPaperView : UIView <UIGestureRecognizerDelegate>

/* Notes on RAISED vs FLAT:
 *
 * RAISED
 *  Has a shadow, so a clear background will look silly.
 *  It has only a tap-circle color. No background-fade.
 *
 * FLAT
 *  Has no shadow, therefore clear backgrounds look fine.
 *  If the background is clear, it also has a background-fade
 *  color to help visualize the view and its frame.
 *
 */

#pragma mark - Initializers
/**
 *  Initializes a BFPaperView without a frame. Can be Raised of Flat.
 *
 *  @param raised A BOOL flag to determine whether or not this instance should be raised or flat. YES = Raised, NO = Flat.
 *
 *  @return A (Raised or Flat) BFPaperView without a frame!
 */
- (instancetype)initWithRaised:(BOOL)raised;


/**
 *  Initializes a BFPaperView with a frame. Can be Raised of Flat.
 *
 *  @param frame  A CGRect to use as the view's frame.
 *  @param raised A BOOL flag to determine whether or not this instance should be raised or flat. YES = Raised, NO = Flat.
 *
 *  @return A (Raised or Flat) BFPaperView with a frame!
 */
- (instancetype)initWithFrame:(CGRect)frame raised:(BOOL)raised;


#pragma mark - Properties
/** The corner radius which propagates through to the sub layers. */
@property (nonatomic) CGFloat cornerRadius;

/** The UIColor to use for the circle which appears where you tap. NOTE: Setting this defeats the "Smart Color" ability of the tap circle. Alpha values less than 1 are recommended. */
@property UIColor *tapCircleColor;

/** The UIColor to fade clear backgrounds to. NOTE: Setting this defeats the "Smart Color" ability of the background fade. An alpha value of 1 is recommended, as the fade is a constant (backgroundFadeConstant) defined in the BFPaperTabBar.m. This bothers me too. */
@property UIColor *backgroundFadeColor;

/** A flag to set to YES to have the tap-circle ripple from point of touch. If this is set to NO, the tap-circle will always ripple from the center of the tab. Default is YES. */
@property BOOL rippleFromTapLocation;

/** A flag to set to YES to have the tap-circle ripple beyond the bounds of the view. If this is set to NO, the tap-circle will be clipped to the view's bounds. Default is NO. */
@property (nonatomic) BOOL rippleBeyondBounds;

/** The CGFloat value representing the Diameter of the tap-circle. By default it will be the result of MAX(self.frame.width, self.frame.height). Any value less than zero will result in default being used. The constants: tapCircleDiameterLarge, tapCircleDiameterMedium, and tapCircleDiameterSmall are also available for use. */
@property CGFloat tapCircleDiameter;

/** A flag to set to YES to CHANGE a flat view to raised, or set to NO to CHANGE a raised view to flat. If you used one of the provided custom initializers, you should probably leave this parameter alone. If you instantiated via storyboard or IB and want to change from riased to flat, this is the parameter for you! */
@property (nonatomic) BOOL isRaised;

@end
