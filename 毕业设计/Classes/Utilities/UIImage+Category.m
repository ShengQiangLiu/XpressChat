//
//  UIImage+Category.m
//  签单保
//
//  Created by admin on 15-4-2.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

//#pragma mark 加载全屏的图片
//// new_feature_1.png
//+ (UIImage *)fullscrennImage:(NSString *)imgName
//{
//    // 1.如果是iPhone5，对文件名特殊处理
//    if (iPhone5) {
//        imgName = [imgName fileAppend:@"-568h@2x"];
//    }
//    
//    // 2.加载图片
//    return [self imageNamed:imgName];
//}

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName
{
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

+ (UIImage *)drawImageWithColor:(UIColor *)color withSize:(CGSize)imgSize {
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    CGContextAddRect(context, CGRectMake(0, 0, imgSize.width, imgSize.height));
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
