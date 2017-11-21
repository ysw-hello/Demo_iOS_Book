//
//  MainViewController.h
//  PlumbBob
//
//  Created by 关东升 on 12-9-24.
//

#import "FlipsideViewController.h"

#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

#define kAccelerometerFrequency 40


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong,nonatomic) UIImageView* plumbBobView;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (weak, nonatomic) IBOutlet UIButton *btnInfo;

- (void)rotatePlumbStringToDegree:(CGFloat)positionInDegrees;

@end

CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);
