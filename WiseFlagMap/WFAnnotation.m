//
//  WFAnnotation.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-8.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFAnnotation.h"
#import "WFShape.h"
#import "JSONKit.h"
#import "NSString+DrawPlus.h"
#import "UIImage+DrawPlus.h"

#import "WFDebug.h"

#define kWFAnnotationImageAndTextSpace 0.0f;

@interface WFAnnotation ()
{
  NSString         * _ID;       //标注ID
  CGPoint            _point;    //标注坐标
  kWFAlignment       _alignment;//对齐方式
  WFShape<WFShape> * _shape;    //标注图形
  
  CGFloat            _alpha;    //CG变量,透明度
  CGBlendMode        _blendMode;//CG变量
}
@end

@implementation WFAnnotation

@synthesize ID = _ID;
@synthesize point = _point, alignment = _alignment, shape = _shape;
@synthesize alpha = _alpha, blendMode = _blendMode;

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point alignment:(kWFAlignment)alignment
{
  self = [super init];
  if (self) {
    _ID        = [ID retain];
    _point     = point;
    _alignment = alignment;
    
    _blendMode = kCGBlendModeNormal;
    _alpha     = 1.0f;
  }
  return self;
}

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point
{
  return [self initWithID:ID atPoint:point alignment:kWFAlignmentBottomMiddle];
}

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape alignment:(kWFAlignment)alignment
{
  self = [self initWithID:ID atPoint:((WFShape<WFShape> *)shape).centerPoint alignment:alignment];
  if (self) {
    _shape = [shape retain];
  }
  return self;
}

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape
{
  return [self initWithID:ID inAreaShape:shape alignment:kWFAlignmentCenter];
}

- (void)dealloc
{
  [_ID release], _ID = nil;
  [_shape release], _shape = nil;
  [super dealloc];
}



@end
