//
//  WFWiseFlag.m
//  智能路牌.
//  包含
//  1 实际路牌。
//  2 室内虚拟路牌，isFake == true && .getCityPoint.isGeoPoint() == false .
//       室内虚拟路牌主要用来在地图上绘制导航路径时修正显示路径，在实际的路牌导航中不显示.       
//  3 室外虚拟路牌  isFake == true && .getCityPoint.isGeoPoint() == true .
//       室外虚拟路牌用于用户进出室内外时的衔接，当确认FlagPath路径的一端为户外虚拟路牌时，用户从此
//       路牌即可以进出室内外.  
//
//  Created by 汪 威 on 12-6-25.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFWiseFlag.h"

@implementation WFWiseFlag
{
//  NSString * _ID;
//  NSString * _mac;
//  NSString * _ssid;
//  
//  NSString * _shortName;
//  NSString * _longName;
//  
//  NSInteger _signalLevel;
//  
//  BOOL _fake;
//  
//  WFCityPoint * _cityPoint;
}

@synthesize ID = _ID, mac = _mac, ssid = _ssid;
@synthesize shortName = _shortName, longName = _longName;
@synthesize signalLevel = _signalLevel, fake = _fake;
@synthesize cityPoint = _cityPoint;

- (id)initWithMac:(NSString*)mac
{
  self = [super init];
  if (self) {
    self.mac = mac;
  }
  return self;
}

- (void)dealloc
{
  [super dealloc];
}

- (NSString*)mapClipID
{
  //无CityPoint时处理
  if (self.cityPoint == nil) {
    return nil;
  }
  
  return self.cityPoint.mapClipID;
}

- (NSString*)debugDescription
{
  return [NSString stringWithFormat:@"%@ : %@", self.mac, self.shortName];
}

- (BOOL)real
{
  return !_fake;
}


- (void)copy:(id)sender
{
  if ([sender class] == [WFWiseFlag class]) {
    WFWiseFlag* wiseflag = (WFWiseFlag*)sender;
    self.ID          = wiseflag.ID;
    self.mac         = wiseflag.mac;
    self.ssid        = wiseflag.ssid;
    self.shortName   = wiseflag.shortName;
    self.longName    = wiseflag.longName;
    self.signalLevel = wiseflag.signalLevel;
    self.fake        = wiseflag.fake;
    self.cityPoint   = wiseflag.cityPoint;
  }
}

- (BOOL)isEqual:(id)object
{
  WFWiseFlag* other = (WFWiseFlag*)object;
  if (![self.mapClipID isEqualToString:other.mapClipID]) {
    return NO;
  }
//  if (![self.ID isEqualToString:other.ID]) {
//    return NO;
//  }
  if (![self.mac isEqualToString:other.mac]) {
    return NO;
  }
  if (![self.longName isEqualToString:other.longName]) {
    return NO;
  }
  return YES;
}

@end
