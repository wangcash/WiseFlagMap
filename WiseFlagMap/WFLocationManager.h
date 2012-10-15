//
//  WFLocationManager.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-8.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CGFloat CGLength;

@class WFCityPoint;
@protocol WFLocationManagerDelegate;

@interface WFLocationManager : NSObject

/**
 * 当前位置
 */
@property (nonatomic, readonly) WFCityPoint * currentCityPoint;

/**
 * 代理
 */
@property (nonatomic, retain) id<WFLocationManagerDelegate> delegate;

/**
 * 更新过滤距离
 */
@property (nonatomic) float distanceFilter;

/**
 * 获得LocationManager
 */
+ (WFLocationManager *)sharedInstance;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@end

/**
 * LocationManager的Delegate，通过此类来通知用户对应的事件
 */
@protocol WFLocationManagerDelegate
@optional

- (void)locationManager:(WFLocationManager *)manager didUpdateCityPoint:(WFCityPoint *)newCityPoint;
- (void)locationManager:(WFLocationManager *)manager didFailWithError:(NSError *)error;

@end
