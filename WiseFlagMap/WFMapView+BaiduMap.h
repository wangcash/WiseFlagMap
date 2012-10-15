//
//  WFMapView+BaiduMap.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-1.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFMapView.h"
#import "BMapKit.h"

@interface WFMapView (BaiduMap)

/**
 * 当前是否是户外地图
 */
- (BOOL)isOutdoorMap;

- (BOOL)initOutdoorMap;
- (void)showOutdoorMap;
- (void)hideOutdoorMap;

@end
