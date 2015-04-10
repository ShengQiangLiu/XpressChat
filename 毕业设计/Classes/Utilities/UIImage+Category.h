//
//  UIImage+Category.h
//  签单保
//
//  Created by admin on 15-4-2.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
//#pragma mark 加载全屏的图片
//+ (UIImage *)fullscrennImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

#pragma mark 根据颜色绘制图片
+ (UIImage *)drawImageWithColor:(UIColor *)color withSize:(CGSize)imgSize;

@end
