//
//  WFMapView+BaiduMap.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-1.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFMapView+BaiduMap.h"

@implementation WFMapView (BaiduMap)

- (BOOL)isOutdoorMap
{
  //TODO:没实现
  return YES;
}

- (BOOL)initOutdoorMap
{
  //要使用百度地图，先启动BaiduMapManager
  _outdoorMapManager = [[BMKMapManager alloc] init];
  BOOL ret = [_outdoorMapManager start:@"1D6F1D23B4EF447CC3A8441860BCC540F21D522A" generalDelegate:nil];
  if (!ret) {
    NSLog(@"BaiduMapManager start failed!");
  }
  return ret;
}

- (void)dealloc
{
  [_outdoorMapManager release];
  [super dealloc];
}

- (void)showOutdoorMap
{
  if (!_outdoorMapView) {
    _outdoorMapView = [[BMKMapView alloc]initWithFrame:self.bounds];
  }
  [self addSubview:_outdoorMapView];
}

- (void)hideOutdoorMap
{
  if (_outdoorMapView) {
    [_outdoorMapView removeFromSuperview];
  }
}

@end
