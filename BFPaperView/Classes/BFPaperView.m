//
//  BFPaperView.m
//  BFPaperView
//
//  Created by Bence Feher on 9/13/14.
//  Copyright (c) 2014 Bence Feher. All rights reserved.
//

#import "BFPaperView.h"
// Pods:
#import "UIColor+BFPaperColors.h"

@interface BFPaperView ()
@property CGRect downRect;
@property CGRect upRect;
@property CGPoint tapPoint;
@property BOOL letGo;
@property BOOL growthFinished;
@property CALayer *backgroundColorFadeLayer;
@property NSMutableArray *rippleAnimationQueue;
@property NSMutableArray *deathRowForCircleLayers;  // This is where old circle layers go to be killed :(
@end

@implementation BFPaperView
CGFloat const bfPaperView_tapCircleDiameterDefault = -1;
// Constants used for tweaking the look/feel of:
// -shadow radius:
static CGFloat const bfPaperView_loweredShadowRadius             = 1.5f;
static CGFloat const bfPaperView_raisedShadowRadius              = 4.5f;
// -shadow location:
static CGFloat const bfPaperView_loweredShadowYOffset            = 1.f;
static CGFloat const bfPaperView_raisedShadowYOffset             = 4.f;
//static const CGFloat loweredShadowXOffset            = 0.f;
static CGFloat const bfPaperView_raisedShadowXOffset             = 2.f;
// -shadow opacity:
static CGFloat const bfPaperView_loweredShadowOpacity            = 0.5f;
static CGFloat const bfPaperView_raisedShadowOpacity             = 0.5f;
// -animation durations:
static CGFloat const bfPaperView_animationDurationConstant       = 0.12f;
static CGFloat const bfPaperView_tapCircleGrowthDurationConstant = bfPaperView_animationDurationConstant * 2;
static CGFloat const bfPaperView_fadeOutDurationConstant         = bfPaperView_animationDurationConstant * 4.5;
// -the tap-circle's size:
static CGFloat const bfPaperView_tapCircleDiameterStartValue     = 5.f;    // for the mask
// -the tap-circle's beauty:
static CGFloat const bfPaperView_tapFillConstant                 = 0.16f;
static CGFloat const bfPaperView_clearBGTapFillConstant          = 0.12f;
static CGFloat const bfPaperView_clearBGFadeConstant             = 0.12f;

#define BFPAPERVIEW__DUMB_TAP_FILL_COLOR             [UIColor colorWithWhite:0.1 alpha:bfPaperView_tapFillConstant]
#define BFPAPERVIEW__CLEAR_BG_DUMB_TAP_FILL_COLOR    [UIColor colorWithWhite:0.3 alpha:bfPaperView_clearBGTapFillConstant]
#define BFPAPERVIEW__CLEAR_BG_DUMB_FADE_COLOR        [UIColor colorWithWhite:0.3 alpha:1]



#pragma mark - Default Initializers
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self bfPaperViewSetup:YES];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bfPaperViewSetup:YES];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self bfPaperViewSetup:YES];
    }
    return self;
}

#pragma mark - Custom Initializers
- (instancetype)initWithRaised:(BOOL)raised
{
    self = [super init];
    if (self) {
        [self bfPaperViewSetup:raised];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame raised:(BOOL)raised
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bfPaperViewSetup:raised];
    }
    return self;
}

