//
//  WFGeoPoint.m
//  地球上的经纬度坐标. 表示一个地理坐标点，存放经度和纬度，以微度的整数形式存储。 10^6 * 经纬度.
//
//  Created by 汪 威 on 12-6-22.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFGeoPoint.h"

#define kWF_1E6 (10^6)

@implementation WFGeoPoint
{
  NSInteger _longitudeE6;
  NSInteger _latitudeE6;
}

@synthesize longitudeE6 = _longitudeE6, latitudeE6 = _latitudeE6;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
  self = [super init];
  if (self) {
    _longitudeE6 = (NSInteger)(coordinate.longitude * kWF_1E6);
    _latitudeE6 = (NSInteger)(coordinate.latitude * kWF_1E6);
  }
  return self;
}

- (id)initWithLongitudeE6:(NSInteger)longitudeE6 LatitudeE6:(NSInteger)latitudeE6
{
  self = [super init];
  if (self) {
    _longitudeE6 = longitudeE6;
    _latitudeE6 = latitudeE6;
  }
  return self;
}

- (void)dealloc
{
  [super dealloc];
}

- (CLLocationCoordinate2D)coordinate
{
  CLLocationCoordinate2D coordinate;
  coordinate.longitude = _longitudeE6 / kWF_1E6;
  coordinate.latitude = _latitudeE6 / kWF_1E6;
  return coordinate;
}

@end
