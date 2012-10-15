//
//  UIImage+DrawPlus.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DrawPlus)
- (void)drawAtCenterPoint:(CGPoint)point;
- (void)drawAtTopCenterPoint:(CGPoint)point;
- (void)drawAtBottomCenterPoint:(CGPoint)point;
- (void)drawAtLeftCenterPoint:(CGPoint)point;
- (void)drawAtRightCenterPoint:(CGPoint)point;
@end
