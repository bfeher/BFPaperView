//
//  BFPaperViewController.m
//  BFPaperView
//
//  Created by Bence Feher on 9/13/14.
//  Copyright (c) 2014 Bence Feher. All rights reserved.
//

#import "BFPaperViewController.h"

#import "BFPaperView.h"
#import "UIColor+BFPaperColors.h"


@interface BFPaperViewController ()
@property (weak, nonatomic) IBOutlet BFPaperView *paperView;
@property (weak, nonatomic) IBOutlet BFPaperView *clearPaperView;
@property (weak, nonatomic) IBOutlet BFPaperView *noShadowPaperView;
@end

@implementation BFPaperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Customize large paper view:
    self.paperView.tapCircleColor = [UIColor paperColorAmber];
    self.paperView.isRaised = NO;
    
    // Customize smaller center view:
    self.noShadowPaperView.tapCircleColor = [[UIColor paperColorDeepPurpleA400] colorWithAlphaComponent:0.9f];
    self.noShadowPaperView.cornerRadius = self.noShadowPaperView.bounds.size.width / 2;
    self.noShadowPaperView.rippleBeyondBounds = YES;
    self.noShadowPaperView.rippleFromTapLocation = NO;
    self.noShadowPaperView.tapCircleDiameter = self.noShadowPaperView.bounds.size.width * 1.2;
    
    // Customize clear paper view:
    self.clearPaperView.tapCircleColor = [UIColor paperColorBlue];
    self.clearPaperView.isRaised = NO;
    self.clearPaperView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    self.clearPaperView.layer.borderWidth = 0.5f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
