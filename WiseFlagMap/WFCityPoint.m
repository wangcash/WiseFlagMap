//
//  WFCityPoint.m
//  城市中的一个点.
//
//  Created by 汪 威 on 12-6-22.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFCityPoint.h"

@implementation WFCityPoint
{
  WFMapClip * _mapClip;
  
  NSString* _mapClipID;
  NSNumber* _x;
  NSNumber* _y;
}

@synthesize mapClipID = _mapClipID, x = _x, y = _y;
@synthesize mapClip = _mapClip;
@synthesize accuracy;

+ (WFCityPoint*)cityPointWithMapClipID:(NSString*)mapClipID x:(NSNumber*)x y:(NSNumber*)y
{
  return [[[WFCityPoint alloc] initWithMapClipID:mapClipID x:x y:y] autorelease];
}

+ (WFCityPoint*)cityPointWithMapClipID:(NSString*)mapClipID CGPoint:(CGPoint)point
{
  NSNumber* x = [NSNumber numberWithFloat:point.x];
  NSNumber* y = [NSNumber numberWithFloat:point.y];
  
  WFCityPoint* cityPoint = [[WFCityPoint alloc] initWithMapClipID:mapClipID x:x y:y];
  
  return [cityPoint autorelease];
}


- (id)initWithMapClipID:(NSString *)mapClipID x:(NSNumber*)x y:(NSNumber*)y
{
  self = [super init];
  if (self) {
    _mapClipID = [mapClipID copy];
    _x = [x copy];
    _y = [y copy];
  }
  return self;
}

- (id)initWithLongitudeE6:(NSInteger)longitudeE6 LatitudeE6:(NSInteger)latitudeE6
{
  self = [super init];
  if (self) {
    _x = [[NSNumber numberWithInteger:longitudeE6] retain];
    _y = [[NSNumber numberWithInteger:latitudeE6] retain];
  }
  return self;
}

- (void)dealloc
{
  [_mapClip release], _mapClip = nil;
  [_mapClipID release], _mapClipID = nil;
  [_x release], _x = nil;
  [_y release], _y = nil;
  [super dealloc];
}


- (NSString *)mapClipID
{
  //当前CityPoint是GeoPoint时不返回MapClipID
  if ([self isGeoPoint]) {
    return nil;
  }
  
  return _mapClipID;
}

- (WFMapClip *)mapClip
{
  if (_mapClip == nil) {
    //TODO:暂时这么实现，以后改成从缓存中拿出MapClip
    _mapClip = [WFMapClip MapClipWithMapClipID:_mapClipID];
  }
  return _mapClip;
}

- (CGPoint)CGPoint
{
  return CGPointMake(_x.floatValue, _y.floatValue);
}

- (CGFloat)distance:(WFCityPoint *)otherCityPoint
{
  if ([_mapClipID isEqualToString:otherCityPoint.mapClipID]) {
    CGFloat deltaX = _x.floatValue - otherCityPoint.x.floatValue;
    CGFloat deltaY = _y.floatValue - otherCityPoint.y.floatValue;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
  }
  else {
    return CGFLOAT_MAX;
  }
}

- (BOOL)isGeoPoint
{
  if (_mapClipID == nil) {
    return YES;
  }
  return NO;
}


//TODO:未完成
//- (WFGeoPoint *)toGeoPoint
//{
//  if ([self isGeoPoint]) {
//    return [[[WFGeoPoint alloc] initWithLongitudeE6:_x LatitudeE6:_y] autorelease];
//  }
//  else {
//    NSInteger longitudeE6;
//    NSInteger latitudeE6;
//    //TODO:从mapclip中读出偏移部分并计算出经纬度.
//    
////    MapRect mr = mapClip.getBound();
////    int longe6 = mr.getTopLeft().getLongE6()
////    + ((mr.getTopLeft().getLongE6() - mr.getBottomRight().getLongE6()) / mapClip
////       .getWidth()) * x;
////    int lane6 = mr.getTopLeft().getLanE6()
////    + ((mr.getTopLeft().getLanE6() - mr.getBottomRight().getLanE6()) / mapClip
////       .getHeight()) * y;
////    return new GeoPoint(longe6, lane6);
//    
//    return [[[WFGeoPoint alloc] initWithLongitudeE6:longitudeE6 LatitudeE6:latitudeE6] autorelease];
//  }
//}

@end
