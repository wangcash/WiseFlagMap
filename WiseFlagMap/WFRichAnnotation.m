//
//  WFRichAnnotation.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-15.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFRichAnnotation.h"
#import "WFImageAnnotation.h"
#import "WFTextAnnotation.h"
#import "WFShape.h"

#import "WFDebug.h"

@interface WFRichAnnotation ()
{
  WFAnnotation<WFAnnotation> * _main;
  WFAnnotation<WFAnnotation> * _addition;
  
  CGPoint pointRight;
  CGPoint pointBottom;
  CGPoint pointLeft;
  CGPoint pointTop;
  
  CGRect  rectRight;
  CGRect  rectBottom;
  CGRect  rectLeft;
  CGRect  rectTop;
  
  kWFRichAnnotationAddition additionPosition;
  CGFloat                   additionScale;
}
@end

@implementation WFRichAnnotation

@synthesize main = _main, addition = _addition;

#pragma mark - init & dealloc

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point image:(UIImage *)image title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color
{
  self = [super initWithID:ID atPoint:point alignment:kWFAlignmentCenter];
  if (self) {
    _main = [[WFImageAnnotation alloc] initWithID:ID atPoint:point alignment:kWFAlignmentCenter image:image];
    
    //计算主标注左上角坐标点
    CGPoint pointTopLeft = CGPointConvert(point, [_main boundSize], kWFAlignmentCenter);
    
    pointRight  = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentRightMiddle);
    _addition = [[WFTextAnnotation alloc] initWithID:ID atPoint:pointRight alignment:kWFAlignmentLeftMiddle title:title];
  }
  return self;
}

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point image:(UIImage *)image title:(NSString *)title
{
  return [self initWithID:ID atPoint:point image:image title:title titleFont:WFAnnotationDefaultFont titleColor:WFAnnotationDefaultFontColor];
}

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape image:(UIImage *)image title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color
{
  WFShape<WFShape> *areaShape = (WFShape<WFShape> *)shape;
  self = [super initWithID:ID inAreaShape:shape alignment:kWFAlignmentCenter];
  if (self) {
    _main = [[WFImageAnnotation alloc] initWithID:ID inAreaShape:shape alignment:kWFAlignmentCenter image:image];
    
    //计算主标注左上角坐标点
    CGPoint pointTopLeft = CGPointConvert(areaShape.centerPoint, [_main boundSize], kWFAlignmentCenter);
    
    pointRight  = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentRightMiddle);
    _addition = [[WFTextAnnotation alloc] initWithID:ID atPoint:pointRight alignment:kWFAlignmentLeftMiddle title:title];
  }
  return self;
}
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape image:(UIImage *)image title:(NSString *)title
{
  return [self initWithID:ID  inAreaShape:shape image:image title:title titleFont:WFAnnotationDefaultFont titleColor:WFAnnotationDefaultFontColor];
}


- (void)dealloc
{
  [_main release], _main = nil;
  [_addition release], _addition = nil;
  [super dealloc];
}

#pragma mark - bound & draw

- (CGSize)boundSize
{
  return CGSizeMake([_addition boundSize].width * 2 + [_main boundSize].width, [_addition boundSize].height * 2 + [_main boundSize].height);
}

- (CGAngleRect)boundRectAtScale:(CGFloat)scale
{
  CGRect rect;
  rect.size   = [self boundSize];
  rect.origin = CGPointOffset(CGPointScale(self.point, scale), [self boundSize], kWFAlignmentCenter);
  return CGAngleRectMake(rect, 0);
}

- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale
{
  CGRect rect = [self boundRectAtScale:scale].rect;
  return CGRectIntersectsRect(bound, rect);
}

