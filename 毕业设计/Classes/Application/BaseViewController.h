//
//  InputBaseViewCtrl.h
//  签单保
//
//  Created by admin on 15-4-1.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong, getter=isEditing) NSString *navigationTitle; // 导航条标题
@property (nonatomic, strong, getter=isEditing) NSString *leftImgName; // 号航条左边图片
@property (nonatomic, strong, getter=isEditing) NSString *rightImgName; // 导航条右边图片
@property (nonatomic, assign) BOOL isMonitorKeyboard; // 是否根据监听keyboard

- (void)leftBtnClick:(UIButton *)sender;
- (void)rightBtnClick:(UIButton *)sender;

@end
