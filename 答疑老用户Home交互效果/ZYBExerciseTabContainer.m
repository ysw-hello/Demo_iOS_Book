//
//  ZYBExerciseTabContainer.m
//  ZYBYiLian
//
//  Created by AW Technician on 2017/8/23.
//  Copyright © 2017年 AW Technician. All rights reserved.
//

#import "ZYBExerciseTabContainer.h"
#import "ZYBExerciseHeaderView.h"
#import "ZYBExerciseWeikeTaskTypeCell.h"
#import "ZYBArrowTitleView.h"
#import "ZYBButtonsPickerView.h"
#import "ZYBPickerViewShowContainerView.h"
#import "ZYBExerciseListViewController.h"
#import "ZYBGradeModel.h"
#import "ZYBExerciseContainerViewModel.h"
#import "ZYBExerciseBaseScrollView.h"
#import "ZYBEvaluationManager.h"
#import "UpgradeManager.h"
#import "APPSwitchManager.h"
#import "ZYBUFOManager.h"

@interface ZYBExerciseTabContainer ()<UITableViewDelegate,UITableViewDataSource,ZYBButtonPickersViewDelegate>
{
    CGFloat startOffsetX;
    CGFloat currentOffsetX;
    NSInteger beforTitleIndex;
    NSInteger targetTitleIndex;
    CGFloat progress;
}

@property (nonatomic, assign) BOOL isFirstIn;
@property (nonatomic, assign) BOOL checkTableViewOffset;
@property (nonatomic, strong) ZYBExerciseContainerViewModel *viewModel;
//选择年级view
@property (nonatomic, strong) ZYBArrowTitleView *gradePickerView;
@property (nonatomic, strong) ZYBButtonsPickerView *subjectPickerView;
@property (nonatomic, strong) ZYBPickerViewShowContainerView *showContainerView;
@property (nonatomic, strong) NSArray *selectGradeArr;
@property (nonatomic, strong) NSArray *selectGradeIdArr;
@property (nonatomic, assign) NSInteger currentSelectGrade;
// 顶部的headeView
@property (nonatomic, strong) ZYBExerciseHeaderView *headerView;
// 底部横向滑动的scrollView，上边放着三个tableView
@property (nonatomic, strong) ZYBExerciseBaseScrollView *scrollView;
@property (nonatomic, strong) UITableView *recTaskTableView;
@property (nonatomic, strong) NSMutableArray *subTableViewArr;
@property (nonatomic, assign) NSInteger titlesCount;
@end

