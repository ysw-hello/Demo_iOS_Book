//
//  ZYBExerciseBaseScrollView.m
//  ZYBYiLian
//
//  Created by AW Technician on 2017/9/7.
//  Copyright © 2017年 AW Technician. All rights reserved.
//

#import "ZYBExerciseBaseScrollView.h"

@implementation ZYBExerciseBaseScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self];
    UIView *headerView = nil;
    NSInteger page = self.contentOffset.x/kScreenWidth;
    NSInteger index = 0;
    for (UITableView *subView in self.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            if (index == page) {
                headerView = subView.tableHeaderView;
                break;
            }else{
                index++;
            }
        }
    }
    CGRect rect = [headerView convertRect:headerView.bounds toView:self.superview];
    point = [self convertPoint:point toView:self.superview];
    if (CGRectContainsPoint(rect, point)) {
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
