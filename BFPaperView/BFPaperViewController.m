//
//  BFPaperViewController.m
//  BFPaperView
//
//  Created by Bence Feher on 9/13/14.
//  Copyright (c) 2014 Bence Feher. All rights reserved.
//

#import "BFPaperViewController.h"
#import "BFPaperView.h"


@interface BFPaperViewController ()
@property (weak, nonatomic) IBOutlet BFPaperView *largeBluePaperView;
@property (weak, nonatomic) IBOutlet BFPaperView *clearPaperView;
@property (weak, nonatomic) IBOutlet BFPaperView *smallGreenPaperView;
@end

@implementation BFPaperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Customize large paper view:
    self.largeBluePaperView.tapCircleColor = [UIColor colorWithRed:255.f/255.f green:193.f/255.f blue:7.f/255.f alpha:1];
    self.largeBluePaperView.isRaised = YES;
    
    // Customize smaller center view:
    self.smallGreenPaperView.tapCircleColor = [[UIColor colorWithRed:101.f/255.f green:31.f/255.f blue:255.f/255.f alpha:1] colorWithAlphaComponent:0.9f];
    self.smallGreenPaperView.cornerRadius = self.smallGreenPaperView.bounds.size.width / 2;
    self.smallGreenPaperView.rippleBeyondBounds = YES;
    self.smallGreenPaperView.rippleFromTapLocation = NO;
    self.smallGreenPaperView.tapCircleDiameter = self.smallGreenPaperView.bounds.size.width * 1.2;
    
    // Customize clear paper view:
    self.clearPaperView.tapCircleColor = [UIColor colorWithRed:33.f/255.f green:150.f/255.f blue:243.f/255.f alpha:1];
    self.clearPaperView.isRaised = NO;
    self.clearPaperView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    self.clearPaperView.layer.borderWidth = 0.5f;
    
    void (^clearTapBlock)() = ^void(CGPoint location) {
        NSLog(@"Tapped on clear view at x:%@ y:%@!", @(location.x), @(location.y));
    };
    self.clearPaperView.tapHandler = clearTapBlock;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
