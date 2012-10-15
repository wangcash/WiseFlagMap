//
//  WFImageAnnotation.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-15.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFImageAnnotation.h"
#import "WFShape.h"
#import "WFGeometry.h"

#import "WFDebug.h"

@implementation WFImageAnnotation

@synthesize image = _image, title = _title;

#pragma mark - init & dealloc

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point alignment:(kWFAlignment)alignment image:(UIImage *)image
{
  self = [super initWithID:ID atPoint:point alignment:alignment];
  if (self) {
    _image = [image retain];
  }
  return self;
}

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point image:(UIImage *)image
{
  return [self initWithID:ID atPoint:point alignment:kWFAlignmentBottomMiddle image:image];
}

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape alignment:(kWFAlignment)alignment image:(UIImage *)image
{
  self = [super initWithID:ID inAreaShape:shape alignment:alignment];
  if (self) {
    _image = [image retain];
  }
  return self;
}

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape image:(UIImage *)image
{
  return [self initWithID:ID inAreaShape:shape alignment:kWFAlignmentCenter image:image];
}

- (void)dealloc
{
  [_image release], _image = nil;
  [super dealloc];
}

#pragma mark - bound & draw

- (CGSize)boundSize
{
  return self.image.size;
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
//  NSLog(@"%s", __FUNCTION__);
//  CGContextSaveGState(context);
//  
//  CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
//  CGContextSetLineWidth(context, 1.0f);
//  CGContextAddRect(context, [self boundRectAtScale:scale].rect);
//  CGContextStrokePath(context);
//  
//  CGContextRestoreGState(context);
#endif
  CGContextSaveGState(context);
  
  if ((self.shape != nil) && CGSizeSmaller(CGSizeScale([self.shape insideRect].rect.size, scale), [self boundSize])) {
    //TODO:标注为图形标注，并且图片大于图形，暂不显示
  }
  else {
    //点标注处理或图形标注且图片小于图形
//    [_image drawAtPoint:[self boundRectAtScale:scale].rect.origin];
    [_image drawAtPoint:[self boundRectAtScale:scale].rect.origin blendMode:self.blendMode alpha:self.alpha];
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
