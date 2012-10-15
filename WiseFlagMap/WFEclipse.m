//
//  WFEclipse.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFEclipse.h"

@implementation WFEclipse

@synthesize cx = _cx, cy = _cy, rx = _rx, ry = _ry;

- (id)init
{
  self = [super init];
  if (self) {
    self.cx = 0.0f;
    self.cy = 0.0f;
    self.rx = 0.0f;
    self.ry = 0.0f;
  }
  return self;
}

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity cx:(NSString *)cx cy:(NSString *)cy rx:(NSString *)rx ry:(NSString *)ry
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
    self.rx = [rx floatValue];
    self.ry = [ry floatValue];
  }
  return self;
}

- (NSString *)TAG
{
  return @"ellipse";
}

//TODO:待测试
- (BOOL)isInBound:(CGRect)bound
{
  CGFloat r = fmaxf(_rx, _ry);
  if((_cx + r > bound.origin.x && _cx - r < bound.origin.x + bound.size.width) 
     && (_cy + r > bound.origin.y && _cy - r < bound.origin.y + bound.size.height)) {
    return YES;
  }
  return NO;
}

//TODO:待测试
- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale
{
  CGFloat r = fmaxf(_rx * scale, _ry * scale);
  if((_cx * scale + r > bound.origin.x && _cx * scale - r < bound.origin.x + bound.size.width) 
     && (_cy * scale + r > bound.origin.y && _cy * scale - r < bound.origin.y + bound.size.height)) {
    return YES;
  }
  return NO;
}

//TODO:待测试
- (BOOL)isPointInShape:(CGPoint)point
{
  return ((point.x-self.cx) * (point.x-self.cx)) / (self.rx * self.rx) + ((point.y-self.cy) * (point.y-self.cy)) / (self.ry * self.ry) <= 1;
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