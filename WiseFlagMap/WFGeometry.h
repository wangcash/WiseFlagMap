//
//  WFGeometry.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-9.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#ifndef WiseFlagMap_WFGeometry_h
#define WiseFlagMap_WFGeometry_h

#include <CoreGraphics/CGBase.h>
#include <CoreFoundation/CFDictionary.h>
#include <CoreGraphics/CGGeometry.h>

/* Angle Rectangles. */

struct CGAngleRect {
  CGRect rect;
  CGFloat angle;
};
typedef struct CGAngleRect CGAngleRect;

typedef enum {
  kWFAlignmentTopLeft = 0,  //左上角
  kWFAlignmentTopMiddle,    //上边中点
  kWFAlignmentTopRight,     //右上角
  kWFAlignmentBottomLeft,   //左下角
  kWFAlignmentBottomMiddle, //下边中点
  kWFAlignmentBottomRight,  //右下角
  kWFAlignmentLeftMiddle,   //左边中点
  kWFAlignmentRightMiddle,  //右边中点
  kWFAlignmentCenter        //中心对齐
} kWFAlignment;

CG_INLINE CGAngleRect
CGAngleRectMake(const CGRect rect, const CGFloat angle)
{
  CGAngleRect ar;
  ar.rect = rect; ar.angle = angle;
  return ar;
}

//CG_INLINE CGAngleRect
//CGAngleRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height, CGFloat angle)
//{
//  CGAngleRect anglerect;
//  anglerect.rect.origin.x = x; anglerect.rect.origin.y = y;
//  anglerect.rect.size.width = width; anglerect.rect.size.height = height;
//  anglerect.angle = angle;
//  return anglerect;
//}

CG_INLINE CGPoint
CGPointScale(const CGPoint point, const CGFloat scale)
{
  CGPoint p;
  p.x = point.x * scale; p.y = point.y * scale;
  return p;
}

CG_INLINE CGSize
CGSizeScale(const CGSize size, const CGFloat scale)
{
  CGSize s;
  s.width = size.width * scale; s.height = size.height * scale;
  return s;
}

CG_INLINE CGRect
CGRectScale(const CGRect rect, const CGFloat scale)
{
  CGRect r;
  r.origin = CGPointScale(rect.origin, scale);
  r.size   = CGSizeScale(rect.size, scale);
  return r;
}

CG_INLINE CGPoint
CGPointDescale(const CGPoint point, const CGFloat scale)
{
  if (scale == 0.0f) return point;
  CGPoint p;
  p.x = point.x / scale; p.y = point.y / scale;
  return p;
}

CG_INLINE CGSize
CGSizeDescale(const CGSize size, const CGFloat scale)
{
  if (scale == 0.0f) return size;
  CGSize s;
  s.width = size.width / scale; s.height = size.height / scale;
  return s;
}

CG_INLINE CGRect
CGRectDescale(const CGRect rect, const CGFloat scale)
{
  if (scale == 0.0f) return rect;
  CGRect r;
  r.origin = CGPointDescale(rect.origin, scale);
  r.size   = CGSizeDescale(rect.size, scale);
  return r;
}

CG_INLINE CGPoint
CGRectCenterPoint(const CGRect rect)
{
  return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/**
 * 基于中心点放大
 */
CG_INLINE CGRect
CGRectScaleAtCenterPoint(const CGRect rect, const CGFloat scale)
{
  CGRect r;
  r.origin = CGPointDescale(rect.origin, scale/2);
  r.size   = CGSizeScale(rect.size, scale);
  return r;
}

/**
 * 坐标点转换，根据一个坐标点point和对齐方式alignment计算偏移后的坐标点。
 */
CG_INLINE CGPoint
CGPointConvert(const CGPoint point, const CGSize size, kWFAlignment alignment)
{
  CGPoint offset;
  switch (alignment) {
    case kWFAlignmentTopLeft:
      offset = CGPointMake(point.x, point.y);
      break;
    case kWFAlignmentTopMiddle:
      offset = CGPointMake(point.x - (size.width / 2), point.y);
      break;
    case kWFAlignmentTopRight:
      offset = CGPointMake(point.x - size.width, point.y);
      break;
    case kWFAlignmentLeftMiddle:
      offset = CGPointMake(point.x, point.y - (size.height / 2));
      break;
    case kWFAlignmentCenter:
      offset = CGPointMake(point.x - (size.width / 2), point.y - (size.height / 2));
      break;
    case kWFAlignmentRightMiddle:
      offset = CGPointMake(point.x - size.width, point.y - (size.height / 2));
      break;
    case kWFAlignmentBottomLeft:
      offset = CGPointMake(point.x, point.y - size.height);
      break;
    case kWFAlignmentBottomMiddle:
      offset = CGPointMake(point.x - (size.width / 2), point.y - size.height);
      break;
    case kWFAlignmentBottomRight:
      offset = CGPointMake(point.x - size.width, point.y - size.height);
      break;
  }
  return offset;
}

/**
 * 恢复坐标点转换，平移后的坐标点point和对齐方式alignment反相计算原来的坐标点。
 */
CG_INLINE CGPoint
CGPointReconvert(const CGPoint offset, const CGSize size, kWFAlignment alignment)
{
  CGPoint point;
  switch (alignment) {
    case kWFAlignmentTopLeft:
      point = CGPointMake(offset.x, offset.y);
      break;
    case kWFAlignmentTopMiddle:
      point = CGPointMake(offset.x + (size.width / 2), offset.y);
      break;
    case kWFAlignmentTopRight:
      point = CGPointMake(offset.x + size.width, offset.y);
      break;
    case kWFAlignmentLeftMiddle:
      point = CGPointMake(offset.x, offset.y + (size.height / 2));
      break;
    case kWFAlignmentCenter:
      point = CGPointMake(offset.x + (size.width / 2), offset.y + (size.height / 2));
      break;
    case kWFAlignmentRightMiddle:
      point = CGPointMake(offset.x + size.width, offset.y + (size.height / 2));
      break;
    case kWFAlignmentBottomLeft:
      point = CGPointMake(offset.x, offset.y + size.height);
      break;
    case kWFAlignmentBottomMiddle:
      point = CGPointMake(offset.x + (size.width / 2), offset.y + size.height);
      break;
    case kWFAlignmentBottomRight:
      point = CGPointMake(offset.x + size.width, offset.y + size.height);
      break;
  }
  return point;
}

/**
 * 坐标点偏移，根据一个坐标点point和对齐方式alignment计算偏移补偿后的新坐标点。
 */
CG_INLINE CGPoint
CGPointOffset(const CGPoint point, const CGSize size, kWFAlignment alignment)
{
  return CGPointConvert(point, size, alignment);
}

/**
 * 比较一个CGSize(size)是否大于另一个CGSize(other)。
 */
CG_INLINE BOOL
CGSizeLarger(const CGSize size, const CGSize other)
{
  if (size.width > other.width && size.height > other.height) {
    return YES;
  }
  else {
    return NO;
  }
}

/**
 * 比较一个CGSize(size)是否小于另一个CGSize(other)。
 */
CG_INLINE BOOL
CGSizeSmaller(const CGSize size, const CGSize other)
{
  if (size.width < other.width || size.height < other.height) {
    return YES;
  }
  else {
    return NO;
  }
}

#endif
