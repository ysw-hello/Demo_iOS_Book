//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//


#import "THViewController.h"

@implementation THViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CALayer *parentLayer = self.view.layer;
    
    UIImage *image = [UIImage imageNamed:@"lavf_cover"];
    
    CALayer *imageLayer = [CALayer layer];
    // Set the layer contents to the book cover image
    imageLayer.contents = (id)image.CGImage;
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    
    // Size and position the layer
    CGFloat midX = CGRectGetMidX(parentLayer.bounds);
    CGFloat midY = CGRectGetMidY(parentLayer.bounds);
    
    imageLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.position = CGPointMake(midX, midY);
    
    // Add the image layer as a sublayer of the parent layer
    [parentLayer addSublayer:imageLayer];
    
    // Basic animation to rotate around z-axis
    CABasicAnimation *rotationAnimation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // Rotate 360 degrees over a three-second duration, repeat indefinitely
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = 2.0f;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    // Add and execute animation on the image layer
    [imageLayer addAnimation:rotationAnimation forKey:@"rotateAnimation"];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
