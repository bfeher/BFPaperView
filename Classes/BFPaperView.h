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
extern CGFloat const bfPaperView_tapCircleDiameterFull;
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
 *  Initializes a BFPaperView without a frame, specifiying a block to run on tap. Can be Raised of Flat.
 *
 *  @param raised          A BOOL flag to determine whether or not this instance should be raised or flat. YES = Raised, NO = Flat.
 *  @param tapHandlerBlock A block of code to run when the view is tapped.
 *
 *  @return A (Raised or Flat) BFPaperView without a frame!
 */
- (instancetype)initWithRaised:(BOOL)raised
               tapHandlerBlock:(void (^)(CGPoint location))tapHandlerBlock;


/**
 *  Initializes a BFPaperView with a frame. Can be Raised of Flat.
 *
 *  @param frame  A CGRect to use as the view's frame.
 *  @param raised A BOOL flag to determine whether or not this instance should be raised or flat. YES = Raised, NO = Flat.
 *
 *  @return A (Raised or Flat) BFPaperView with a frame!
 */
- (instancetype)initWithFrame:(CGRect)frame
                       raised:(BOOL)raised;

/**
 *  Initializes a BFPaperView with a frame, specifiying a block to run on tap. Can be Raised of Flat.
 *
 *  @param frame  A CGRect to use as the view's frame.
 *  @param raised A BOOL flag to determine whether or not this instance should be raised or flat. YES = Raised, NO = Flat.
 *  @param tapHandlerBlock A block of code to run when the view is tapped.
 *
 *  @return A (Raised or Flat) BFPaperView with a frame!
 */
- (instancetype)initWithFrame:(CGRect)frame
                       raised:(BOOL)raised
              tapHandlerBlock:(void (^)(CGPoint location))tapHandlerBlock;



#pragma mark - Properties
#pragma mark - Shadow
/** The UIColor for the shadow of a raised button. An alpha value of 1 is recommended as shadowOpacity overwrites the alpha of this color. */
@property UIColor *shadowColor;

#pragma mark Shadow - Down
/** A CGFLoat representing the opacity of the shadow of RAISED buttons when they are lowered (idle). Default is 0.5f. */
@property CGFloat   loweredShadowOpacity;
/** A CGFLoat representing the radius of the shadow of RAISED buttons when they are lowered (idle). Default is 1.5f. */
@property CGFloat   loweredShadowRadius;
/** A CGSize representing the offset of the shadow of RAISED buttons when they are lowered (idle). Default is (0, 1). */
@property CGSize    loweredShadowOffset;

#pragma mark Shadow - Up
/** A CGFLoat representing the opacity of the shadow of RAISED buttons when they are lifted (on touch down). Default is 0.5f. */
@property CGFloat   liftedShadowOpacity;
/** A CGFLoat representing the radius of the shadow of RAISED buttons when they are lifted (on touch down). Default is 4.5f. */
@property CGFloat   liftedShadowRadius;
/** A CGSize representing the offset of the shadow of RAISED buttons when they are lifted (on touch down). Default is (2, 4). */
@property CGSize    liftedShadowOffset;


#pragma mark Animation
/** A CGFLoat representing the duration of the animations which take place on touch DOWN! Default is 0.25f seconds. (Go Steelers) */
@property CGFloat touchDownAnimationDuration;
/** A CGFLoat representing the duration of the animations which take place on touch UP! Default is 2 * touchDownAnimationDuration seconds. */
@property CGFloat touchUpAnimationDuration;


#pragma mark Prettyness and Behaviour
/** The corner radius which propagates through to the sub layers. Default is 0. */
@property (nonatomic) CGFloat cornerRadius;

/** A CGFLoat representing the diameter of the tap-circle as soon as it spawns, before it grows. Default is 5.f. */
@property CGFloat tapCircleDiameterStartValue;
/** The CGFloat value representing the Diameter of the tap-circle. By default it will be the result of MAX(self.frame.width, self.frame.height). tapCircleDiameterFull will calculate a circle that always fills the entire view. Any value less than or equal to tapCircleDiameterFull will result in default being used. The constants: tapCircleDiameterLarge, tapCircleDiameterMedium, and tapCircleDiameterSmall are also available for use. */
@property CGFloat tapCircleDiameter;

/** The CGFloat value representing how much we should increase the diameter of the tap-circle by when we burst it. Default is 100.f. */
@property CGFloat tapCircleBurstAmount;

/** The UIColor to use for the circle which appears where you tap. NOTE: Setting this defeats the "Smart Color" ability of the tap circle. Alpha values less than 1 are recommended. */
@property UIColor *tapCircleColor;

/** The UIColor to fade clear backgrounds to. NOTE: Setting this defeats the "Smart Color" ability of the background fade. Alpha values less than 1 are recommended. */
@property UIColor *backgroundFadeColor;

/** A flag to set to YES to have the tap-circle ripple from point of touch. If this is set to NO, the tap-circle will always ripple from the center of the tab. Default is YES. */
@property BOOL rippleFromTapLocation;

/** A flag to set to YES to have the tap-circle ripple beyond the bounds of the view. If this is set to NO, the tap-circle will be clipped to the view's bounds. Default is NO. */
@property (nonatomic) BOOL rippleBeyondBounds;

/** A flag to set to YES to CHANGE a flat view to raised, or set to NO to CHANGE a raised view to flat. If you used one of the provided custom initializers, you should probably leave this parameter alone. If you instantiated via storyboard or IB and want to change from riased to flat, this is the parameter for you! Default is YES. */
@property (nonatomic) BOOL isRaised;

/** A block to run on touch up, if the touch up is witin the bounds of the view. Basically turning the view into a button. */
@property (nonatomic, copy) void (^tapHandler)(CGPoint location);

@end
