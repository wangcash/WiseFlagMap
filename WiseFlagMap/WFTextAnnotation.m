//
//  WFTextAnnotation.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-14.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFTextAnnotation.h"
#import "WFShape.h"
#import "WFGeometry.h"

#import "WFDebug.h"

#define kWFAnnotationPointAndTitleSpace 5.0f
#define kWFTextAnnotationMarkSize       2.0f

@interface WFTextAnnotation ()
{
  NSString * _title;
  UIFont   * _titleFont;
  UIColor  * _titleColor;
}
@end

@implementation WFTextAnnotation
@synthesize title = _title, titleFont = _titleFont, titleColor = _titleColor;

#pragma mark - init & dealloc

- (id)initWithID:(NSString *)ID
         atPoint:(CGPoint)point
       alignment:(kWFAlignment)alignment
           title:(NSString *)title
       titleFont:(UIFont *)font
      titleColor:(UIColor *)color
{
  self = [super initWithID:ID atPoint:point alignment:alignment];
  if (self) {
    _title      = [title retain];
    _titleFont  = [font retain];
    _titleColor = [color retain];
  }
  return self;
}
- (id)initWithID:(NSString *)ID
         atPoint:(CGPoint)point
       alignment:(kWFAlignment)alignment
           title:(NSString *)title
       titleFont:(UIFont *)font
{
  return [self initWithID:ID
                  atPoint:point
                alignment:alignment
                    title:title
                titleFont:font
               titleColor:WFAnnotationDefaultFontColor];
}
- (id)initWithID:(NSString *)ID
         atPoint:(CGPoint)point
       alignment:(kWFAlignment)alignment
           title:(NSString *)title
{
  return [self initWithID:ID
                  atPoint:point
                alignment:alignment
                    title:title
                titleFont:WFAnnotationDefaultFont];
}

- (id)initWithID:(NSString *)ID
         atPoint:(CGPoint)point
           title:(NSString *)title
       titleFont:(UIFont *)font
      titleColor:(UIColor *)color
{
  return [self initWithID:ID
                  atPoint:point
                alignment:kWFAlignmentCenter
                    title:title
                titleFont:font
               titleColor:color];
}
- (id)initWithID:(NSString *)ID
         atPoint:(CGPoint)point
           title:(NSString *)title
       titleFont:(UIFont *)font
{
  return [self initWithID:ID
                  atPoint:point
                alignment:kWFAlignmentCenter
                    title:title
                titleFont:font];
}
- (id)initWithID:(NSString *)ID
         atPoint:(CGPoint)point
           title:(NSString *)title
{
  return [self initWithID:ID
                  atPoint:point
                alignment:kWFAlignmentCenter
                    title:title];
}

- (id)initWithID:(NSString *)ID
     inAreaShape:(id)shape
       alignment:(kWFAlignment)alignment
           title:(NSString *)title
       titleFont:(UIFont *)font
      titleColor:(UIColor *)color
{
  self = [super initWithID:ID inAreaShape:shape alignment:alignment];
  if (self) {
    _title      = [title retain];
    _titleFont  = [font retain];
    _titleColor = [color retain];
  }
  return self;
}
- (id)initWithID:(NSString *)ID
     inAreaShape:(id)shape
       alignment:(kWFAlignment)alignment
           title:(NSString *)title
       titleFont:(UIFont *)font
{
  return [self initWithID:ID
              inAreaShape:shape
                alignment:alignment
                    title:title
                titleFont:font
               titleColor:WFAnnotationDefaultFontColor];
}
- (id)initWithID:(NSString *)ID
     inAreaShape:(id)shape
       alignment:(kWFAlignment)alignment
           title:(NSString *)title
{
  return [self initWithID:ID
              inAreaShape:shape
                alignment:alignment
                    title:title
                titleFont:WFAnnotationDefaultFont];
}

- (id)initWithID:(NSString *)ID
     inAreaShape:(id)shape
           title:(NSString *)title
       titleFont:(UIFont *)font
      titleColor:(UIColor *)color
{
  return [self initWithID:ID
              inAreaShape:shape
                alignment:kWFAlignmentCenter
                    title:title
                titleFont:font
               titleColor:color];
}
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape title:(NSString *)title titleFont:(UIFont *)font
{
  return [self initWithID:ID
              inAreaShape:shape
                alignment:kWFAlignmentCenter
                    title:title
                titleFont:font];
}
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape title:(NSString *)title
{
  return [self initWithID:ID
              inAreaShape:shape
                alignment:kWFAlignmentCenter
                    title:title];
}