#pragma mark - Setup
- (void)bfPaperViewSetup:(BOOL)raised
{
    self.isRaised = raised;

    // Default setup:
    self.cornerRadius = 0;
    self.tapCircleDiameter = bfPaperView_tapCircleDiameterDefault;
    self.rippleFromTapLocation = YES;
    self.rippleBeyondBounds = NO;
    
    self.rippleAnimationQueue = [NSMutableArray array];
    self.deathRowForCircleLayers = [NSMutableArray array];
    
    CGRect endRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y , self.frame.size.width, self.frame.size.height);
    //NSLog(@"endRect in setup = (%0.2f, %0.2f, %0.2f %0.2f", endRect.origin.x, endRect.origin.y, endRect.size.width, endRect.size.height);
    //NSLog(@"cornerRadius = %0.2f", self.cornerRadius);
    self.backgroundColorFadeLayer = [[CALayer alloc] init];
    self.backgroundColorFadeLayer.frame = endRect;
    self.backgroundColorFadeLayer.cornerRadius = self.cornerRadius;
    self.backgroundColorFadeLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer insertSublayer:self.backgroundColorFadeLayer atIndex:0];
    
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    
    self.tapCircleColor = nil;
    self.backgroundFadeColor = nil;
    
    if (self.isRaised) {
        // Draw shadow
        self.downRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + bfPaperView_loweredShadowYOffset);
        self.upRect = CGRectMake(0 - bfPaperView_raisedShadowXOffset, self.bounds.origin.y + bfPaperView_raisedShadowYOffset, self.bounds.size.width + (2 * bfPaperView_raisedShadowXOffset), self.bounds.size.height + bfPaperView_raisedShadowYOffset);
        
        //        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor colorWithWhite:0.2f alpha:1.f].CGColor;
        self.layer.shadowOpacity = bfPaperView_loweredShadowOpacity;
        self.layer.shadowRadius = bfPaperView_loweredShadowRadius;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.downRect cornerRadius:self.cornerRadius].CGPath;
        self.layer.shadowOffset = CGSizeMake(0.f, 1.0f);
    }
    else {
        // Erase shadow:
        self.layer.shadowOpacity = 0.f;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Setters:
- (void)setIsRaised:(BOOL)isRaised
{
    _isRaised = isRaised;
    self.downRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + bfPaperView_loweredShadowYOffset);
    self.upRect = CGRectMake(0 - bfPaperView_raisedShadowXOffset, self.bounds.origin.y + bfPaperView_raisedShadowYOffset, self.bounds.size.width + (2 * bfPaperView_raisedShadowXOffset), self.bounds.size.height + bfPaperView_raisedShadowYOffset);
    
    if (_isRaised) {
        // Draw shadow
        self.layer.shadowColor = [UIColor colorWithWhite:0.2f alpha:1.f].CGColor;
        self.layer.shadowOpacity = bfPaperView_loweredShadowOpacity;
        self.layer.shadowRadius = bfPaperView_loweredShadowRadius;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.downRect cornerRadius:self.cornerRadius].CGPath;
        self.layer.shadowOffset = CGSizeMake(0.f, 1.0f);
    }
    else {
        // Erase shadow:
        self.layer.shadowOpacity = 0.f;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
    self.backgroundColorFadeLayer.cornerRadius = _cornerRadius;
    
    if (self.isRaised) {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.downRect cornerRadius:self.cornerRadius].CGPath;
    }
    [self layoutSubviews];
}


#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.letGo = NO;
    self.growthFinished = NO;
    
    [self growTapCircle];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.letGo = YES;
    
//    if (self.growthFinished) {
        [self growTapCircleABit];
//    }
    [self fadeTapCircleOut];
    [self fadeBGOutAndBringShadowBackToStart];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.letGo = YES;
    
//    if (self.growthFinished) {
        [self growTapCircleABit];
//    }
    [self fadeTapCircleOut];
    [self fadeBGOutAndBringShadowBackToStart];
}


#pragma mark - Gesture Recognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint location = [touch locationInView:self];
    //NSLog(@"location: x = %0.2f, y = %0.2f", location.x, location.y);
    
    self.tapPoint = location;
    
    return NO;  // Disallow recognition of tap gestures. We just needed this to grab that tasty tap location.
}


