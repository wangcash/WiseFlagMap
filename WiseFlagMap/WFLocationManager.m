//
//  WFLocationManager.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-8.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFLocationManager.h"
#import "WFWiFiScan.h"
#import "WFWiseFlagBox.h"
#import "WFWiseFlag.h"
#import "WFServiceManager.h"

#define highSignalValue   (-45)
#define middleSignalValue (-80)
#define lowSignalValue    (-90)

#define highSignalDistance   (3)
#define middleSignalDistance (20)
#define lowSignalDistance    (100)

static WFLocationManager * sharedLocationManager = nil;

@implementation WFLocationManager
{
  WFWiFiScan  * _scanner;
  NSTimer     * _timer;
  WFCityPoint * _currentCityPoint;
  
  float _distanceFilter;
}

@synthesize delegate;
@synthesize currentCityPoint = _currentCityPoint;
@synthesize distanceFilter = _distanceFilter;

+ (WFLocationManager *)sharedInstance
{
  if (!sharedLocationManager) {
    sharedLocationManager = [[WFLocationManager alloc] init];
  }
  return sharedLocationManager;
}

- (id)init
{
  if (self = [super init]) {
    _scanner = [[WFWiFiScan alloc] init];
    _scanner.signalFilter = lowSignalValue;
  }
  return self;
}

- (void)dealloc
{
  [_scanner release], _scanner = nil;
  [_timer invalidate], [_timer release], _timer = nil;
  [_currentCityPoint release], _currentCityPoint = nil;
  [super dealloc];
}

- (void)startUpdatingLocation
{
  _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                            target:self
                                          selector:@selector(computingLocation)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)stopUpdatingLocation
{
  [_timer invalidate];
}

