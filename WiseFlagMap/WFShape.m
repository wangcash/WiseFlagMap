//
//  WFShape.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"
#import "JSONKit.h"
#import "TBXML.h"

#import "WFCircle.h"
#import "WFEclipse.h"
#import "WFRect.h"
#import "WFPolygon.h"
#import "WFPath.h"
#import "WFLine.h"
#import "WFAnnotation.h"

@implementation WFShape
{
  NSString * _ID;           //标签ID
  UIColor  * _stroke;       //画笔颜色
  CGFloat    _stroke_width; //画笔宽度
  UIColor  * _fill;         //填充颜色
  CGFloat    _opacity;      //透明度.
  CGFloat    _stroke_miterlimit;  //指定角度的浮点值，在该角度以上，尖角的尖端将被一个线段截断。
  //这意味着只有在尖角大于 miterLimit 的值的情况下，才会截断尖角.
}

@synthesize TAG, ID = _ID, stroke = _stroke, stroke_width = _stroke_width, stroke_miterlimit = _stroke_miterlimit, fill = _fill, opacity = _opacity;

- (id)init
{
  self = [super init];
  if (self) {
    self.ID           = nil;
    self.stroke       = nil;
    self.stroke_width = 1.0f;
    self.fill         = nil;
    
    self.opacity           = 0.0f;
    self.stroke_miterlimit = 0.0f;
  }
  return self;
}

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity
{
  self = [self init];
  if (self) {
    
    //ID格式：{|k|:|DaYueChen_Fl_Jack|,|n|:|A1|,|t|:|SHOP|,|nwl|:[{|w|:|23:33:34:21:11|},{|w|:|24:33:34:21:11|}]}
    NSString *json = [ID stringByReplacingOccurrencesOfString:@"|" withString:@"\""]; //转义“|”
    NSDictionary *idDict = [json objectFromJSONString];
    //判断ID是否是JSON格式
    if (idDict.count > 0) {
      NSString *key  = [idDict objectForKey:@"k"];
      self.ID = key;
    }
    else {
      self.ID = ID;
    }
    
    if (stroke != nil) {
      self.stroke = [UIColor colorWithString:stroke];
    }
    if (strokeWidth != nil) {
      self.stroke_width = [strokeWidth integerValue];
    }
    if (fill != nil) {
      self.fill = [UIColor colorWithString:fill];
    }
    
    self.opacity           = [opacity floatValue];
    self.stroke_miterlimit = [strokeMiterLimit integerValue];
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
//    NSLog(@"id:%@ stroke:%@ stroke_width:%@ fill:%@", ID, stroke, strokeWidth, fill);
#endif
  }
  return self;
}

- (void)dealloc
{
  [_ID release];      _ID = nil;
  [_stroke release];  _stroke = nil;
  [_fill release];    _fill = nil;
  [super dealloc];
}

