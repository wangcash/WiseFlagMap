//
//  WFRect.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFRect.h"

@implementation WFRect

@synthesize x = _x, y = _y, width = _width, height = _height;

- (id)init
{
  self = [super init];
  if (self) {
    self.x      = 0.0f;
    self.y      = 0.0f;
    self.width  = 0.0f;
    self.height = 0.0f;
  }
  return self;
}

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity x:(NSString *)x y:(NSString *)y width:(NSString *)width height:(NSString *)height
{
  self = [super initWithID:ID
                    stroke:stroke 
               strokeWidth:strokeWidth 
          strokeMiterlimit:strokeMiterLimit 
                      fill:fill 
                   opacity:opacity];
  if (self) {
    self.x      = [x floatValue];
    self.y      = [y floatValue];
    self.width  = [width floatValue];
    self.height = [height floatValue];
  }
  return self;
}

- (CGRect)CGRect
{
  return CGRectMake(_x, _y, _width, _height);
}

- (NSString *)TAG
{
  return @"rect";
}

- (BOOL)isInBound:(CGRect)bound
{
  CGRect rect = CGRectMake(_x, _y, _width, _height);
  return CGRectIntersectsRect(bound, rect);
}

- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale
{
  CGRect rect = CGRectMake(_x * scale, _y * scale, _width * scale, _height * scale);
  return CGRectIntersectsRect(bound, rect);
}

- (BOOL)isPointInShape:(CGPoint)point
{
  return (point.x >= self.x && point.x <= self.x + self.width) && (point.y >= self.y && point.y <= self.y + self.height);
}

- (void)drawShape:(CGContextRef)context atScale:(CGFloat)scale
{
  CGRect rect = CGRectMake(_x * scale, _y * scale, _width * scale, _height * scale);
  
//  CGAffineTransform transform;
//  transform = CGAffineTransformMakeScale(scale, scale);
//  transform = CGAffineTransformMakeRotation(M_PI_4);
//  transform = CGAffineTransformMakeTranslation(10, 10)
//  CGRect rect = CGRectApplyAffineTransform(CGRectMake(_x, _y, _width, _height), transform);
  
  CGContextSaveGState(context);
  
  if (self.fill != nil) {
    CGContextSetFillColorWithColor(context, self.fill.CGColor);
    CGContextFillRect(context, rect);
  }
  
  if (self.stroke != nil) {
    CGContextSetStrokeColorWithColor(context, self.stroke.CGColor);
    if (scale < 1) {
      CGContextSetLineWidth(context, self.stroke_width * scale);
    }
    else {
      CGContextSetLineWidth(context, self.stroke_width);
    }
    CGContextAddRect(context, rect);
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

- (CGPoint)centerPoint
{
  return CGPointMake(CGRectGetMidX(self.CGRect), CGRectGetMidY(self.CGRect));
}

//TODO:待实现(临时算法)
- (CGAngleRect)insideRect
{
  CGAngleRect arect = CGAngleRectMake(CGRectMake(_x, _y, _width, _height), 0);
  return arect;
}

//TODO:待实现(临时算法)
- (CGAngleRect)insideRectAtScale:(CGFloat)scale
{
  CGAngleRect arect = CGAngleRectMake(CGRectMake(_x * scale, _y * scale, _width * scale, _height * scale), 0);
  return arect;
}

//TODO:待实现(临时算法)
- (CGAngleRect)outsideRect
{
  return [self insideRect];
}
@end