#pragma mark - Animation
- (void)animationDidStop:(CAAnimation *)theAnimation2 finished:(BOOL)flag
{
    //NSLog(@"animation ENDED");
    self.growthFinished = YES;
    
    if ([[theAnimation2 valueForKey:@"id"] isEqualToString:@"fadeCircleOut"]) {
        [[self.deathRowForCircleLayers objectAtIndex:0] removeFromSuperlayer];
        if (self.deathRowForCircleLayers.count > 0) {
            [self.deathRowForCircleLayers removeObjectAtIndex:0];
        }
    }
    else if ([[theAnimation2 valueForKey:@"id"] isEqualToString:@"removeFadeBackgroundDarker"]) {
        self.backgroundColorFadeLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
}


- (void)growTapCircle
{
    //NSLog(@"expanding a tap circle");
    if (self.isRaised) {
        // Increase shadow radius:
        CABasicAnimation *increaseRadius = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        increaseRadius.fromValue = [NSNumber numberWithFloat:bfPaperView_loweredShadowRadius];
        increaseRadius.toValue = [NSNumber numberWithFloat:bfPaperView_raisedShadowRadius];
        increaseRadius.duration = bfPaperView_animationDurationConstant;
        increaseRadius.fillMode = kCAFillModeForwards;
        increaseRadius.removedOnCompletion = NO;
        
        // Change its frame a bit larger and shift it down a bit:
        CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        shadowAnimation.duration = bfPaperView_animationDurationConstant;
        shadowAnimation.fromValue = (id)[UIBezierPath bezierPathWithRoundedRect:self.downRect cornerRadius:self.cornerRadius].CGPath;
        shadowAnimation.toValue = (id)[UIBezierPath bezierPathWithRoundedRect:self.upRect cornerRadius:self.cornerRadius].CGPath;
        shadowAnimation.fillMode = kCAFillModeForwards;
        shadowAnimation.removedOnCompletion = NO;
        
        // Lighten the shadow opacity:
        CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowOpacityAnimation.duration = bfPaperView_animationDurationConstant;
        shadowOpacityAnimation.fromValue = [NSNumber numberWithFloat:bfPaperView_loweredShadowOpacity];
        shadowOpacityAnimation.toValue = [NSNumber numberWithFloat:bfPaperView_raisedShadowOpacity];
        shadowOpacityAnimation.fillMode = kCAFillModeBackwards;
        shadowOpacityAnimation.removedOnCompletion = NO;
        
        [self.layer addAnimation:shadowAnimation forKey:@"shadow"];
        [self.layer addAnimation:increaseRadius forKey:@"shadowRadius"];
        [self.layer addAnimation:shadowOpacityAnimation forKey:@"shadowOpacity"];
    }

    // Spawn a growing circle that "ripples" through the view:
    CGRect endRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y , self.frame.size.width, self.frame.size.height);
    
    if ([UIColor isColorClear:self.backgroundColor]) {
        // CLEAR BACKROUND SHOULD ONLY BE FOR FLAT VIEW!!!
        
        // Set the fill color for the tap circle (self.animationLayer's fill color):
        if (!self.tapCircleColor) {
            self.tapCircleColor = BFPAPERVIEW__CLEAR_BG_DUMB_TAP_FILL_COLOR;
        }
        
        if (!self.backgroundFadeColor) {
            self.backgroundFadeColor = BFPAPERVIEW__CLEAR_BG_DUMB_FADE_COLOR;
        }
        
        // Setup background fade layer:
        self.backgroundColorFadeLayer.frame = endRect;
        //NSLog(@"endRect in animation = (%0.2f, %0.2f, %0.2f %0.2f", endRect.origin.x, endRect.origin.y, endRect.size.width, endRect.size.height);
        self.backgroundColorFadeLayer.cornerRadius = self.cornerRadius;
        self.backgroundColorFadeLayer.backgroundColor = self.backgroundFadeColor.CGColor;
        
        // Fade the background color a bit darker:
        CABasicAnimation *fadeBackgroundDarker = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeBackgroundDarker.duration = bfPaperView_animationDurationConstant;
        fadeBackgroundDarker.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        fadeBackgroundDarker.fromValue = [NSNumber numberWithFloat:0.f];
        fadeBackgroundDarker.toValue = [NSNumber numberWithFloat:bfPaperView_clearBGFadeConstant];
        fadeBackgroundDarker.fillMode = kCAFillModeForwards;
        fadeBackgroundDarker.removedOnCompletion = NO;
        
        [self.backgroundColorFadeLayer addAnimation:fadeBackgroundDarker forKey:@"animateOpacity"];
    }
    else {
        // COLORED BACKGROUNDS (can be smart or dumb):
        
        // Set the fill color for the tap circle (self.animationLayer's fill color):
        if (!self.tapCircleColor) {
            self.tapCircleColor = BFPAPERVIEW__DUMB_TAP_FILL_COLOR;
        }
    }
    
    
    
    // Calculate the tap circle's ending diameter:
    CGFloat tapCircleFinalDiameter = (self.tapCircleDiameter < 0) ? MAX(self.frame.size.width, self.frame.size.height) : self.tapCircleDiameter;
    
    // Create a UIView which we can modify for its frame value later (specifically, the ability to use .center):
    UIView *tapCircleLayerSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleFinalDiameter, tapCircleFinalDiameter)];
    tapCircleLayerSizerView.center = self.rippleFromTapLocation ? self.tapPoint : CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Calculate starting path:
    UIView *startingRectSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bfPaperView_tapCircleDiameterStartValue, bfPaperView_tapCircleDiameterStartValue)];
    startingRectSizerView.center = tapCircleLayerSizerView.center;
    
    // Create starting circle path:
    UIBezierPath *startingCirclePath = [UIBezierPath bezierPathWithRoundedRect:startingRectSizerView.frame cornerRadius:bfPaperView_tapCircleDiameterStartValue / 2.f];
    
    // Calculate ending path:
    UIView *endingRectSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleFinalDiameter, tapCircleFinalDiameter)];
    endingRectSizerView.center = tapCircleLayerSizerView.center;
    
    // Create ending circle path:
    UIBezierPath *endingCirclePath = [UIBezierPath bezierPathWithRoundedRect:endingRectSizerView.frame cornerRadius:tapCircleFinalDiameter / 2.f];
    
    // Create tap circle:
    CAShapeLayer *tapCircle = [CAShapeLayer layer];
    tapCircle.fillColor = self.tapCircleColor.CGColor;
    tapCircle.strokeColor = [UIColor clearColor].CGColor;
    tapCircle.borderColor = [UIColor clearColor].CGColor;
    tapCircle.borderWidth = 0;
    tapCircle.path = startingCirclePath.CGPath;
    
    // Create a mask if we are not going to ripple over bounds:
    if (!self.rippleBeyondBounds) {
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius].CGPath;
        mask.fillColor = [UIColor blackColor].CGColor;
        mask.strokeColor = [UIColor clearColor].CGColor;
        mask.borderColor = [UIColor clearColor].CGColor;
        mask.borderWidth = 0;
        
        // Set tap circle layer's mask to the mask:
        tapCircle.mask = mask;
    }
    
    // Add tap circle to array and view:
    [self.rippleAnimationQueue addObject:tapCircle];
    [self.layer insertSublayer:tapCircle above:self.backgroundColorFadeLayer];
    
    
    /*
     * Animations:
     */
    // Grow tap-circle animation (performed on mask layer):
    CABasicAnimation *tapCircleGrowthAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    tapCircleGrowthAnimation.delegate = self;
    [tapCircleGrowthAnimation setValue:@"tapGrowth" forKey:@"id"];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    tapCircleGrowthAnimation.duration = bfPaperView_tapCircleGrowthDurationConstant;
    tapCircleGrowthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    tapCircleGrowthAnimation.fromValue = (__bridge id)startingCirclePath.CGPath;
    tapCircleGrowthAnimation.toValue = (__bridge id)endingCirclePath.CGPath;
    tapCircleGrowthAnimation.fillMode = kCAFillModeForwards;
    tapCircleGrowthAnimation.removedOnCompletion = NO;
    
    // Fade in self.animationLayer:
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = bfPaperView_animationDurationConstant;
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.fillMode = kCAFillModeForwards;
    fadeIn.removedOnCompletion = NO;
    
    // Add the animations to the layers:
    [tapCircle addAnimation:tapCircleGrowthAnimation forKey:@"animatePath"];
    [tapCircle addAnimation:fadeIn forKey:@"opacityAnimation"];
}