+ (id)shapeWithXmlElement:(id)element;
{
  id shape = nil;
  TBXMLElement *shapeElement = (TBXMLElement *)element;
  NSString *elementName = [TBXML elementName:shapeElement];
  NSString *ID = [TBXML valueOfAttributeNamed:@"id" forElement:shapeElement];
  
  if ([elementName isEqualToString:@"polygon"]) {
    shape = [[WFPolygon alloc] initWithID:ID
                                   stroke:[TBXML valueOfAttributeNamed:@"stroke" forElement:shapeElement]
                              strokeWidth:[TBXML valueOfAttributeNamed:@"stroke-width" forElement:shapeElement]
                         strokeMiterlimit:[TBXML valueOfAttributeNamed:@"stroke-miterlimit" forElement:shapeElement]
                                     fill:[TBXML valueOfAttributeNamed:@"fill" forElement:shapeElement]
                                  opacity:[TBXML valueOfAttributeNamed:@"opacity" forElement:shapeElement]
                                   points:[TBXML valueOfAttributeNamed:@"points" forElement:shapeElement]];
  }
  else if ([elementName isEqualToString:@"path"]) {
    shape = [[WFPath alloc] initWithID:[TBXML valueOfAttributeNamed:@"id" forElement:shapeElement]
                                stroke:[TBXML valueOfAttributeNamed:@"stroke" forElement:shapeElement]
                           strokeWidth:[TBXML valueOfAttributeNamed:@"stroke-width" forElement:shapeElement]
                      strokeMiterlimit:[TBXML valueOfAttributeNamed:@"stroke-miterlimit" forElement:shapeElement]
                                  fill:[TBXML valueOfAttributeNamed:@"fill" forElement:shapeElement]
                               opacity:[TBXML valueOfAttributeNamed:@"opacity" forElement:shapeElement]
                                     d:[TBXML valueOfAttributeNamed:@"d" forElement:shapeElement]];
  }
  else if ([elementName isEqualToString:@"line"]) {
    shape = [[WFLine alloc] initWithID:[TBXML valueOfAttributeNamed:@"id" forElement:shapeElement]
                                stroke:[TBXML valueOfAttributeNamed:@"stroke" forElement:shapeElement]
                           strokeWidth:[TBXML valueOfAttributeNamed:@"stroke-width" forElement:shapeElement]
                      strokeMiterlimit:[TBXML valueOfAttributeNamed:@"stroke-miterlimit" forElement:shapeElement]
                                  fill:[TBXML valueOfAttributeNamed:@"fill" forElement:shapeElement]
                               opacity:[TBXML valueOfAttributeNamed:@"opacity" forElement:shapeElement]
                                    x1:[TBXML valueOfAttributeNamed:@"x1" forElement:shapeElement]
                                    y1:[TBXML valueOfAttributeNamed:@"y1" forElement:shapeElement]
                                    x2:[TBXML valueOfAttributeNamed:@"x2" forElement:shapeElement]
                                    y2:[TBXML valueOfAttributeNamed:@"y2" forElement:shapeElement]];
  }
  else if ([elementName isEqualToString:@"circle"]) {
    shape = [[WFCircle alloc] initWithID:[TBXML valueOfAttributeNamed:@"id" forElement:shapeElement]
                                  stroke:[TBXML valueOfAttributeNamed:@"stroke" forElement:shapeElement]
                             strokeWidth:[TBXML valueOfAttributeNamed:@"stroke-width" forElement:shapeElement]
                        strokeMiterlimit:[TBXML valueOfAttributeNamed:@"stroke-miterlimit" forElement:shapeElement]
                                    fill:[TBXML valueOfAttributeNamed:@"fill" forElement:shapeElement]
                                 opacity:[TBXML valueOfAttributeNamed:@"opacity" forElement:shapeElement]
                                      cx:[TBXML valueOfAttributeNamed:@"cx" forElement:shapeElement]
                                      cy:[TBXML valueOfAttributeNamed:@"cy" forElement:shapeElement]
                                       r:[TBXML valueOfAttributeNamed:@"r" forElement:shapeElement]];
  }
  else if ([elementName isEqualToString:@"eclipse"]) {
    shape = [[WFEclipse alloc] initWithID:[TBXML valueOfAttributeNamed:@"id" forElement:shapeElement]
                                   stroke:[TBXML valueOfAttributeNamed:@"stroke" forElement:shapeElement]
                              strokeWidth:[TBXML valueOfAttributeNamed:@"stroke-width" forElement:shapeElement]
                         strokeMiterlimit:[TBXML valueOfAttributeNamed:@"stroke-miterlimit" forElement:shapeElement]
                                     fill:[TBXML valueOfAttributeNamed:@"fill" forElement:shapeElement]
                                  opacity:[TBXML valueOfAttributeNamed:@"opacity" forElement:shapeElement]
                                       cx:[TBXML valueOfAttributeNamed:@"cx" forElement:shapeElement]
                                       cy:[TBXML valueOfAttributeNamed:@"cy" forElement:shapeElement]
                                       rx:[TBXML valueOfAttributeNamed:@"rx" forElement:shapeElement]
                                       ry:[TBXML valueOfAttributeNamed:@"ry" forElement:shapeElement]];
  }
  else if ([elementName isEqualToString:@"rect"]) {
    shape = [[WFRect alloc] initWithID:[TBXML valueOfAttributeNamed:@"id" forElement:shapeElement]
                                stroke:[TBXML valueOfAttributeNamed:@"stroke" forElement:shapeElement]
                           strokeWidth:[TBXML valueOfAttributeNamed:@"stroke-width" forElement:shapeElement]
                      strokeMiterlimit:[TBXML valueOfAttributeNamed:@"stroke-miterlimit" forElement:shapeElement]
                                  fill:[TBXML valueOfAttributeNamed:@"fill" forElement:shapeElement]
                               opacity:[TBXML valueOfAttributeNamed:@"opacity" forElement:shapeElement]
                                     x:[TBXML valueOfAttributeNamed:@"x" forElement:shapeElement]
                                     y:[TBXML valueOfAttributeNamed:@"y" forElement:shapeElement]
                                 width:[TBXML valueOfAttributeNamed:@"width" forElement:shapeElement]
                                height:[TBXML valueOfAttributeNamed:@"height" forElement:shapeElement]];
  }
  else {
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
    NSLog(@"Does not support SVG tag: <%@>", elementName);
#endif
  }
  
  return [shape autorelease];
}

/**
 * 返回当前图形的中心点（内嵌最大矩形中心点）
 */
- (CGPoint)centerPoint
{
  CGPoint point;
  WFShape<WFShape> *shape = (WFShape<WFShape> *)self;
  point = CGPointMake(CGRectGetMidX([shape insideRect].rect), CGRectGetMidY([shape insideRect].rect));
  return point;
}

@end
