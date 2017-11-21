//
//  FlipsideViewController.h
//  PlumbBob
//
//  Created by 关东升 on 12-9-24.
// 
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImageView *imageView;

- (IBAction)done:(id)sender;

@end
