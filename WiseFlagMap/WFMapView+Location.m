//
//  WFMapView+Location.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-16.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFMapView+Location.h"
#import "WFLocationManager.h"
#import "WFCityPoint.h"

@implementation WFMapView (Location)

- (UIImageView *)currentLocation
{
  return (UIImageView *)_currentLocation;
}

- (CGPoint)offsetLocationPoint:(CGPoint)aPoint
{
  //计算当前缩放比例
  CGFloat scaleOfHeight = [self scaleOfHeight];
  CGFloat scaleOfWidth = [self scaleOfWidth];
  CGFloat scale = MIN(scaleOfHeight, scaleOfWidth);
  
  //按比例计算新坐标
  CGPoint newPoint = CGPointScale(aPoint, scale);
  
  //修正小比例地图居中显示后的XY轴偏移
  if ([self centerMigration].y > 0) {
    newPoint.y += [self centerMigration].y;
  }
  if ([self centerMigration].x > 0) {
    newPoint.x += [self centerMigration].x;
  }
  
  return newPoint;
}

- (void)redrawCurrentLocation
{
  if (_currentLocation != nil) {
    [_currentLocation removeFromSuperview];
    WFLocationManager *locationManager = [WFLocationManager sharedInstance];
    WFCityPoint *cityPoint = locationManager.currentCityPoint;
    CGRect frame;
    frame.origin = [self offsetLocationPoint:cityPoint.CGPoint];
    frame.size   = [self currentLocation].frame.size;
    [self currentLocation].frame = frame;
    [self addSubview:_currentLocation];
  }
}
- (void)showCurrentLocation
{
  if (_currentLocation == nil) {
    _currentLocation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UserCurrentLocation.png"]];
    [self addSubview:_currentLocation];
  }
}
- (void)hideCurrentLocation
{
  [_currentLocation removeFromSuperview];
  [_currentLocation release], _currentLocation = nil;
}



@end
