//
//  ZYBExerciseHeaderView.m
//  ZYBYiLian
//
//  Created by AW Technician on 2017/9/4.
//  Copyright © 2017年 AW Technician. All rights reserved.
//

#import "ZYBExerciseHeaderView.h"
#import "SyncExerciseViewController.h"
#import "ExerciseChapterViewModel.h"
#import "ExerciseTextBookContainController.h"
#import "ZYBSliderBannerView.h"
#import "AppStringProtocolHelper.h"

#define kBackScrollViewLeftMagins                               10
#define kFunctionViewLeftMagins                                 15
#define kFunctionViewCornerRaduis                               5
#define kFunctionViewsSpace                                     10
#define kFunctionViewsTitleFontSize                             16
#define kFunctionViewsTitleColor                                0x222222
#define kFunctionViewsLineColor                                 0xf5f5f5

@interface ZYBExerciseHeaderView ()<MenuViewDelegate>

@property (nonatomic, strong)UIView *exerciseView;
@property (nonatomic, strong)ZYBSliderBannerView *bannerView;
@property (nonatomic, strong)UIView *bannerViewContainer;

@end
@implementation ZYBExerciseHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerHeight = 150;
        
        self.backgroundColor = kBackGroundColor;
        // 创建headerView
        [self addSubview:self.bannerViewContainer];
        // 创建segmentedControl
        self.sectionView = [[MenuView alloc] initWithMneuViewStyle:MenuViewStyleLine AndTitles:@[@"数学", @"语文", @"英语", @"物理", @"化学", @"政治", @"生物"]];
        self.sectionView.frame = CGRectMake(0, self.headerHeight, kScreenWidth, kSegmentHeight);
        self.sectionView.delegate = self;
        [self addSubview:self.sectionView];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.sectionView.height, kScreenWidth, kSingleLine)];
        line.backgroundColor = kSegmentationLineColor;
        [self.sectionView addSubview:line];
    }
    return self;
}

- (void)changeY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setContainerModel:(ZDPracticePracIndex *)containerModel{
    _containerModel = containerModel;
    NSMutableArray *imageArr = @[].mutableCopy;
    NSMutableArray *tapLinkArr = @[].mutableCopy;
    NSMutableArray *bidLinkArr = @[].mutableCopy;
    NSMutableArray *subjectNameArr = @[].mutableCopy;
    [containerModel.topBanner enumerateObjectsUsingBlock:^(ZDPracticePracIndexTopbannerItem* item, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArr addObjectSafely:item.pic];
        [tapLinkArr addObjectSafely:item.url];
        [bidLinkArr addObjectSafely:@(item.bid)];
    }];
    [containerModel.chosenTask.subjectList enumerateObjectsUsingBlock:^(SubjectlistItem* item, NSUInteger idx, BOOL * _Nonnull stop) {
        [subjectNameArr addObjectSafely:item.subjectName];
    }];
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    self.bannerView = [ZYBSliderBannerView sliderBannerWithFrame:CGRectMake(kFunctionViewLeftMagins, kFunctionViewLeftMagins, kScreenWidth-2*kFunctionViewLeftMagins, self.bannerViewContainer.height-2*kFunctionViewLeftMagins) imageArray:imageArr links:tapLinkArr bidArray:bidLinkArr bannerDefaultImageName:nil tapedBlock:^(NSInteger tapedIndex, NSString *link, NSString *bid) {
        ZDPracticePracIndexTopbannerItem* item = [containerModel.topBanner objectAtIndexSafely:tapedIndex];
        [[AppStringProtocolHelper sharedInstance] bannerJumpWithUrlString:item.url bid:[NSString stringWithFormat:@"%ld",(long)item.bid] btype:item.btype];
    }];
    self.bannerView.layer.masksToBounds = YES;
    self.bannerView.layer.cornerRadius = 3;
    [self.bannerViewContainer addSubview:self.bannerView];

    //重新初始化练习view
    [self.exerciseView removeFromSuperview];
    self.exerciseView = nil;
    [self addSubview:self.exerciseView];
    
    [self.sectionView loadWithScollviewAndBtnWithTitles:subjectNameArr];
    [self.sectionView setNeedsLayout];
    [self.sectionView setNeedsDisplay];
    self.sectionView.top = self.exerciseView.bottom;
    self.headerHeight = self.exerciseView.bottom;
    self.height = self.headerHeight+kSegmentHeight;
}

#pragma mark -- action method
- (void)showSyncExerciseWithCourseId:(NSInteger)courseId courseName:(NSString *)courseName stagebm:(NSString *)stagebm {
    if([ExerciseChapterViewModel selectedBookInfoForCourseId:courseId]) {
        SyncExerciseViewController *syncexercise = [[SyncExerciseViewController alloc] init];
        syncexercise.hidesBottomBarWhenPushed = YES;
        syncexercise.courseId = courseId;
        syncexercise.courseName = courseName;
        syncexercise.stagebm = stagebm;
        [self.superVC.navigationController pushViewController:syncexercise animated:YES];
    }
    else {
        ExerciseTextBookContainController *bookContainer = [[ExerciseTextBookContainController alloc] init];
        bookContainer.hidesBottomBarWhenPushed = YES;
        bookContainer.courseId = courseId;
        bookContainer.noAutoPop = YES;
        bookContainer.stagebm = stagebm;
        ExerciseBookModel *book = [[ExerciseBookModel alloc] init];
        book.courseName = courseName;
        book.courseId = courseId;
        bookContainer.selectBook = book;
        
        __weak typeof(bookContainer) weakContainer = bookContainer;
        @weakify(self);
        [bookContainer.selectBookSignal subscribeNext:^(ExerciseBookModel *book) {
            @strongify(self);
            if (book && book.bookId.length) {
                //未完成
                [self showSyncExerciseWithCourseId:courseId courseName:courseName stagebm:stagebm];
                NSMutableArray *temp = [NSMutableArray arrayWithArray: weakContainer.navigationController.viewControllers];
                [temp removeObject:weakContainer];
                weakContainer.navigationController.viewControllers = temp;
            }
            
        }];
        [self.superVC.navigationController pushViewController:bookContainer animated:YES];
    }
}


