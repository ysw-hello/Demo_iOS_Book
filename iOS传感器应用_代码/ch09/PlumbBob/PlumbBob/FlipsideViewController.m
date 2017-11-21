//
//  FlipsideViewController.m
//  PlumbBob
//  Created by 关东升 on 12-9-24.
//  

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight > 480) {
        //iPhone 5设备
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about-bg-iphone5.png"]];
        self.imageView.frame = CGRectMake(0,44,320,524);
    } else {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about-bg.png"]];
        self.imageView.frame = CGRectMake(0,44,320,436);

    }
    
    [self.view addSubview:self.imageView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //设置状态栏风格
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
