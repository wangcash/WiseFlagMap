//
//  WFUserMap.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFUserMap.h"

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

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define NAV_WISEFLAGS        @"Navigation_WiseFlags"
#define NAV_CITYPOINT_START  @"Navigation_CityPointForStart"
#define NAV_CITYPOINT_END    @"Navigation_CityPointForEnd"

#define NAV_PATHLINE_WIDTH   (4.0f)
#define NAV_PATHLINE_CAP     kCGLineCapRound
#define NAV_PATHLINE_COLOR   RGBA(50.0f, 255.0f, 2.0f, 1.0f)
#define NAV_PATHLINE_COLOR2  RGBA(50.0f, 255.0f, 2.0f, 0.2f)


@interface WFUserMap ()
{
//  NSArray  * _wiseflags;    //WiseFlagMap中的所有路牌。
//  NSArray  * _wiseflagPaths;//WiseFlagMap中的所有路径。
  NSMutableDictionary * _dataDict;
  
  NSArray  * _shapes;       //UserMap中的所有图形。
  NSArray  * _annotations;  //UserMap中的所有标注。
}
@end

@implementation WFUserMap

static WFUserMap *g_UserMap = nil;

+ (WFUserMap *)sharedInstance
{
  if (g_UserMap == nil) {
    g_UserMap = [[self alloc] init];
  }
  return g_UserMap;
}

- (id)init
{
  self = [super init];
  if (self) {
    _dataDict = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_dataDict release], _dataDict = nil;
  [_shapes release], _shapes = nil;
  [_annotations release], _annotations = nil;
  [super dealloc];
}

- (void)generateShapesForMapClip:(WFMapClip *)mapClip
{
  NSMutableArray *shapes = [[NSMutableArray alloc] init];
  
  /**
   * 导航路线图形生成
   */
  WFCityPoint *startCityPoint = [_dataDict objectForKey:NAV_CITYPOINT_START];
  WFCityPoint *endCityPoint = [_dataDict objectForKey:NAV_CITYPOINT_END];
  NSArray     *wiseflags = [_dataDict objectForKey:NAV_WISEFLAGS];
  //检查是否具备绘制图形的条件
  if (wiseflags != nil && startCityPoint != nil && endCityPoint != nil) {
    if (wiseflags.count == 0) {
      //路牌列表为空，直接绘制起点到终点的路径
      WFCityPoint *start = startCityPoint;
      WFCityPoint *end = endCityPoint;
      
      WFLine *line = [[WFLine alloc] init];
      line.x1 = start.CGPoint.x;
      line.y1 = start.CGPoint.y;
      line.x2 = end.CGPoint.x;
      line.y2 = end.CGPoint.y;
      
      line.stroke_width = NAV_PATHLINE_WIDTH;
      line.lineCap = NAV_PATHLINE_CAP;
      
      //根据绘图点的所属MapClip来显示颜色
      if ([start.mapClipID isEqualToString:mapClip.ID] && [end.mapClipID isEqualToString:mapClip.ID]) {
        line.stroke = NAV_PATHLINE_COLOR;
      }
      else {
        line.stroke = NAV_PATHLINE_COLOR2;
      }
      
      [shapes addObject:line];
      [line release];
    }
    else {
      //路径列表有路牌
      
      WFCityPoint *start = startCityPoint;
      WFCityPoint *end = nil;
      
      for (WFWiseFlag *wiseflag in wiseflags) {
        end = wiseflag.cityPoint;
        
        WFLine *line = [[WFLine alloc] init];
        line.x1 = start.CGPoint.x;
        line.y1 = start.CGPoint.y;
        line.x2 = end.CGPoint.x;
        line.y2 = end.CGPoint.y;
        
        line.stroke_width = NAV_PATHLINE_WIDTH;
        line.lineCap = NAV_PATHLINE_CAP;
        
        //根据绘图点的所属MapClip来显示颜色
        if ([start.mapClipID isEqualToString:mapClip.ID] && [end.mapClipID isEqualToString:mapClip.ID]) {
          line.stroke = NAV_PATHLINE_COLOR;
        }
        else {
          line.stroke = NAV_PATHLINE_COLOR2;
        }
        
        [shapes addObject:line];
        [line release];

        start = wiseflag.cityPoint;
      }
      
      //绘制最后一段路径
      end = endCityPoint;
      
      WFLine *line = [[WFLine alloc] init];
      line.x1 = start.CGPoint.x;
      line.y1 = start.CGPoint.y;
      line.x2 = end.CGPoint.x;
      line.y2 = end.CGPoint.y;
      
      line.stroke_width = NAV_PATHLINE_WIDTH;
      line.lineCap = NAV_PATHLINE_CAP;
      
      //根据绘图点的所属MapClip来显示颜色
      if ([start.mapClipID isEqualToString:mapClip.ID] && [end.mapClipID isEqualToString:mapClip.ID]) {
        line.stroke = NAV_PATHLINE_COLOR;
      }
      else {
        line.stroke = NAV_PATHLINE_COLOR2;
      }
      
      [shapes addObject:line];
      [line release];
    }
  }
  
  _shapes = [shapes retain];
  [shapes release];
}

- (void)generateAnnotationsForMapClip:(WFMapClip *)mapClip
{
  NSMutableArray *annotations = [[NSMutableArray alloc] init];
  
  /**
   * 导航路线起点标注
   */
  WFCityPoint *startCityPoint = [_dataDict objectForKey:NAV_CITYPOINT_START];
  if (startCityPoint != nil) {
    WFAnnotation *annotation = [[WFImageAnnotation alloc] initWithID:@"NAV_STAET" 
                                                             atPoint:startCityPoint.CGPoint 
                                                           alignment:kWFAlignmentBottomMiddle 
                                                               image:[UIImage imageNamed:@"icon_nav_start.png"]];
    //根据标注点的所属MapClip来进行透明
    if (![startCityPoint.mapClipID isEqualToString:mapClip.ID]) {
      annotation.alpha = 0.2f;
    }
    [annotations addObject:annotation];
    [annotation release];
  }
  
  /**
   * 导航路线终点标注
   */
  WFCityPoint *endCityPoint = [_dataDict objectForKey:NAV_CITYPOINT_END];
  if (endCityPoint != nil) {
    WFAnnotation *annotation = [[WFImageAnnotation alloc] initWithID:@"NAV_END" 
                                                             atPoint:endCityPoint.CGPoint 
                                                           alignment:kWFAlignmentBottomMiddle 
                                                               image:[UIImage imageNamed:@"icon_nav_end.png"]];
    //根据标注点的所属MapClip来进行透明
    if (![endCityPoint.mapClipID isEqualToString:mapClip.ID]) {
      annotation.alpha = 0.2f;
    }
    [annotations addObject:annotation];
    [annotation release];
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

- (void)showNavigation:(NSArray *)wiseflagArray startCityPoint:(WFCityPoint *)start endCityPoint:(WFCityPoint *)end
{
  [_dataDict setObject:wiseflagArray forKey:NAV_WISEFLAGS];
  [_dataDict setObject:start forKey:NAV_CITYPOINT_START];
  [_dataDict setObject:end forKey:NAV_CITYPOINT_END];
}

@end