- (void)fadeBGOutAndBringShadowBackToStart
{
    // NSLog(@"fading bg");
    
    if (self.isRaised) {
        // Decrease shadow radius:
        CABasicAnimation *decreaseRadius = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        decreaseRadius.fromValue = [NSNumber numberWithFloat:bfPaperView_raisedShadowRadius];
        decreaseRadius.toValue = [NSNumber numberWithFloat:bfPaperView_loweredShadowRadius];
        decreaseRadius.duration = bfPaperView_fadeOutDurationConstant;
        decreaseRadius.fillMode = kCAFillModeForwards;
        decreaseRadius.removedOnCompletion = NO;
        
        // Move shadow back up a bit and shrink it a bit:
        CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        shadowAnimation.duration = bfPaperView_fadeOutDurationConstant;
        shadowAnimation.fromValue = (id)[UIBezierPath bezierPathWithRoundedRect:self.upRect cornerRadius:self.cornerRadius].CGPath;
        shadowAnimation.toValue = (id)[UIBezierPath bezierPathWithRoundedRect:self.downRect cornerRadius:self.cornerRadius].CGPath;
        shadowAnimation.fillMode = kCAFillModeForwards;
        shadowAnimation.removedOnCompletion = NO;
        
        // Darken shadow opacity:
        CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowOpacityAnimation.duration = bfPaperView_fadeOutDurationConstant;
        shadowOpacityAnimation.fromValue = [NSNumber numberWithFloat:bfPaperView_raisedShadowOpacity];
        shadowOpacityAnimation.toValue = [NSNumber numberWithFloat:bfPaperView_loweredShadowOpacity];
        shadowOpacityAnimation.fillMode = kCAFillModeBackwards;
        shadowOpacityAnimation.removedOnCompletion = NO;
        
        [self.layer addAnimation:shadowAnimation forKey:@"shadow"];
        [self.layer addAnimation:decreaseRadius forKey:@"shadowRadius"];
        [self.layer addAnimation:shadowOpacityAnimation forKey:@"shadowOpacity"];
    }
    
    if ([UIColor isColorClear:self.backgroundColor]) {
        // Remove darkened background fade:
        CABasicAnimation *removeFadeBackgroundDarker = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [removeFadeBackgroundDarker setValue:@"removeFadeBackgroundDarker" forKey:@"id"];
        removeFadeBackgroundDarker.delegate = self;
        removeFadeBackgroundDarker.duration = bfPaperView_animationDurationConstant;
        removeFadeBackgroundDarker.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        removeFadeBackgroundDarker.fromValue = [NSNumber numberWithFloat:bfPaperView_clearBGFadeConstant];
        removeFadeBackgroundDarker.toValue = [NSNumber numberWithFloat:0.f];
        removeFadeBackgroundDarker.fillMode = kCAFillModeForwards;
        removeFadeBackgroundDarker.removedOnCompletion = NO;
        
        [self.backgroundColorFadeLayer addAnimation:removeFadeBackgroundDarker forKey:@"removeBGShade"];
    }
}


