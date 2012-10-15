//
//  WFCircle.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFCircle.h"

@implementation WFCircle

@synthesize cx = _cx, cy = _cy, r = _r;

- (id)init
{
  self = [super init];
  if (self) {
    self.cx = 0.0f;
    self.cy = 0.0f;
    self.r  = 0.0f;
  }
  return self;
}

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity cx:(NSString *)cx cy:(NSString *)cy r:(NSString *)r
{
  self = [super initWithID:ID
                    stroke:stroke 
               strokeWidth:strokeWidth 
          strokeMiterlimit:strokeMiterLimit 
                      fill:fill 
                   opacity:opacity];
  if (self) {
    self.cx = [cx floatValue];
    self.cy = [cy floatValue];
    self.r  = [r  floatValue];
  }
  return self;
}

- (NSString *)TAG
{
  return @"circle";
}

//TODO:待测试
- (BOOL)isInBound:(CGRect)bound
{
  if ((_cx + _r > bound.origin.x && _cx - _r < bound.origin.x + bound.size.width)
      && (_cy + _r > bound.origin.y && _cy - _r < bound.size.height)) {
    return YES;
  }
  return NO;
}

//TODO:待测试
- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale
{
  if ((_cx * scale + _r * scale > bound.origin.x && _cx * scale - _r * scale < bound.origin.x + bound.size.width)
      && (_cy * scale + _r * scale > bound.origin.y && _cy * scale - _r * scale < bound.size.height)) {
    return YES;
  }
  return NO;
}

//TODO:待测试
- (BOOL)isPointInShape:(CGPoint)point
{
  return sqrt((point.x - _cx) * (point.x - _cx) + (point.y - _cy) * (point.y - _cy)) <= _r;
}

//TODO:待实现
- (void)drawShape:(CGContextRef)context atScale:(CGFloat)scale
{
  CGContextSaveGState(context);
  
  //  if (self.fill != nil) {
  //    CGContextSetFillColorWithColor(context, self.fill.CGColor);
  //    CGContextFillRect(context, rect);
  //  }
  //  
  //  if (self.stroke != nil) {
  //    CGContextSetStrokeColorWithColor(context, self.stroke.CGColor);
  //    CGContextSetLineWidth(context, self.stroke_width * scale);
  //    CGContextAddRect(context, rect);
  //    CGContextStrokePath(context);
  //  }
  
  CGContextRestoreGState(context);
}

//TODO:待实现
- (BOOL)drawShape:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale
{
  if ([self isInBound:bound atScale:scale]) {
    [self drawShape:context atScale:scale];
    return YES;
  }
  return NO;
}

//TODO:待实现
- (CGAngleRect)insideRect
{
  CGAngleRect arect;
  return arect;
}

//TODO:待实现
- (CGAngleRect)insideRectAtScale:(CGFloat)scale
{
  CGAngleRect arect;
  return arect;
}

//TODO:待实现
- (CGAngleRect)outsideRect
{
  CGAngleRect arect;
  return arect;
}

@end