- (BOOL)computingLocation
{
  //获得WiFi列表（已经根据命名规则进行过滤处理）
  [_scanner scanNetworks];
  
  //列表中无任何WiFi热点情况下不继续执行，立即返回。
  if ([_scanner numberOfNetworks] == 0) {
    return NO;
  }
  
  WFWiseFlagBox *wiseflagBox = [WFWiseFlagBox sharedInstance];
  
  NSMutableArray *wiseflags = [NSMutableArray array];
  
  //在WiseFlagBox中取出WiFi列表中对应热点的路牌
  for (NSDictionary *network in [_scanner networks]) {
    WFWiseFlag *wiseflag = [wiseflagBox wiseflagWithMac:[network objectForKey:WIFI_MAC]];
    if (wiseflag) {
      wiseflag.signalLevel = [[network objectForKey:WIFI_RSSI] integerValue];
      [wiseflags addObject:wiseflag];
    }
  }
  
  //在WiseFlagBox中无当前热点对应路牌，从服务器上更新下载热点对应地图切片
  //当列表中包含一个以上WiFi热点时，按照信号顺序循环使用热点信息创建不完整路牌，然后向服务器发出请求，
  //直到服务器有返回的地图切片信息才停止，结束循环，继续向下执行
  if (wiseflags.count == 0) {
    WFMapClip *mapClip = nil;
    WFServiceManager *manager = [WFServiceManager sharedInstance];
    for (NSDictionary *network in [_scanner networks]) {
      WFWiseFlag *wiseflag = [[WFWiseFlag alloc] initWithMac:[network objectForKey:WIFI_MAC]];
      wiseflag.ssid = [network objectForKey:WIFI_SSID];
      wiseflag.signalLevel = [[network objectForKey:WIFI_RSSI] integerValue];
      mapClip = [manager updatingMapClipWithWiseFlag:wiseflag];
      [wiseflag release];
      if (mapClip) {
        break;
      }
    }
    
    //所有WiFi热点在服务器上也找不到对应的地图切片时候
    if (mapClip == nil) {
      return NO;
    }
  }
  
  //再一次在WiseFlagBox中取出WiFi列表中对应热点的路牌
  for (NSDictionary *network in [_scanner networks]) {
    WFWiseFlag *wiseflag = [wiseflagBox wiseflagWithMac:[network objectForKey:WIFI_MAC]];
    if (wiseflag) {
      wiseflag.signalLevel = [[network objectForKey:WIFI_RSSI] integerValue];
      [wiseflags addObject:wiseflag];
    }
  }
  
  WFCityPoint *newCityPoint = nil;
  
  //根据附近路牌数量和信号强度计算
  if (wiseflags.count >= 3) { //附近有3个以上路牌
    
    WFWiseFlag *wf1 = [wiseflags objectAtIndex:0];
    WFWiseFlag *wf2 = [wiseflags objectAtIndex:1];
    WFWiseFlag *wf3 = [wiseflags objectAtIndex:2];
    
    if (wf1.signalLevel > highSignalValue) {
      newCityPoint = [self computeCitypointWithNearWiseflag:wf1 alsoWiseflag:wf2];
    }
    else if (highSignalValue > wf1.signalLevel && wf1.signalLevel >= middleSignalValue) {
      WFCityPoint* citypoint1 = [self computeCitypointWithNearWiseflag:wf1 alsoWiseflag:wf2];
      WFCityPoint* citypoint2 = [self computeCitypointWithNearWiseflag:wf2 alsoWiseflag:wf3];
      
      CGLength length = CGLengthFromPointToPoint(wf1.cityPoint.CGPoint, citypoint1.CGPoint);
      CGPoint point = CGPointMakeInLineSegment(wf1.cityPoint.CGPoint, citypoint2.CGPoint, length);

      newCityPoint = [WFCityPoint cityPointWithMapClipID:wf1.mapClipID CGPoint:point];
    }
    else if (middleSignalValue > wf1.signalLevel) {
      WFCityPoint* citypoint1 = [self computeCitypointWithNearWiseflag:wf1 alsoWiseflag:wf2];
      WFCityPoint* citypoint2 = [self computeCitypointWithNearWiseflag:wf2 alsoWiseflag:wf3];
      WFCityPoint* citypoint3 = [self computeCitypointWithNearWiseflag:wf1 alsoWiseflag:wf3];
      
      CGPoint point = CGPointMakeInTriangleCentroid(citypoint1.CGPoint, citypoint2.CGPoint, citypoint3.CGPoint);
      
      newCityPoint = [WFCityPoint cityPointWithMapClipID:wf1.mapClipID CGPoint:point];
    }
  }
  else if (wiseflags.count == 2) { //附近有2个路牌
    WFWiseFlag *wf1 = [wiseflags objectAtIndex:0];
    WFWiseFlag *wf2 = [wiseflags objectAtIndex:1];
    newCityPoint = [self computeCitypointWithNearWiseflag:wf1 alsoWiseflag:wf2];
  }
  else if (wiseflags.count == 1) { //附近有1个路牌
    WFWiseFlag *wf = [wiseflags objectAtIndex:0];
    newCityPoint = [self computeCitypointWithNearWiseflag:wf alsoWiseflag:nil];
  }
  else { //附近不存在路牌
    return NO;
  }
  

  

  
  
  if (_currentCityPoint == nil) {
    //调用delegate的更新方法
    [self.delegate locationManager:self didUpdateCityPoint:newCityPoint];
  }
  else {
    if ([_currentCityPoint distance:newCityPoint] > _distanceFilter) {
      //调用delegate的更新方法
      [self.delegate locationManager:self didUpdateCityPoint:newCityPoint];
    }
    [_currentCityPoint release];
  }
  
  _currentCityPoint = [newCityPoint retain];
  return YES;
}




- (CLLocationDistance)convertDistanceFromSignal:(WFWiseflagSignal)signal 
                                      maxSignal:(WFWiseflagSignal)maxSignal 
                                      minSignal:(WFWiseflagSignal)minSignal
                                   nearDistance:(CLLocationDistance)nearDistance
                                    farDistance:(CLLocationDistance)farDistance
{
  CLLocationDistance distance;
  
  distance = (((signal - maxSignal) * (farDistance - nearDistance)) / (minSignal - maxSignal)) + nearDistance;
  
  return distance;
}

- (CLLocationDistance)convertDistanceFromSignal:(WFWiseflagSignal)signal
{
  CLLocationDistance distance = [self convertDistanceFromSignal:signal 
                                                      maxSignal:highSignalValue 
                                                      minSignal:middleSignalValue 
                                                   nearDistance:highSignalDistance 
                                                    farDistance:middleSignalDistance];
  
  return distance;
}

//算出两点间线段长度
CG_INLINE CGLength
CGLengthFromPointToPoint(CGPoint p1, CGPoint p2)
{
  //求 x^2 + y^2 的平方根，勾股定理
  return hypotf(p1.x - p2.x, p1.y - p2.y);
}