- (void)dealloc
{
  [_title release], _title = nil;
  [_titleFont release], _titleFont = nil;
  [_titleColor release], _titleColor = nil;
  [super dealloc];
}

#pragma mark - bound & draw

- (CGSize)boundSize
{
  return [self.title sizeWithFont:self.titleFont];
}

- (CGAngleRect)boundRectAtScale:(CGFloat)scale
{
  CGRect rect;
  if ((self.shape != nil) && CGSizeSmaller(CGSizeScale([self.shape insideRect].rect.size, scale), [self boundSize])) {
    //标注为图形标注，并且文字大于图形
    rect.size   = [self boundSize];
    rect.origin = CGPointOffset(CGPointScale(self.point, scale), [self boundSize], kWFAlignmentTopMiddle);
    rect.size.height += kWFAnnotationPointAndTitleSpace;  //
  }
  else {
    //点标注处理或图形标注且文字小于图形
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

//TODO:改造绘图方法，使用分开碰撞处理
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
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG_
//  NSLog(@"%s", __FUNCTION__);
  CGContextSaveGState(context);
  
//  CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
//  CGContextSetLineWidth(context, 1.0f);
//  CGContextAddRect(context, CGRectScale([self.shape insideRect].rect, scale));
//  CGContextStrokePath(context);

  CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, [self boundRectAtScale:scale].rect);
  CGContextStrokePath(context);
  
  CGContextRestoreGState(context);
#endif
  CGContextSaveGState(context);
  
  CGContextSetTextDrawingMode(context, kCGTextFill);
  CGContextSetFillColorWithColor(context, _titleColor.CGColor);
  
  if ((self.shape != nil) && CGSizeSmaller(CGSizeScale([self.shape insideRect].rect.size, scale), [self boundSize])) {
    //标注为图形标注，并且文字大于图形
    
    //绘制标注点
    CGContextSaveGState(context);
    CGPoint markPoint = CGPointScale(self.point, scale);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(markPoint.x-kWFTextAnnotationMarkSize, markPoint.y, kWFTextAnnotationMarkSize * 2, kWFTextAnnotationMarkSize * 2));
    CGContextRestoreGState(context);

    CGPoint stringPoint = [self boundRectAtScale:scale].rect.origin;
    stringPoint.y += kWFAnnotationPointAndTitleSpace;
    
    //**********************************************************************************************
    //给文字增加2个像素的白色描边
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    [_title drawAtPoint:stringPoint withFont:_titleFont];
    CGContextRestoreGState(context);
    //**********************************************************************************************
    
    [_title drawAtPoint:stringPoint withFont:_titleFont];
  }
  else {
    //点标注处理或图形标注且文字小于图形
    
    //**********************************************************************************************
    //给文字增加2个像素的白色描边
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    [_title drawAtPoint:[self boundRectAtScale:scale].rect.origin withFont:_titleFont];
    CGContextRestoreGState(context);
    //**********************************************************************************************
    
    [_title drawAtPoint:[self boundRectAtScale:scale].rect.origin withFont:_titleFont];
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

- (void)drawAnnotation:(CGContextRef)context atPoint:(CGPoint)point alignment:(kWFAlignment)alignment
{
  CGContextSaveGState(context);
  
  CGContextSetTextDrawingMode(context, kCGTextFill);
  CGContextSetFillColorWithColor(context, _titleColor.CGColor);
  
  //**********************************************************************************************
  //给文字增加2个像素的白色描边
  CGContextSaveGState(context);
  CGContextSetTextDrawingMode(context, kCGTextStroke);
  CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
  CGContextSetLineWidth(context, 2);
  [_title drawAtPoint:CGPointOffset(point, [self boundSize], alignment) withFont:_titleFont];
  CGContextRestoreGState(context);
  //**********************************************************************************************
  
  [_title drawAtPoint:CGPointOffset(point, [self boundSize], alignment) withFont:_titleFont];

  CGContextRestoreGState(context);
}

//纯文本标注不响应点击
- (BOOL)isPointInAnnotation:(CGPoint)point
{
  return NO;
}

@end
