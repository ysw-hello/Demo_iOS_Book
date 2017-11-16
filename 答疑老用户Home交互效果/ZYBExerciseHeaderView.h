//
//  ZYBExerciseHeaderView.h
//  ZYBYiLian
//
//  Created by AW Technician on 2017/9/4.
//  Copyright © 2017年 AW Technician. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "ZYBExerciseTabContainer.h"

#define kSegmentHeight                                          40


@interface ZYBExerciseHeaderView : UIView

@property (nonatomic,strong) ZDPracticePracIndex *containerModel;
@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic, weak) ZYBExerciseTabContainer *superVC;
/**
 点击segment的时候调用
 */
@property (nonatomic, copy) void(^segmentSelected)(NSInteger index);

/**
 可滑动的segmentedControl
 */
@property (nonatomic, strong) MenuView *sectionView;

/**
 修改y值
 */
- (void)changeY:(CGFloat)y;

@end