- (void)growTapCircleABit
{
    //NSLog(@"expanding a bit more");
    
    // Create a UIView which we can modify for its frame value later (specifically, the ability to use .center):
    CGFloat tapCircleDiameterStartValue = (self.tapCircleDiameter < 0) ? MAX(self.frame.size.width, self.frame.size.height) : self.tapCircleDiameter;
    UIView *tapCircleLayerSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleDiameterStartValue, tapCircleDiameterStartValue)];
    tapCircleLayerSizerView.center = self.rippleFromTapLocation ? self.tapPoint : CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Calculate mask starting path:
    UIView *startingRectSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleDiameterStartValue, tapCircleDiameterStartValue)];
    startingRectSizerView.center = tapCircleLayerSizerView.center;
    
    // Create starting circle path for mask:
    UIBezierPath *startingCirclePath = [UIBezierPath bezierPathWithRoundedRect:startingRectSizerView.frame cornerRadius:tapCircleDiameterStartValue / 2.f];
    
    // Calculate mask ending path:
    CGFloat tapCircleDiameterEndValue = (self.tapCircleDiameter < 0) ? MAX(self.frame.size.width, self.frame.size.height) : self.tapCircleDiameter;
    tapCircleDiameterEndValue += 100.f;
    UIView *endingRectSizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tapCircleDiameterEndValue, tapCircleDiameterEndValue)];
    endingRectSizerView.center = tapCircleLayerSizerView.center;
    
    // Create ending circle path for mask:
    UIBezierPath *endingCirclePath = [UIBezierPath bezierPathWithRoundedRect:endingRectSizerView.frame cornerRadius:tapCircleDiameterEndValue / 2.f];
    
    
    // Get the next tap circle to expand:
    CAShapeLayer *tapCircle = [self.rippleAnimationQueue firstObject];
    
    // Expand tap-circle animation:
    CABasicAnimation *tapCircleGrowthAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    tapCircleGrowthAnimation.duration = bfPaperView_fadeOutDurationConstant;
    tapCircleGrowthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    tapCircleGrowthAnimation.fromValue = (__bridge id)startingCirclePath.CGPath;
    tapCircleGrowthAnimation.toValue = (__bridge id)endingCirclePath.CGPath;
    tapCircleGrowthAnimation.fillMode = kCAFillModeForwards;
    tapCircleGrowthAnimation.removedOnCompletion = NO;
    
    [tapCircle addAnimation:tapCircleGrowthAnimation forKey:@"animatePath"];
}


- (void)fadeTapCircleOut
{
    //NSLog(@"Fading away");
    
    CALayer *tempAnimationLayer = [self.rippleAnimationQueue firstObject];
    if (self.rippleAnimationQueue.count > 0) {
        [self.rippleAnimationQueue removeObjectAtIndex:0];
    }
    [self.deathRowForCircleLayers addObject:tempAnimationLayer];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOut setValue:@"fadeCircleOut" forKey:@"id"];
    fadeOut.delegate = self;
    fadeOut.fromValue = [NSNumber numberWithFloat:tempAnimationLayer.opacity];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.duration = bfPaperView_tapCircleGrowthDurationConstant* 2.45;
    fadeOut.fillMode = kCAFillModeForwards;
    fadeOut.removedOnCompletion = NO;
    
    [tempAnimationLayer addAnimation:fadeOut forKey:@"opacityAnimation"];
}
#pragma mark -




@end