//算出在线段上距离p1为len的点
CG_INLINE CGPoint
CGPointMakeInLineSegment(CGPoint p1,  //线段端点
                         CGPoint p2,  //线段端点
                         CGLength len)//距离
{
  CGLength lineLength = CGLengthFromPointToPoint(p1, p2);
  
  CGFloat x = p1.x + (len / lineLength * (p2.x - p1.x));
  CGFloat y = p1.y + (len / lineLength * (p2.y - p1.y));
  
  return CGPointMake(x, y);
}

//计算三角形质心
CG_INLINE CGPoint
CGPointMakeInTriangleCentroid(CGPoint pA, //三角形顶点
                              CGPoint pB, //三角形顶点
                              CGPoint pC) //三角形顶点
{
  CGFloat x = (pA.x + pB.x + pC.x) / 3;
  CGFloat y = (pA.y + pB.y + pC.y) / 3;
  
  return CGPointMake(x, y);
}

CG_INLINE CGLength
CGLengthFromCLLocationDistance(CLLocationDistance d)
{
  CGFloat mapScale = 10.0f;
  return d * mapScale;  //乘以比例尺
}

CG_INLINE CLLocationDistance
CLLocationDistanceFromCGLength(CGLength l)
{
  CGFloat mapScale = 10.0f;
  return l / mapScale;  //乘以比例尺
}


- (WFCityPoint*)computeCitypointWithNearWiseflag:(WFWiseFlag*)nearWiseflag alsoWiseflag:(WFWiseFlag*)alsoWiseflag
{
  if (nearWiseflag == nil) {
    return nil;
  }
  
  WFCityPoint* citypoint = nil;
  
  //信号强度大于高信号值，使用路牌坐标，设置精度为3m
  if (nearWiseflag.signalLevel > highSignalValue) {
    citypoint = nearWiseflag.cityPoint;
    
    //信号高于高信号值时设置精度：3m
    citypoint.accuracy = 3;
  }
  //信号强度在高信号和中信号值之间，根据另一个路牌的信息来计算
  else if (highSignalValue > nearWiseflag.signalLevel && nearWiseflag.signalLevel >= middleSignalValue) {
    //无第二个路牌信息
    if (alsoWiseflag == nil) {
      citypoint = nearWiseflag.cityPoint;
      
      //信号在高信号和中信号之间时根据信号计算精度
      citypoint.accuracy = [self convertDistanceFromSignal:nearWiseflag.signalLevel];
    }
    else {
      CLLocationDistance distance = [self convertDistanceFromSignal:nearWiseflag.signalLevel];
      CGLength length = CGLengthFromCLLocationDistance(distance);
      
      CGPoint point = CGPointMakeInLineSegment(nearWiseflag.cityPoint.CGPoint, alsoWiseflag.cityPoint.CGPoint, length);
      
      citypoint = [WFCityPoint cityPointWithMapClipID:nearWiseflag.mapClipID CGPoint:point];
    }
  }
  //信号强度低于中信号值
  else if (middleSignalValue > nearWiseflag.signalLevel) {
    //无第二个路牌信息
    if (alsoWiseflag == nil) {
      citypoint = nearWiseflag.cityPoint;
      
      //信号低于中信号值时精度设置为：40m
      citypoint.accuracy = 40;
    }
    else {
//TODO:重点测试
      NSUInteger signalMargin = abs(nearWiseflag.signalLevel - alsoWiseflag.signalLevel);
      CGLength length = CGLengthFromPointToPoint(nearWiseflag.cityPoint.CGPoint, alsoWiseflag.cityPoint.CGPoint);
      CGPoint point;
      if (length > CGLengthFromCLLocationDistance(middleSignalDistance * 2)) {
        CGLength lengthSpace = length - CGLengthFromCLLocationDistance(middleSignalDistance * 2);
        CGLength lengthUnit = lengthSpace / ((middleSignalValue - lowSignalValue) * 2);
        CGLength lengthOffset = (length / 2) - (lengthUnit * signalMargin);
        point = CGPointMakeInLineSegment(nearWiseflag.cityPoint.CGPoint, alsoWiseflag.cityPoint.CGPoint, lengthOffset);
      }
      else {
        point = CGPointMakeInLineSegment(nearWiseflag.cityPoint.CGPoint, alsoWiseflag.cityPoint.CGPoint, length / 2);
      }
      citypoint = [WFCityPoint cityPointWithMapClipID:nearWiseflag.mapClipID CGPoint:point];
    }
  }
  
  return citypoint;
}

@end
