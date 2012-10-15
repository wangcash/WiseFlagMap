//
//  NSString+DrawPlus.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-3.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "NSString+DrawPlus.h"
#import "WFGeometry.h"

@implementation NSString (DrawPlus)

- (CGRect)rectWithCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  return CGRectMake(point.x - (size.width / 2), point.y - (size.height / 2), size.width, size.height);
}

- (CGSize)drawAtCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  CGPoint centerPoint = CGPointMake(point.x - (size.width / 2), point.y - (size.height / 2));
//  CGPoint centerPoint = CGPointReconvert(point, size, kWFAlignmentCenter);
  [self drawAtPoint:centerPoint withFont:font];
  return size;
}

- (CGRect)rectWithTopCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  return CGRectMake(point.x - (size.width / 2), point.y, size.width, size.height);
}

- (CGSize)drawAtTopCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  CGPoint centerPoint = CGPointMake(point.x - (size.width / 2), point.y);
  [self drawAtPoint:centerPoint withFont:font];
  return size;
}

- (CGRect)rectWithBottomCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  return CGRectMake(point.x - (size.width / 2), point.y - size.height, size.width, size.height);
}
- (CGSize)drawAtBottomCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  CGPoint centerPoint = CGPointMake(point.x - (size.width / 2), point.y - size.height);
  [self drawAtPoint:centerPoint withFont:font];
  return size;
}


- (CGRect)rectWithLeftCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  return CGRectMake(point.x, point.y - (size.height / 2), size.width, size.height);
}
- (CGSize)drawAtLeftCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  CGPoint centerPoint = CGPointMake(point.x, point.y - (size.height / 2));
  [self drawAtPoint:centerPoint withFont:font];
  return size;
}

- (CGRect)rectWithRightCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  return CGRectMake(point.x - size.width, point.y - (size.height / 2), size.width, size.height);
}
- (CGSize)drawAtRightCenterPoint:(CGPoint)point withFont:(UIFont *)font
{
  CGSize size = [self sizeWithFont:font];
  CGPoint centerPoint = CGPointMake(point.x - size.width, point.y - (size.height / 2));
  [self drawAtPoint:centerPoint withFont:font];
  return size;
}


@end
