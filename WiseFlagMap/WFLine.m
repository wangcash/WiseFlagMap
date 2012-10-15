//
//  WFLine.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFLine.h"

@implementation WFLine
{
  CGLineCap  _lineCap;
}

@synthesize x1 = _x1, y1 = _y1, x2 = _x2, y2 = _y2;
@synthesize lineCap = _lineCap;

- (id)init
{
  self = [super init];
  if (self) {
    self.x1 = 0.0f;
    self.y1 = 0.0f;
    self.x2 = 0.0f;
    self.y2 = 0.0f;
  }
  return self;
}

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity x1:(NSString *)x1 y1:(NSString *)y1 x2:(NSString *)x2 y2:(NSString *)y2
{
  self = [super initWithID:ID
                    stroke:stroke 
               strokeWidth:strokeWidth 
          strokeMiterlimit:strokeMiterLimit 
                      fill:fill 
                   opacity:opacity];
  if (self) {
    self.x1 = [x1 floatValue];
    self.y1 = [y1 floatValue];
    self.x2 = [x2 floatValue];
    self.y2 = [y2 floatValue];
  }
  return self;
}

- (NSString *)TAG
{
  return @"line";
}

//TODO:待实现
- (BOOL)isInBound:(CGRect)bound
{
  return YES;
}

//TODO:待实现
- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale
{
  return YES;
}

- (BOOL)isPointInShape:(CGPoint)point
{
  return NO; //线段暂时不可选中
}

- (void)drawShape:(CGContextRef)context atScale:(CGFloat)scale
{
  CGContextSaveGState(context);
  
  if (self.stroke != nil) {
    CGContextSetStrokeColorWithColor(context, self.stroke.CGColor);
    if (scale < 1) {
      CGContextSetLineWidth(context, self.stroke_width * scale);
    }
    else {
      CGContextSetLineWidth(context, self.stroke_width);
    }
    CGContextSetLineCap(context, _lineCap);
    CGContextMoveToPoint(context, _x1 * scale, _y1 * scale);
    CGContextAddLineToPoint(context, _x2 * scale, _y2 * scale);
    CGContextStrokePath(context);
  }
  
  CGContextRestoreGState(context);
}

- (BOOL)drawShape:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale
{
  if ([self isInBound:bound atScale:scale]) {
    [self drawShape:context atScale:scale];
    return YES;
  }
  return NO;
}

//TODO:待实现(临时算法)
- (CGAngleRect)insideRect
{
  CGFloat px = _x1 <= _x2 ? _x1 : _x2;
  CGFloat py = _y1 <= _y2 ? _y1 : _y2;
  CGFloat w = fabsf(_x1 - _x2);
  CGFloat h = fabsf(_y1 - _y2);
  CGAngleRect arect = CGAngleRectMake(CGRectMake(px, py, w, h), 0);
  return arect;
}

//TODO:待实现(临时算法)
- (CGAngleRect)insideRectAtScale:(CGFloat)scale
{
  CGFloat px = _x1 <= _x2 ? _x1 : _x2;
  CGFloat py = _y1 <= _y2 ? _y1 : _y2;
  CGFloat w = fabsf(_x1 - _x2);
  CGFloat h = fabsf(_y1 - _y2);
  CGAngleRect arect = CGAngleRectMake(CGRectMake(px * scale, py * scale, w * scale, h * scale), 0);
  return arect;
}

//TODO:待实现(临时算法)
- (CGAngleRect)outsideRect
{
  return [self insideRect];
}

@end