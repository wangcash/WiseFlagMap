//
//  WFWiseFlagAnnotation.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-6.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFWiseFlagAnnotation.h"
#import "WFShape.h"
#import "WFGeometry.h"

#import "WFDebug.h"

#define WiseFlagImage @"wiseflag.png"
#define WiseFlagAnnotationFontName  @"Helvetica-Bold"
#define WiseFlagAnnotationFontSize  7.0f
#define WiseFlagAnnotationFontColor [UIColor blackColor]
#define WiseFlagAnnotationFont [UIFont fontWithName:WiseFlagAnnotationFontName size:WiseFlagAnnotationFontSize]

@interface WFWiseFlagAnnotation ()
{
  UIImage  * _image;
  
  NSString * _shortName;
  NSString * _longName;
}
@end

@implementation WFWiseFlagAnnotation

@synthesize shortName = _shortName, longName = _longName;

#pragma mark - init & dealloc

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point shortName:(NSString *)shortName longName:(NSString *)longName

{
  self = [super initWithID:ID atPoint:point alignment:kWFAlignmentCenter];
  if (self) {
    _image     = [[UIImage imageNamed:WiseFlagImage] retain];
    _shortName = [shortName retain];
    _longName  = [longName retain];
  }
  return self;
}

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape shortName:(NSString *)shortName longName:(NSString *)longName
{
  self = [super initWithID:ID inAreaShape:shape alignment:kWFAlignmentCenter];
  if (self) {
    _image     = [[UIImage imageNamed:WiseFlagImage] retain];
    _shortName = [shortName retain];
    _longName  = [longName retain];
  }
  return self;
}


- (void)dealloc
{
  [_image release], _image = nil;
  [_shortName release], _shortName = nil;
  [_longName release], _longName = nil;
  [super dealloc];
}

#pragma mark - bound & draw

- (CGSize)boundSize
{
  return _image.size;
}

//TODO:图片大于图形的标注没有实现
- (CGAngleRect)boundRectAtScale:(CGFloat)scale
{
  CGRect rect;
  if ((self.shape != nil) && CGSizeSmaller(CGSizeScale([self.shape insideRect].rect.size, scale), [self boundSize])) {
    //TODO:标注为图形标注，并且图片大于图形
    rect.size   = [self boundSize];
    rect.origin = CGPointOffset(CGPointScale(self.point, scale), [self boundSize], self.alignment);
  }
  else {
    //点标注处理或图形标注且图片小于图形
    rect.size   = [self boundSize];
    rect.origin = CGPointOffset(CGPointScale(self.point, scale), [self boundSize], self.alignment);
  }
  return CGAngleRectMake(rect, 0);
}

- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale
{
  CGRect rect = [self boundRectAtScale:scale].rect;
  return CGRectIntersectsRect(bound, rect);
}

- (void)drawAnnotation:(CGContextRef)context atScale:(CGFloat)scale hitTester:(WFHitTester *)hitTester
{
  if ([hitTester hitTest:[self boundRectAtScale:scale].rect textKey:self.ID] == NO) {
    [self drawAnnotation:context atScale:scale];
    [hitTester addHitTestRect:[self boundRectAtScale:scale].rect textKey:self.ID];
  }
}

- (BOOL)drawAnnotation:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale hitTester:(WFHitTester *)hitTester
{
  if ([self isInBound:bound atScale:scale]) {
    [self drawAnnotation:context atScale:scale hitTester:hitTester];
    return YES;
  }
  return NO;
}

- (void)drawAnnotation:(CGContextRef)context atScale:(CGFloat)scale
{
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  CGContextSaveGState(context);
  
  CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, [self boundRectAtScale:scale].rect);
  CGContextStrokePath(context);
  
  CGContextRestoreGState(context);
#endif
  CGContextSaveGState(context);
  
  if ((self.shape != nil) && CGSizeSmaller(CGSizeScale([self.shape insideRect].rect.size, scale), [self boundSize])) {
    //TODO:标注为图形标注，并且图片大于图形，暂不显示
  }
  else {
    //点标注处理或图形标注且图片小于图形
    
    //绘制路牌背景图片
    [_image drawAtPoint:[self boundRectAtScale:scale].rect.origin];
    
    //计算路牌文字的偏移量
    CGPoint wiseflagNamePoint = [self boundRectAtScale:scale].rect.origin;
    if (_shortName.length <= 2) {
      wiseflagNamePoint.x += 10.5f;
    }
    else {
      wiseflagNamePoint.x += 8.5f;
    }
    wiseflagNamePoint.y += 12.0f;
    
    //绘制路牌文字
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, WiseFlagAnnotationFontColor.CGColor);
    [_shortName drawAtPoint:wiseflagNamePoint withFont:WiseFlagAnnotationFont];
    CGContextRestoreGState(context);
    
  }
  
  CGContextRestoreGState(context);
}

- (BOOL)drawAnnotation:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale
{
  if ([self isInBound:bound atScale:scale]) {
    [self drawAnnotation:context atScale:scale];
    return YES;
  }
  return NO;
}

- (BOOL)isPointInAnnotation:(CGPoint)point
{
  WFAnnotation<WFAnnotation> *annotation = (WFAnnotation<WFAnnotation> *)self;
  return CGRectContainsPoint([annotation boundRectAtScale:1.0f].rect, point);
}

@end