@implementation ZYBExerciseTabContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"练习"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isFirstIn = YES;
    self.checkTableViewOffset = YES;
    self.selectGradeArr = @[@"初一(七年级)",@"初二(八年级)",@"初三(九年级)",@"高一",@"高二",@"高三"].copy;
    self.selectGradeIdArr = @[@(2),@(3),@(4),@(5),@(6),@(7)].copy;
    self.currentSelectGrade = [LoginManager sharedInstance].currentSelectGrade;
    [self.navigationController.navigationBar addSubview:self.gradePickerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    [self setUpModels];
    [self checkNeedLogin];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.checkTableViewOffset = YES;
    [self setNavgationBarHidden:NO animated:YES];
    if (self.isFirstIn) {
        self.isFirstIn = NO;
    }else{
        [self.viewModel getContainerModel];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.gradePickerView.hidden = NO;
    if ([LoginManager sharedInstance].isLogin && [APPSwitchManager sharedInstance].appLaunchCounts == 1) {
        //如果用户是第一次登录
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"popSelectGrade"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"popSelectGrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //如果用户本地没有选择过年级
            NSNumber *gradeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZYBPracticeSelectGrade"];
            if (!gradeNumber) {
                [LoginManager sharedInstance].currentSelectGrade = 2;
                [self.gradePickerView setSelectedState:YES];
                [self gradePickerTouched];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.checkTableViewOffset = NO;
    self.gradePickerView.hidden = YES;
}

- (void)setUpModels{
    self.viewModel = [[ZYBExerciseContainerViewModel alloc] init];
    @weakify(self);
    [RACObserve([LoginManager sharedInstance], currentSelectGrade) subscribeNext:^(id x) {
        @strongify(self);
        NSInteger grade = [LoginManager sharedInstance].currentSelectGrade;
        self.currentSelectGrade = grade;
        self.viewModel.grade = grade;
        NSInteger index = [self.selectGradeIdArr indexOfObject:@(grade)];
        [self updateGradePickerWithTitle:[self.selectGradeArr objectAtIndexSafely:index]];
    }];
    [RACObserve(self.viewModel, containerStatus) subscribeNext:^(id x) {
        @strongify(self);
        [self.view removeLoadingTost];
        [self.view dismissTipsView];
        ZYBRequestType status = [x integerValue];
        if (status == ZYBRequestTypeLoading) {
            [self.view showLoadingMessage:@"正在加载"];
        }else if (status == ZYBRequestTypeSuccess) {
            self.headerView.containerModel = self.viewModel.containerModel;
            [self setUpSubViews];
        }else if (status == ZYBRequestTypeFailed) {
            [self.view showErrorMessage:@"加载失败"];
            [self.view showTipsWithTipsType:ZYBViewTipsTypeLoadError];
            TipsView *tips = [self.view getTipsView];
            tips.backgroundColor = kBackGroundColor;
        }
    }];
    [RACObserve(self.viewModel, rectaskStatus) subscribeNext:^(id x) {
        @strongify(self);
        ZYBRequestType status = [x integerValue];
        [self.view removeLoadingTost];
        if (status == ZYBRequestTypeLoading) {
            [self.view showLoadingMessage:@"正在加载"];
        }else if (status == ZYBRequestTypeSuccess) {
            [self.recTaskTableView finishPullUpWithSuccess:YES];
            self.recTaskTableView.hasMore = self.viewModel.rectaskHasMore;
            [self.recTaskTableView reloadData];
        }else if (status == ZYBRequestTypeFailed) {
            [self.recTaskTableView finishPullUpWithSuccess:NO];
            [self.view showErrorMessage:@"加载失败"];
        }
    }];
}

- (void)setUpSubViews{
    self.titlesCount = self.viewModel.containerModel.chosenTask.subjectList.count;
    self.scrollView.contentSize = CGSizeMake(self.titlesCount * kScreenWidth, 0);
    if (!self.subTableViewArr) {
        self.subTableViewArr = @[].mutableCopy;
    }
    for (int i = 0; i < self.titlesCount; i++) {
        SubjectlistItem *item = [self.viewModel.containerModel.chosenTask.subjectList objectAtIndexSafely:i];
        UITableView *tableView = [self.subTableViewArr objectAtIndexSafely:i];
        if (!tableView) {
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollView.height) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            __weak typeof(self) weakSelf = self;
            if (item.subjectId == -1) {//专门为精选加下拉刷新
                tableView.hasMore = item.hasMore;
                [tableView addPullUpView:^{
                    [weakSelf.viewModel getRectaskModel];
                }];
                self.recTaskTableView = tableView;
            }else{//为其他科目添加空白，否则内容顶不上去
                UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-UI_TAB_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-kSegmentHeight-item.taskCatList.count*[ZYBExerciseWeikeTaskTypeCell heightForItem:3])];
                if (footerView.top == 0) {
                    tableView.tableFooterView = footerView;
                }else{
                    tableView.tableFooterView = nil;
                }
            }
            UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, self.headerView.headerHeight+kSegmentHeight}];
            tableView.tableHeaderView = headerView;
            [tableView registerClass:[ZYBExerciseWeikeTaskTypeCell class] forCellReuseIdentifier:@"cell"];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            [RACObserve(tableView, contentOffset) subscribeNext:^(id x) {
                if (weakSelf.checkTableViewOffset == NO) {
                    return ;
                }
                CGFloat contentOffsetY = tableView.contentOffset.y+1;
                // 如果滑动没有超过self.headerView.headerHeight
                if (contentOffsetY < weakSelf.headerView.headerHeight) {
                    // 让这三个tableView的偏移量相等
                    for (UITableView *subTableView in weakSelf.subTableViewArr) {
                        if (subTableView.contentOffset.y != tableView.contentOffset.y) {
                            subTableView.contentOffset = tableView.contentOffset;
                        }
                    }
                    CGFloat headerY = -tableView.contentOffset.y;
                    // 改变headerView的y值
                    [weakSelf.headerView changeY:headerY];
                    // 一旦大于等于self.headerView.headerHeight了，让headerView的y值等于self.headerView.headerHeight，就停留在上边了
                } else if (contentOffsetY >= weakSelf.headerView.headerHeight) {
                    [weakSelf.headerView changeY:-weakSelf.headerView.headerHeight];
                }
            }];
            [self.subTableViewArr addObjectSafely:tableView];
            [self.scrollView addSubview:tableView];
        }
        [tableView reloadData];
    }
}

