//
//  InputBaseViewCtrl.m
//  签单保
//
//  Created by admin on 15-4-1.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Category.h"


#define kNavigationBackColor RGBA(120, 180, 250, 1)
#define kNavigationBarHeight CGSizeMake(self.view.frame.size.width, 64)
#define kNavigationLeftImgName @"09返回_03.png"

@interface BaseViewController ()
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation BaseViewController {
    UILabel *_navigationLable;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RGBA(240, 240, 240, 1);
    // 默认监听键盘
    _isMonitorKeyboard = YES;
    // 设置导航条的默认样式
    [self setDefaultNavigationBarStyle];
    // 添加view手势，添加view可以收起键盘
    [self addViewTap];
}


- (void)setDefaultNavigationBarStyle {
    // 导航条背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage drawImageWithColor:kNavigationBackColor withSize:kNavigationBarHeight] forBarMetrics:UIBarMetricsDefault];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [_leftBtn setImage:[UIImage imageNamed:kNavigationLeftImgName] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    self.navigationItem.leftBarButtonItem = item1;
    
}

- (void)addViewTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)stopKeyboard {
    [self.view endEditing:YES];
}

- (void)setNavigationTitle:(NSString *)navigationTitle {
    _navigationTitle = navigationTitle;
    _navigationLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    _navigationLable.textColor = [UIColor whiteColor];
    _navigationLable.textAlignment = NSTextAlignmentCenter;
    _navigationLable.text = _navigationTitle;
    self.navigationItem.titleView = _navigationLable;
}

- (void)setLeftImgName:(NSString *)leftImgName {
    _leftImgName = leftImgName;
    [_leftBtn setImage:[UIImage imageNamed:_leftImgName] forState:UIControlStateNormal];
}

- (void)setRightImgName:(NSString *)rightImgName {
    _rightImgName = rightImgName;
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [_rightBtn setImage:[UIImage imageNamed:_rightImgName] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = item2;
}

- (void)leftBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
}


- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)setIsMonitorKeyboard:(BOOL)isMonitorKeyboard {
    _isMonitorKeyboard = isMonitorKeyboard;
    if (!_isMonitorKeyboard) {
        [self removeNotification];
    }
}

// 查找第一响应者
- (UIView *)findFirstRespoinder:(UIView *)view {
    
    if ([view isFirstResponder]) {
        return view;
    }
    
    for (UIView *subView in [view subviews]) {
        if ([self findFirstRespoinder:subView]) {
            return subView; // recursion
        }
    }
    return nil;

}

- (void)didKeyboardChangeFrame:(NSNotification *)notification {
    // 不允许监听键盘的情况下
    if (!_isMonitorKeyboard) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    // 键盘尺寸
    NSValue *bFrame = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [bFrame CGRectValue];
    CGRect rect = self.view.bounds;
    
    // 键盘隐藏，视图恢复正常位置
    if (keyboardFrame.origin.y >= self.view.frame.size.height) {
        self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    } else {
        // 查找第一响应者
        UIView *activeView = [self findFirstRespoinder:self.view];
        CGFloat delta = CGRectGetMaxY(activeView.frame) - keyboardFrame.origin.y;
        // 如果键盘遮住输入框，整体上移
        if (delta > 0) {
            self.view.frame = CGRectMake(0, -delta-10, self.view.frame.size.width, self.view.frame.size.height);
        } else {
            // 恢复正常位置
            self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        }
    }
}

@end
