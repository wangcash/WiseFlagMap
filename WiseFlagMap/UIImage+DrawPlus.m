//
//  UIImage+DrawPlus.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "UIImage+DrawPlus.h"

@implementation UIImage (DrawPlus)
- (void)drawAtCenterPoint:(CGPoint)point
{
  [self drawAtPoint:CGPointMake(point.x - (self.size.width / 2), point.y - (self.size.height / 2))];
}
- (void)drawAtTopCenterPoint:(CGPoint)point
{
  [self drawAtPoint:CGPointMake(point.x - (self.size.width / 2), point.y)];
}
- (void)drawAtBottomCenterPoint:(CGPoint)point
{
  [self drawAtPoint:CGPointMake(point.x - (self.size.width / 2), point.y - self.size.height)];
}
- (void)drawAtLeftCenterPoint:(CGPoint)point
{
  [self drawAtPoint:CGPointMake(point.x, point.y - (self.size.height / 2))];
}
- (void)drawAtRightCenterPoint:(CGPoint)point
{
  [self drawAtPoint:CGPointMake(point.x - self.size.width, point.y - (self.size.height / 2))];
}
@end