#pragma mark -- 是否弹出登录界面检查
- (BOOL)checkShowLogin{
    if((![[LoginManager sharedInstance] isLoginWithoutNetWork]) && ([APPSwitchManager sharedInstance].clickJumpNum < 3)){
        if (([APPSwitchManager sharedInstance].clickJumpNum > 0) &&
            [[APPSwitchManager sharedInstance].lastPopLoginDate isToday]) {
            AppDelegateInstance.canShowLoginVC = YES;
            return NO;
        }
        return YES;
    }else{
        AppDelegateInstance.canShowLoginVC = YES;
    }
    return NO;
}

- (void)checkNeedLogin {
    if ([self checkShowLogin]) {
        //清除cookies中的BDUSS信息
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *each in storage.cookies) {
            if ([each.name isEqualToString:@"BDUSS"]) {
                [storage deleteCookie:each];
            }
        }
        //记录当前时间
        [APPSwitchManager sharedInstance].lastPopLoginDate = [NSDate date];
        [[APPSwitchManager sharedInstance] save];
        //弹出登录
        [[LoginManager sharedInstance] showLoginViewControllerWithLoginSuccessCallback:nil JumpCallback:^{
            //用户点击跳过回调
            AppDelegateInstance.canShowLoginVC = YES;
        } DismissCallback:nil isHomeLogin:YES];
    }else{
        self.viewModel.grade = self.currentSelectGrade;
        if([[ZYBEvaluationManager sharedInstance] canShowEvaluation]){//展示好评弹窗
            @weakify(self);
            [[ZYBEvaluationManager sharedInstance] showAppEvaluationNormalWithCallBack:^{
                @strongify(self);
                [self.navigationController pushViewController:[ZYBUFOManager UFOFeedBackController:NO type:ZYBUFOPageTypeMain UFOFeedBackChannel:@"11111" FAQChannel:@"22222"] animated:YES];
            }];
        }else{
            [[UpgradeManager sharedInstance] checkUpgradeWithCompleteBlock:^(BOOL isShow) { //强制升级
            }];
        }
    }
}


