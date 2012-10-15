//
//  WFWiseFlagMap.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-31.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFWiseFlagMap.h"
#import "JSONKit.h"

#import "WFWiseFlag.h"
#import "WFWiseFlagBox.h"
#import "WFFlagPath.h"
#import "WFCityPoint.h"
#import "WFShape.h"
#import "WFCircle.h"
#import "WFEclipse.h"
#import "WFRect.h"
#import "WFPolygon.h"
#import "WFPath.h"
#import "WFLine.h"
#import "WFAnnotation.h"
#import "WFTextAnnotation.h"
#import "WFImageAnnotation.h"
#import "WFRichAnnotation.h"
#import "WFWiseFlagAnnotation.h"



@interface WFWiseFlagMap ()
{
  NSArray  * _wiseflags;    //WiseFlagMap中的所有路牌。
  NSArray  * _wiseflagPaths;//WiseFlagMap中的所有路径。
  NSArray  * _shapes;       //WiseFlagMap中的所有图形。
  NSArray  * _annotations;  //WiseFlagMap中的所有标注。
}

@end

@implementation WFWiseFlagMap

/**
 * 使用测试数据初始化一个WiseFlagMap
 */
- (id)init
{
  self = [super init];
  if (self) {
    NSMutableArray *wiseflagArray = [[NSMutableArray alloc] init];
    _wiseflags = [wiseflagArray retain];
    [wiseflagArray release];
    
    NSMutableArray *wiseflagPathArray = [[NSMutableArray alloc] init];
    _wiseflagPaths = [wiseflagPathArray retain];
    [wiseflagPathArray release];
  }
  return self;
}

- (void)addWiseFlag:(id)wiseflag
{
  if (wiseflag) {
    NSMutableArray *wiseflags = (NSMutableArray *)_wiseflags;
    [wiseflags addObject:wiseflag];
  }
}

- (void)addWiseFlagPath:(id)wiseflagPath
{
  if (wiseflagPath) {
    NSMutableArray *wiseflagPaths = (NSMutableArray *)_wiseflagPaths;
    [wiseflagPaths addObject:wiseflagPath];
  }
}

- (id)initWithMapClip:(WFMapClip *)mapClip;
{
  self = [super init];
  if (self) {
    NSString *mapClipID = mapClip.ID;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:mapClipID ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    if (jsonData == nil) {
      return self;
    }
    
    NSArray *jsonObjectArray = [jsonData objectFromJSONData];
    
    //load路牌数据，构建MapClip中的路牌
    NSMutableArray *wiseflagArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < jsonObjectArray.count; i++) {
      NSDictionary *jsonObjectDict = [jsonObjectArray objectAtIndex:i];
      
      WFWiseFlag *wiseflag = [[WFWiseFlag alloc] init];
      
      wiseflag.shortName = [jsonObjectDict objectForKey:@"ShortName"];
      wiseflag.longName  = [jsonObjectDict objectForKey:@"LongName"];
      wiseflag.mac       = [jsonObjectDict objectForKey:@"MAC"];
      wiseflag.ssid      = [jsonObjectDict objectForKey:@"MAC"];
      wiseflag.ID        = [jsonObjectDict objectForKey:@"MAC"];
      //      "signalLevel":"0",
      //      "IsFake":"true",
      
      NSDictionary *cityPointDict = [jsonObjectDict objectForKey:@"cityPoint"];
      NSLog(@"MapClipID : %@", [cityPointDict objectForKey:@"MapClipID"]);
      
      NSDictionary *svgPointDict = [cityPointDict objectForKey:@"svgPoint"];
      
      NSNumber* x = [svgPointDict valueForKey:@"x"];
      NSNumber* y = [svgPointDict valueForKey:@"y"];
      
//      wiseflag.cityPoint = [[[WFCityPoint alloc] initWithMapClip:mapClip x:x.floatValue y:y.floatValue] autorelease];
      wiseflag.cityPoint = [WFCityPoint cityPointWithMapClipID:mapClipID x:x y:y];
      
      [wiseflagArray addObject:wiseflag];
      [wiseflag release];
    }
    
    _wiseflags = [wiseflagArray retain];
    
    [wiseflagArray release];
    
  }
  return self;
}

- (void)dealloc
{
  [_wiseflags   release], _wiseflags   = nil;
  [_shapes      release], _shapes      = nil;
  [_annotations release], _annotations = nil;
  [super dealloc];
}

- (void)generateShapes
{
  NSMutableArray *shapes = [[NSMutableArray alloc] init];
  
  //根据路径生成调试用的线段
  for (WFFlagPath *path in _wiseflagPaths) {
    WFLine *line = [[WFLine alloc] init];
    
    line.x1 = path.wiseflagA.cityPoint.CGPoint.x;
    line.y1 = path.wiseflagA.cityPoint.CGPoint.y;
    
    line.x2 = path.wiseflagB.cityPoint.CGPoint.x;
    line.y2 = path.wiseflagB.cityPoint.CGPoint.y;
    
    line.stroke_width = 1;
    line.stroke = [UIColor grayColor];
    
    [shapes addObject:line];
    [line release];
  }
  
  _shapes = [shapes retain];
  [shapes release];
}

- (void)generateAnnotations
{
  NSMutableArray *annotations = [[NSMutableArray alloc] init];
  
  //根据路牌生成标注
  for (NSInteger i = 0; i < _wiseflags.count; i++) {
    WFWiseFlag *wiseflag = [_wiseflags objectAtIndex:i];
    //只生成真实路牌标注
    if (wiseflag.real) {
      WFAnnotation *annotation = [[WFWiseFlagAnnotation alloc] initWithID:wiseflag.mac
                                                                  atPoint:wiseflag.cityPoint.CGPoint
                                                                shortName:wiseflag.shortName
                                                                 longName:wiseflag.longName];
      [annotations addObject:annotation];
      [annotation release];
    }
  }
  
  _annotations = [annotations retain];
  [annotations release];
}

- (NSArray *)allShapes
{
  return _shapes;
}

- (NSArray *)inBoundShapes:(CGRect)bound atScale:(CGFloat)scale
{
  NSMutableArray *shapesInBound = [[[NSMutableArray alloc] init] autorelease];
  for (NSInteger i=0; i<[_shapes count]; i++) {
    WFShape<WFShape> *shape = [_shapes objectAtIndex:i];
    if ([shape isInBound:bound atScale:scale]) {
      [shapesInBound addObject:shape];
    }
  }
  return shapesInBound;
}

- (NSArray *)allAnnotations
{
  return _annotations;
}

- (NSArray *)inBoundAnnotations:(CGRect)bound atScale:(CGFloat)scale
{
  NSMutableArray *annotationsInBound = [[[NSMutableArray alloc] init] autorelease];
  for (NSInteger i=0; i<[_annotations count]; i++) {
    WFAnnotation<WFAnnotation> *annotation = [_annotations objectAtIndex:i];
    if ([annotation isInBound:bound atScale:scale]) {
      [annotationsInBound addObject:annotation];
    }
  }
  return annotationsInBound;
}


@end
