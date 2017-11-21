//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//

#import "UIColor+THAdditions.h"

@implementation UIColor (THAdditions)

- (UIColor *)lighterColor {
    /**
     *  色调，饱和度，亮度，透明度；
     */
    CGFloat hue, saturation, brightness, alpha;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:saturation brightness:MIN(brightness * 1.3, 1.0) alpha:0.5];
	}
    return nil;
}

- (UIColor *)darkerColor {
    CGFloat hue, saturation, brightness, alpha;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
		return [UIColor colorWithHue:hue saturation:saturation brightness:brightness * 0.92 alpha:alpha];
	}
    return nil;
}

@end