#pragma mark -- uiscrollView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskcatlistItem *item;
    if (self.recTaskTableView == tableView) {
        item = [self.viewModel.rectaskArr objectAtIndex:indexPath.row];
        
    }else{
        item = [[(SubjectlistItem *)[self.viewModel.containerModel.chosenTask.subjectList objectAtIndexSafely:tableView.left/kScreenWidth] taskCatList] objectAtIndexSafely:indexPath.row];
    }
    return [ZYBExerciseWeikeTaskTypeCell heightForItem:item.itemType];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.recTaskTableView == tableView) {
        return self.viewModel.rectaskArr.count;
    }else{
        return [(SubjectlistItem *)[self.viewModel.containerModel.chosenTask.subjectList objectAtIndexSafely:tableView.left/kScreenWidth] taskCatList].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYBExerciseWeikeTaskTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TaskcatlistItem *item;
    if (self.recTaskTableView == tableView) {
        item = [self.viewModel.rectaskArr objectAtIndex:indexPath.row];

    }else{
        item = [[(SubjectlistItem *)[self.viewModel.containerModel.chosenTask.subjectList objectAtIndexSafely:tableView.left/kScreenWidth] taskCatList] objectAtIndexSafely:indexPath.row];
    }
    [cell setItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskcatlistItem *item;
    NSInteger subjectId = 0;
    if (self.recTaskTableView == tableView) {
        item = [self.viewModel.rectaskArr objectAtIndex:indexPath.row];
    }else{
        item = [[(SubjectlistItem *)[self.viewModel.containerModel.chosenTask.subjectList objectAtIndexSafely:tableView.left/kScreenWidth] taskCatList] objectAtIndexSafely:indexPath.row];
        subjectId = [(SubjectlistItem *)[self.viewModel.containerModel.chosenTask.subjectList objectAtIndexSafely:tableView.left/kScreenWidth] subjectId];
    }
    if (item.itemType == 1) {//banner
        WebViewController *webVC = [[WebViewController alloc] initWithUrl:item.url];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (item.itemType == 2) {//精选
        ZDLogEvent(kEventTypeClick, PRACTICE_PERFECT_EXERCISE_BANNER_CLICK);
        WebViewController *webVC = [[WebViewController alloc] initWithUrl:item.url];
        webVC.hideNavigationBar = YES;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (item.itemType == 3) {//分类
        [ZYBNlog logWithEventType:kEventTypeClick labe:PRACTICE_EXERCISE_PACKAGE_CLICK params:@{@"grade":@([LoginManager sharedInstance].currentUserEntity.gradeId),@"subjectId":@(subjectId)}];
        ZYBExerciseListViewController *listVC = [[ZYBExerciseListViewController alloc] initWithGradeId:self.currentSelectGrade subjectId:subjectId categoryid:item.itemId levelList:item.levelList];
        listVC.hidesBottomBarWhenPushed = YES;
        listVC.title = item.barTitle;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        // 改变segmentdControl
        int index = (int)(scrollView.contentOffset.x/self.view.width);
        CGFloat rate = scrollView.contentOffset.x/self.view.width;
        //滚动使MenuView中的item移动
        [self.headerView.sectionView SelectedBtnMoveToCenterWithIndex:index WithRate:rate];
        
        progress = 0;
        beforTitleIndex = 0;
        targetTitleIndex = 0;
        CGFloat scrollW = scrollView.width;
        
        // 判断是向左滑还是向右滑
        currentOffsetX = scrollView.contentOffset.x;
        if (startOffsetX < currentOffsetX) { // 向左滑
            
            progress = currentOffsetX / scrollW - floor(currentOffsetX / scrollW);
            beforTitleIndex = (NSInteger)currentOffsetX / scrollW;
            targetTitleIndex = beforTitleIndex + 1;
            
            // 判断越界
            if (targetTitleIndex >= self.titlesCount) {
                targetTitleIndex = self.titlesCount - 1;
            }
            
            // 完全滑过去的时候
            if (currentOffsetX - startOffsetX == scrollW) {
                progress = 1.0;
                targetTitleIndex = beforTitleIndex;
            }
        }else { // 向右滑
            progress = 1 - (currentOffsetX / scrollW - floor(currentOffsetX / scrollW));
            
            if (currentOffsetX < 0) {
                targetTitleIndex = 0;
                beforTitleIndex = 0;
            }else{
                targetTitleIndex = (NSInteger)currentOffsetX / scrollW;
                beforTitleIndex = targetTitleIndex + 1;
                
                // 判断越界
                if (targetTitleIndex >= self.titlesCount) {
                    targetTitleIndex = self.titlesCount - 1;
                }
            }

        }
        [self.headerView.sectionView setTitleChangeProgress:progress beforeIndex:beforTitleIndex targetIndex:targetTitleIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        // 刷新最大OffsetY
        [self reloadMaxOffsetY];
        startOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width )
            return;
        
        if(!decelerate){
            int Page = (int)(scrollView.contentOffset.x/kScreenWidth);
            
            if (Page == 0) {
                [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page + 1 ];
            }else if (Page == self.titlesCount - 1){
                [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page - 1];
            }else{
                [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page + 1 ];
                [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page - 1];
            }
        }
    }
 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width )
            return;
        
        int Page = (int)(scrollView.contentOffset.x/kScreenWidth);
        
        if (Page == 0) {
            [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page + 1 ];
        }else if (Page == self.titlesCount - 1){
            [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page - 1];
        }else{
            [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page + 1 ];
            [self.headerView.sectionView selectWithIndex:Page AndOtherIndex:Page - 1];
        }
    }
    
}


#pragma mark - ZYBButtonsPickerView

- (void)buttonPickerView:(ZYBButtonsPickerView *)pickerView itemDidAddSuperView:(ZYBButtonPickersViewItem *)item atIndex:(NSInteger)index {
    item.backgroundColor = kSegmentationLineColor;
    item.normalBgColor = kBackGroundColor;
    item.selectedBgColor = kAPPMainColor;
    item.layer.cornerRadius = 2;
    [item setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

- (void)buttonPickerView:(ZYBButtonsPickerView *)pickerView didSelectIndex:(NSInteger)index {
    [_showContainerView dismissWithAnimated:YES];
    _gradePickerView.selectedState = NO;
    
    NSInteger selectGrade = [[self.selectGradeIdArr objectAtIndexSafely:index] integerValue];
    if (selectGrade == self.currentSelectGrade) {
        return;
    }
    ZDLogEventWithData(kEventTypeClick, PRACTICE_MODTFY_GRADE_CLICK, @"grade", @(selectGrade));
    [LoginManager sharedInstance].currentSelectGrade = selectGrade;
}
#pragma mark -- privete method
// 刷新最大OffsetY，让三个tableView同步
- (void)reloadMaxOffsetY {
    // 计算出最大偏移量
    CGFloat maxOffsetY = 0;
    for (UITableView *subTableView in self.subTableViewArr) {
        if (subTableView.contentOffset.y > maxOffsetY) {
            maxOffsetY = subTableView.contentOffset.y;
        }
    }
    
    // 如果最大偏移量大于self.headerView.headerHeight，处理下每个tableView的偏移量
    if (maxOffsetY > self.headerView.headerHeight) {
        for (UITableView *subTableView in self.subTableViewArr) {
            if (subTableView.contentOffset.y < self.headerView.headerHeight) {
                subTableView.contentOffset = CGPointMake(0, self.headerView.headerHeight);
            }
        }
    }
}

- (void)gradePickerTouched {
    if (self.subjectPickerView.superview) {
        [self.showContainerView dismissWithAnimated:YES];
    } else {
        [self initSubjectPickerView];
    }
}

- (void)initSubjectPickerView {
    self.subjectPickerView.height = 45 * ceilf(self.selectGradeArr.count / 3.0) + 15;
    self.subjectPickerView.texts = self.selectGradeArr;
    
    NSInteger index = [self.selectGradeIdArr indexOfObject:@(self.currentSelectGrade)];
    self.subjectPickerView.selectedIndex = index;
    if (self.subjectPickerView.selectedIndex < 0 || self.subjectPickerView.selectedIndex >= self.selectGradeArr.count) {
        self.subjectPickerView.selectedIndex = 0;
    }
    [self.showContainerView showPickerView:self.subjectPickerView inView:AppDelegateInstance.mainContainer.view orginPoint:_showContainerView.origin animated:YES];
}

- (void)pickerViewDismiss {
    self.gradePickerView.selectedState = NO;
}

- (void)updateGradePickerWithTitle:(NSString *)title {
    [self.gradePickerView setTitle:title];
    [self.gradePickerView sizeToFitForWidth];
}

#pragma mark -- getter and setter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[ZYBExerciseBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarBottom-kZDTabBarHeight)];
        _scrollView.backgroundColor = kBackGroundColor;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        // 绑定代理
        _scrollView.delegate = self;
        // 设置滑动区域
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (ZYBExerciseHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZYBExerciseHeaderView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, _headerView.headerHeight+kSegmentHeight}];
        _headerView.superVC = self;
        __weak typeof(self) weakSelf = self;
        _headerView.segmentSelected = ^(NSInteger index) {
            SubjectlistItem* item = [weakSelf.viewModel.containerModel.chosenTask.subjectList objectAtIndexSafely:index];
            [ZYBNlog logWithEventType:kEventTypeClick labe:PRACTICE_SUBJECT_TAB_CLICK params:@{@"grade":@([LoginManager sharedInstance].currentUserEntity.gradeId),@"subjectId":@(item.subjectId)}];
            // 改变scrollView的contentOffset
            weakSelf.scrollView.contentOffset = CGPointMake(index * kScreenWidth, 0);
            // 刷新最大OffsetY
            [weakSelf reloadMaxOffsetY];
        };
    }
    return _headerView;
}