- (void)drawAnnotation:(CGContextRef)context atScale:(CGFloat)scale hitTester:(WFHitTester *)hitTester
{
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  //  NSLog(@"%s", __FUNCTION__);
  CGContextSaveGState(context);
  
  CGContextSetStrokeColorWithColor(context, [UIColor brownColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, [self boundRectAtScale:scale].rect);
  CGContextStrokePath(context);
  
  CGContextRestoreGState(context);
#endif
  CGContextSaveGState(context);
  
  if ([hitTester hitTest:[_main boundRectAtScale:scale].rect textKey:self.ID]) {
    //主标注发生碰撞，立即返回。
    return;
  }
  
  //计算主标注左上角坐标点
  CGPoint pointTopLeft = [_main boundRectAtScale:scale].rect.origin;
  
  //计算主标注边框的关键点
  pointRight  = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentRightMiddle);
  pointBottom = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentBottomMiddle);
  pointLeft   = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentLeftMiddle);
  pointTop    = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentTopMiddle);
  
  //计算附加标注边框矩形，用于碰撞检测
  rectRight.origin  = CGPointConvert(pointRight, [_addition boundSize], kWFAlignmentLeftMiddle);
  rectRight.size    = [_addition boundSize];
  rectBottom.origin = CGPointConvert(pointBottom, [_addition boundSize], kWFAlignmentTopMiddle);
  rectBottom.size   = [_addition boundSize];
  rectLeft.origin   = CGPointConvert(pointLeft, [_addition boundSize], kWFAlignmentRightMiddle);
  rectLeft.size     = [_addition boundSize];
  rectTop.origin    = CGPointConvert(pointTop, [_addition boundSize], kWFAlignmentBottomMiddle);
  rectTop.size      = [_addition boundSize];
  
  //在缩放比例改变后重置附加坐标位置
  if (additionScale != scale) {
    additionPosition = kWFRichAnnotationAdditionNone;
  }
  
  //根据记录的附加标注位置直接显示
  switch (additionPosition) {
    case kWFRichAnnotationRightAddition:
      [_main drawAnnotation:context atScale:scale];
      [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointRight alignment:kWFAlignmentLeftMiddle];
      return;
    case kWFRichAnnotationBottomAddition:
      [_main drawAnnotation:context atScale:scale];
      [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointBottom alignment:kWFAlignmentTopMiddle];
      return;
    case kWFRichAnnotationLeftAddition:
      [_main drawAnnotation:context atScale:scale];
      [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointLeft alignment:kWFAlignmentRightMiddle];
      return;
    case kWFRichAnnotationTopAddition:
      [_main drawAnnotation:context atScale:scale];
      [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointTop alignment:kWFAlignmentBottomMiddle];
      return;
    case kWFRichAnnotationAdditionNone:
      break;
  }
  
  if ([hitTester hitTest:rectRight textKey:self.ID] == NO) {
    //绘制主标注
    [_main drawAnnotation:context atScale:scale];
    [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointRight alignment:kWFAlignmentLeftMiddle];
    
    [hitTester addHitTestRect:[_main boundRectAtScale:scale].rect textKey:self.ID];
    [hitTester addHitTestRect:rectRight textKey:self.ID];
    
    //记录附加标注位置和当前缩放比例
    additionPosition = kWFRichAnnotationRightAddition;
    additionScale    = scale;
  }
  else if ([hitTester hitTest:rectBottom textKey:self.ID] == NO) {
    //绘制主标注
    [_main drawAnnotation:context atScale:scale];
    [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointBottom alignment:kWFAlignmentTopMiddle];
    
    [hitTester addHitTestRect:[_main boundRectAtScale:scale].rect textKey:self.ID];
    [hitTester addHitTestRect:rectBottom textKey:self.ID];
    
    //记录附加标注位置和当前缩放比例
    additionPosition = kWFRichAnnotationBottomAddition;
    additionScale    = scale;
  }
  else if ([hitTester hitTest:rectLeft textKey:self.ID] == NO) {
    //绘制主标注
    [_main drawAnnotation:context atScale:scale];
    [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointLeft alignment:kWFAlignmentRightMiddle];
    
    [hitTester addHitTestRect:[_main boundRectAtScale:scale].rect textKey:self.ID];
    [hitTester addHitTestRect:rectLeft textKey:self.ID];
    
    //记录附加标注位置和当前缩放比例
    additionPosition = kWFRichAnnotationLeftAddition;
    additionScale    = scale;
  }
  else if ([hitTester hitTest:rectTop textKey:self.ID] == NO) {
    //绘制主标注
    [_main drawAnnotation:context atScale:scale];
    [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointTop alignment:kWFAlignmentBottomMiddle];
    
    [hitTester addHitTestRect:[_main boundRectAtScale:scale].rect textKey:self.ID];
    [hitTester addHitTestRect:rectTop textKey:self.ID];
    
    //记录附加标注位置和当前缩放比例
    additionPosition = kWFRichAnnotationTopAddition;
    additionScale    = scale;
  }
  
  CGContextRestoreGState(context);
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
  CGContextSaveGState(context);
  
  CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, [self boundRectAtScale:scale].rect);
  NSLog(@"boundRectAtScale:%@", NSStringFromCGRect([self boundRectAtScale:scale].rect));
  CGContextStrokePath(context);
  
  CGContextRestoreGState(context);
#endif
  CGContextSaveGState(context);
  
  //绘制主标注
  [_main drawAnnotation:context atScale:scale];
  NSLog(@"boundRectAtScale:%@", NSStringFromCGRect([_main boundRectAtScale:scale].rect));
  
  //计算主标注左上角坐标点
  CGPoint pointTopLeft = [_main boundRectAtScale:scale].rect.origin;
  
  //计算主标注边框的关键点
  pointRight  = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentRightMiddle);
  pointBottom = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentBottomMiddle);
  pointLeft   = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentLeftMiddle);
  pointTop    = CGPointReconvert(pointTopLeft, [_main boundSize], kWFAlignmentTopMiddle);
  
  [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointRight alignment:kWFAlignmentLeftMiddle];
  [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointBottom alignment:kWFAlignmentTopMiddle];
  [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointLeft alignment:kWFAlignmentRightMiddle];
  [((WFTextAnnotation *)_addition) drawAnnotation:context atPoint:pointTop alignment:kWFAlignmentBottomMiddle];
  
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
