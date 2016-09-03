//
//  UIButton+Bubbling.h
//  TheGIFviews
//
//  Created by 张君泽 on 16/9/2.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Bubbling)
/**
 *  根据图片随机分配颜色
 *
 *  @param image baseImage
 */
- (void)bubbingImage:(UIImage *)image;
/**
 *  多张图片中随机出现
 *
 *  @param images 图片数据
 */
- (void)bubbingImages:(NSArray *)images;
@end