- (ZYBArrowTitleView *)gradePickerView{
    if (!_gradePickerView) {
        _gradePickerView = [[ZYBArrowTitleView alloc] initWithFrame:CGRectMake(15, 0, 150, 44)];
        _gradePickerView.titleLabel.font = [UIFont systemFontOfSize:14];
        _gradePickerView.titleLabel.textColor = [UIColor colorWithHex:0x666666];
        _gradePickerView.imageView.image =  [UIImage imageNamed:@"AT_SelectTeacher_FilterIcon_Normal"];
        [_gradePickerView.imageView sizeToFit];
        _gradePickerView.normalImage = [UIImage imageNamed:@"AT_SelectTeacher_FilterIcon_Normal"];
        _gradePickerView.selectedImage = [UIImage imageNamed:@"AT_SelectTeacher_FilterIcon_Selected"];
        _gradePickerView.normalTitleColor = [UIColor colorWithHex:0x666666];
        _gradePickerView.selectedTitleColor = kAPPMainColor;
        _gradePickerView.imageView.centerY = _gradePickerView.height*.5f;
        __weak typeof(self) weakSelf = self;
        _gradePickerView.tapedBlock = ^() {
            [weakSelf gradePickerTouched];
        };
        NSInteger index = [self.selectGradeIdArr indexOfObject:@(self.currentSelectGrade)];
        [self updateGradePickerWithTitle:[self.selectGradeArr objectAtIndexSafely:index]];
    }
    return _gradePickerView;
}

- (ZYBButtonsPickerView *)subjectPickerView{
    if (!_subjectPickerView) {
        _subjectPickerView = [[ZYBButtonsPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        _subjectPickerView.backgroundColor = [UIColor whiteColor];
        _subjectPickerView.itemFont = [UIFont systemFontOfSize:12];
        _subjectPickerView.numberOfColumns = 3;
        _subjectPickerView.itemSize = CGSizeMake(floorf((self.view.width - 30 - 10 * 2) / 3), 30);
        _subjectPickerView.edgeInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _subjectPickerView.delegate = self;
    }
    return _subjectPickerView;
}

- (ZYBPickerViewShowContainerView *)showContainerView{
    if (!_showContainerView) {
        _showContainerView = [[ZYBPickerViewShowContainerView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
        _showContainerView.shouldDismissTouchBg = YES;
        __weak typeof(self) weakSelf = self;
        _showContainerView.bgTouchBlock = ^ (BOOL result) {
            [weakSelf pickerViewDismiss];
        };
    }
    return _showContainerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
