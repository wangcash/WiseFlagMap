//
//  WFAreaAnnotation.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-9.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFAreaAnnotation.h"
#import "JSONKit.h"

@interface WFAreaAnnotation ()
{
  WFShape<WFShape> * _areaShape;
  CGAngleRect        _areaRect; //标注边框
}
@end

@implementation WFAreaAnnotation

@synthesize areaRect = _areaRect;

- (id)initWithID:(NSString *)ID text:(NSString *)text image:(UIImage *)image inAreaShape:(WFShape<WFShape> *)shape alignment:(kWFAlignment)alignment
{
  self = [super initWithID:ID text:text image:image atPoint:shape.centerPoint alignment:alignment];
  if (self) {
    _areaShape = [shape retain];
    self.areaRect = [shape insideRect];
  }
  return self;
}

- (id)initWithID:(NSString *)ID text:(NSString *)text image:(UIImage *)image inAreaShape:(WFShape<WFShape> *)shape
{
  return [self initWithID:ID text:text image:image inAreaShape:shape alignment:kWFAlignmentTopLeft];
}

- (void)dealloc
{
  [_areaShape release], _areaShape = nil;
  [super dealloc];
}

- (void)drawAnnotation1:(CGContextRef)context atScale:(CGFloat)scale
{
  NSLog(@"%s",__FUNCTION__);
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  CGContextSaveGState(context);
  
  CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, CGRectScale(self.areaRect.rect, scale));
  NSLog(@"areaRect:%@", NSStringFromCGRect(CGRectScale(self.areaRect.rect, scale)));
  CGContextStrokePath(context);
  
  CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, [self boundRect].rect);
  NSLog(@"boundRect:%@", NSStringFromCGRect([self boundRect].rect));
  CGContextStrokePath(context);
  
  CGContextRestoreGState(context);
#endif
  
  [super drawAnnotation:context atScale:scale];
  
//  CGContextSaveGState(context);
//  CGContextSetTextDrawingMode(context, kCGTextFillClip);
//  CGContextSetRGBFillColor(context, 0, 0, 0, 1);
  
  
  
  
//  switch (self.type) {
//    case kWFAnnotationTypeOnlyText: {
//    [self.text drawAtPoint:CGPointScale(self.point, scale) withFont:self.font];
//
//      
//      break;
//    }
//    case kWFAnnotationTypeOnlyImage: {
//      [_image drawAtPoint:_point];
//      break;
//    }
//    case kWFAnnotationTypeTextAndImage: {
//      [_image drawAtPoint:_point];
//      [_text drawAtPoint:CGPointMake(_point.x, _point.y) withFont:_font];
//      break;
//    }
//  }  
//  
//  CGContextRestoreGState(context);
}

//- (BOOL)drawAnnotation:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale
//{
//  NSLog(@"%s",__FUNCTION__);
//}



@end
