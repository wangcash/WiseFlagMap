//
//  WFMapView.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKit.h"
#import "WFShape.h"
#import "WFAnnotation.h"

#import "WFDebug.h"

@class WFMapClip, WFCityPoint;
@class BMKMapManager, BMKMapView;

@protocol WFMapViewDelegate;

@interface WFMapView : UIScrollView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
  
  /**
   * 地图切片对象
   */
  WFMapClip* _mapClip;
  
  
  /**
   * 用户位置扩展
   */
  id _currentLocation;

  /**
   * 气泡扩展
   */
  id      _bubble;
  CGPoint _bubblePoint;
  
  /**
   * 户外地图扩展
   */
  id _outdoorMapManager;
  id _outdoorMapView;
}

@property (nonatomic, retain) id<WFMapViewDelegate> mapViewDelegate;

@property (nonatomic, readonly) CGFloat mapScale;
@property (nonatomic, assign)   CGFloat minimumMapScale;
@property (nonatomic, assign)   CGFloat maximumMapScale;

- (void)setMapClipID:(NSString *)ID;
- (void)setMapClip:(WFMapClip *)mapClip;

- (CGFloat)scaleOfHeight;
- (CGFloat)scaleOfWidth;
- (CGPoint)centerMigration;

/**
 * 将一个点转换成一个CityPoint
 */
- (WFCityPoint*)cityPointWithCGPoint:(CGPoint)point;

/**
 * 将一个CityPoint转换成一个点
 */
- (CGPoint)CGPointWithCityPoint:(WFCityPoint*)cityPoint;


- (NSArray*)routeFromCityPoint:(WFCityPoint*)fromCityPoint toCityPoint:(WFCityPoint*)toCityPoint showRoute:(BOOL)showRoute;

- (NSArray*)searchRoomsWithKeyword:(NSString*)keyword inBuildingID:buildingID;

/**
 * 测试方法，去一个指定路牌
 */
- (void)testLocation:(NSString *)mac;


@end


@protocol WFMapViewDelegate <NSObject>
@optional

- (void)singleTapPoint:(CGPoint)point currentScale:(CGFloat)scale tapObject:(id)object;
- (void)singleTapPoint:(CGPoint)point currentScale:(CGFloat)scale tapObjectArray:(NSArray *)array;

@end