#pragma mark -- private method
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UILabel *)getTitleLabel:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:kFunctionViewsTitleFontSize];
    label.textColor = [UIColor colorWithHex:kFunctionViewsTitleColor];
    label.text = title;
    [label sizeToFit];
    label.left = kFunctionViewLeftMagins;
    label.top = kFunctionViewLeftMagins;
    return label;
}

- (UIView *)getLine{
    UIView *line = [[UIView alloc] init];
    line.width = kScreenWidth-2*kBackScrollViewLeftMagins-2*kFunctionViewLeftMagins;
    line.height = kSingleLine;
    line.backgroundColor = [UIColor colorWithHex:kFunctionViewsLineColor];
    return line;
}

#pragma mark -- getter and setter
- (UIView *)exerciseView{
    if (!_exerciseView) {
        _exerciseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerViewContainer.bottom+10, kScreenWidth, 0)];
        _exerciseView.backgroundColor = kBackGroundColor;
        
        UIView *exerciseBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        exerciseBackView.backgroundColor = [UIColor whiteColor];
        [_exerciseView addSubview:exerciseBackView];
        UILabel *title = [self getTitleLabel:@"同步练习"];
        [exerciseBackView addSubview:title];
        
        CGFloat btmWidth = _exerciseView.width/4;
        CGFloat btmHeight = 25+10+12;
        @weakify(self);
        [self.containerModel.practice.subjectSet enumerateObjectsUsingBlock:^(SubjectsetItem *subjectItem, NSUInteger i, BOOL * _Nonnull stop) {
            @strongify(self);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btmWidth*(i%4), title.bottom+20+(btmHeight+15)*(i/4), btmWidth, btmHeight);
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
            [button setTitleColor:[[UIColor colorWithHex:0xa3a3a3] colorWithAlphaComponent:.5f] forState:UIControlStateHighlighted];
            [button setTitle:subjectItem.name forState:UIControlStateNormal];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"treasure_home_exercise%@",subjectItem.name]];
            if (image) {
                [button setImage:image forState:UIControlStateNormal];
                [button setImage:[self imageByApplyingAlpha:.5f image:image] forState:UIControlStateHighlighted];
            }else{
                [button setImage:[UIImage imageNamed:@"treasure_home_exercise数学"] forState:UIControlStateNormal];
                [button setImage:[self imageByApplyingAlpha:.5f image:[UIImage imageNamed:@"treasure_home_exercise数学"]] forState:UIControlStateHighlighted];
            }
            [button layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:10];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [ZYBNlog logWithEventType:kEventTypeClick labe:PRACTICE_SYNC_EXERCISE_CLICK params:@{@"grade":@([LoginManager sharedInstance].currentUserEntity.gradeId),@"subjectId":@(subjectItem.subjectId)}];
                NSString *stagebm = [NSString transformNumber:[NSString stringWithFormat:@"%ld",(long)subjectItem.stagebm]withNumberSystem:@"2"];
                [self showSyncExerciseWithCourseId:subjectItem.subjectId courseName:subjectItem.name stagebm:[NSString stringWithFormat:@"%.3ld",(long)[stagebm integerValue]]];
            }];
            [exerciseBackView addSubview:button];
            exerciseBackView.height = button.bottom+20;
        }];
        
        UIView *segmentTitleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, exerciseBackView.height+10, kScreenWidth, 15+16+15)];
        segmentTitleBackView.backgroundColor = [UIColor whiteColor];
        UILabel *segmentTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth, segmentTitleBackView.height)];
        segmentTitle.font = [UIFont systemFontOfSize:16];
        segmentTitle.textColor = [UIColor colorWithHex:0x222222];
        segmentTitle.text = @"专项练习";
        [segmentTitleBackView addSubview:segmentTitle];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, segmentTitleBackView.height-kSingleLine, kScreenWidth, kSingleLine)];
        line.backgroundColor = kSegmentationLineColor;
        [segmentTitleBackView addSubview:line];
        [_exerciseView addSubview:segmentTitleBackView];
        _exerciseView.height = segmentTitleBackView.bottom;
    }
    return _exerciseView;
}

- (UIView *)bannerViewContainer{
    if (!_bannerViewContainer) {
        CGFloat bannerWidth = kScreenWidth-15*2;
        CGFloat bannerHeight = bannerWidth*260/720;
        _bannerViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, bannerHeight+kFunctionViewLeftMagins*2)];
        _bannerViewContainer.backgroundColor = [UIColor whiteColor];
    }
    return _bannerViewContainer;
}


#pragma mark -- menuView delegate
- (void)MenuViewDelegate:(MenuView*)menuciew WithIndex:(int)index{
    if (self.segmentSelected){
        self.segmentSelected(index);
    }
}
//// 禁掉手势
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    CGRect rect = [self.bannerView convertRect:self.bannerView.bounds toView:self];
    if ([view isKindOfClass:UIButton.class] || CGRectContainsPoint(rect, point))
        return view;
    return nil;
}


@end
