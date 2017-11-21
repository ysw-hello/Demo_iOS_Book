//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//


#import "THLevelMeterColorThreshold.h"

@implementation THLevelMeterColorThreshold

+ (instancetype)colorThresholdWithMaxValue:(CGFloat)maxValue color:(UIColor *)color name:(NSString *)name {
    return [[self alloc] initWithMaxValue:maxValue color:color name:name];
}

- (instancetype)initWithMaxValue:(CGFloat)maxValue color:(UIColor *)color name:(NSString *)name {
    self = [super init];
    if (self) {
        _maxValue = maxValue;
        _color = color;
        _name = [name copy];
    }
    return self;
}

- (NSString *)description {
    return self.name;
}

@end
