//
//  WFMapView.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFMapView.h"
#import "SVGKit.h"
#import "TBXML.h"
#import "ASIHTTPRequest.h"
#import "SNPopupView.h"
#import "JSONKit.h"

#import "WFTiledMapView.h"
#import "WFMapClip.h"
#import "WFShape.h"
#import "WFAnnotation.h"
#import "WFWiseFlagBox.h"
#import "WFWiseFlag.h"
#import "WFCityPoint.h"
#import "WFBuilding.h"
#import "WFServiceManager.h"
#import "WFUserMap.h"

#import <MapKit/MapKit.h>

#define DEFAULT_MAXIMUM_MAP_SCALE (5.0f)

@implementation WFMapView
{
  WFTiledMapView * _tiledMapView;
  WFTiledMapView * _oldTiledMapView;
  
  WFMapClip * _oldMapClip;
  
  CGFloat _minimumMapScale;
  CGFloat _maximumMapScale;
  CGFloat _mapScale;
  
  MKPinAnnotationView *topPin;
}

@synthesize mapViewDelegate = _mapViewDelegate;
@synthesize mapScale = _mapScale, minimumMapScale = _minimumMapScale, maximumMapScale = _maximumMapScale;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    
    // Set up the UIScrollView
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = YES;
    self.bouncesZoom = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
		[self setBackgroundColor:[UIColor whiteColor]];
    
//    //单指单击
//    UITapGestureRecognizer *singleOnceTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                    action:@selector(handleOnceTap:)]; 
//    singleOnceTap.numberOfTouchesRequired = 1;
//    singleOnceTap.numberOfTapsRequired = 1;
//    singleOnceTap.cancelsTouchesInView = NO;
//    
//    //双指单击
//    UITapGestureRecognizer *doubleOnceTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                    action:@selector(handleOnceTap:)]; 
//    doubleOnceTap.numberOfTouchesRequired = 2;
//    doubleOnceTap.numberOfTapsRequired = 1;
//    doubleOnceTap.cancelsTouchesInView = NO;
//    
//    //单指双击
//    UITapGestureRecognizer *singleTwiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                     action:@selector(handleTwiceTap:)]; 
//    singleTwiceTap.numberOfTouchesRequired = 1;
//    singleTwiceTap.numberOfTapsRequired = 2;
//    singleTwiceTap.cancelsTouchesInView = NO;
//    
//    //双指双击
//    UITapGestureRecognizer *doubleTwiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                     action:@selector(handleTwiceTap:)]; 
//    doubleTwiceTap.numberOfTouchesRequired = 2;
//    doubleTwiceTap.numberOfTapsRequired = 2;
//    doubleTwiceTap.cancelsTouchesInView = NO;
//    
//    [singleOnceTap requireGestureRecognizerToFail:singleTwiceTap];
//    [doubleOnceTap requireGestureRecognizerToFail:doubleTwiceTap]; 
//    
//    [self addGestureRecognizer:singleOnceTap]; [singleOnceTap release];
//    [self addGestureRecognizer:doubleOnceTap]; [doubleOnceTap release];
//    [self addGestureRecognizer:singleTwiceTap]; [singleTwiceTap release];
//    [self addGestureRecognizer:doubleTwiceTap]; [doubleTwiceTap release];
    

    //初始化室外地图
//    [self performSelector:@selector(initOutdoorMap)];
    
    
  }
  return self;
}

- (void)dealloc
{
  [_tiledMapView release], _tiledMapView = nil;
  [super dealloc];
}

- (void)setMapClipID:(NSString *)ID
{
  if ([_mapClip.ID isEqualToString:ID]) {
    return;
  }
  [self setMapClip:[WFMapClip MapClipWithMapClipID:ID]];
}

- (void)setMapClip:(WFMapClip *)mapClip
{
  //新更新的MapClip和旧的MapClip一样就直接返回。
  if ([self isEqual:mapClip]) {
    return;
  }
  
  [_tiledMapView removeFromSuperview];
  [_tiledMapView release], _tiledMapView = nil;
  
  //改变地图切片时销毁气泡
  if ([self respondsToSelector:@selector(destroyBubble)]) {
    [self performSelector:@selector(destroyBubble)];
  }
  
  [_oldTiledMapView removeFromSuperview];
  [_oldTiledMapView release], _oldTiledMapView = nil;
  _oldTiledMapView = _tiledMapView;
  
  [_oldMapClip release], _oldMapClip = nil;
  _oldMapClip = _mapClip;
  
  _mapClip = [mapClip retain];
  
  //进行后楼层切换后不从心计算缩放比例
  if (_mapScale == 0.0f) {
    //计算适合屏幕显示的初始缩放比例
    CGFloat scaleOfHeight = self.frame.size.height / _mapClip.CGRect.size.height;
    CGFloat scaleOfWidth  = self.frame.size.width / _mapClip.CGRect.size.width;
    _minimumMapScale = MIN(scaleOfHeight, scaleOfWidth);
    _maximumMapScale = DEFAULT_MAXIMUM_MAP_SCALE;
    _mapScale = _minimumMapScale;
  }
  
  //地图切片矩形
  CGRect mapClipRect = CGRectScale(_mapClip.CGRect, _mapScale);
  
  //计算并更新缩放比例
  [self calculateZoomScale];
  
  //绘制第一屏图像
  _tiledMapView = [[WFTiledMapView alloc] initWithFrame:mapClipRect atScale:_mapScale];
  [_tiledMapView setMapClip:_mapClip];
  
  
  //  [self addSubview:_tiledMapView];
  //在第二层插入地图，使气泡始终显示在最上层
  [self insertSubview:_tiledMapView atIndex:1];
}



- (void)layoutSubviews
{
  [super layoutSubviews];
  
  //将地图居中显示
  CGSize boundsSize = self.bounds.size;
  CGRect frameToCenter = _tiledMapView.frame;
  
  // center horizontally
  if (frameToCenter.size.width < boundsSize.width)
    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
  else
    frameToCenter.origin.x = 0;
  
  // center vertically
  if (frameToCenter.size.height < boundsSize.height)
    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
  else
    frameToCenter.origin.y = 0;
  
  _tiledMapView.frame = frameToCenter;
  
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
//  NSLog(@"_tiledMapView.frame2: %@",NSStringFromCGRect(_tiledMapView.frame));
#endif
  
	// to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
	// tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
	// which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
  //	tiledMapView.contentScaleFactor = 1.0;
  
  //地图缩放后重绘气泡
  if ([self respondsToSelector:@selector(redrawBubble)]) {
    [self performSelector:@selector(redrawBubble)];
  }
  
  //地图缩放后重绘用户当前位置
  if ([self respondsToSelector:@selector(redrawCurrentLocation)]) {
    [self performSelector:@selector(redrawCurrentLocation)];
  }
  
//  UIImage *location = [UIImage imageNamed:@"icon_center_point.png"];
////  UIImageView *imageView = [[UIImageView alloc] initWithImage:location];
//  UIImageView *imageView = [UIImageView alloc] initWithFrame:<#(CGRect)#>
//  imageView.frame = CGRectMake(100, 100, imageView.frame.size.width, imageView.frame.size.height);
//  NSLog(@"frame:%@", NSStringFromCGRect(imageView.frame));
//  [self addSubview:imageView];
//  [imageView release];
  
//TODO:搜索图钉做到一半

//  if (topPin == nil) {
//    topPin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
////    topPin.center = CGPointMake(100, 100);
////  [topPin addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topPinTapped)]];
//    [_tiledMapView addSubview:topPin];
////  [topPin release];
//  }
//  
//  
//  
//  topPin.center = CGPointMake(100, 100);

}

- (void)drawRect:(CGRect)rect
{
  //重新设置碰撞检测器
  [_mapClip.hitTester reset];

  [_tiledMapView setNeedsDisplay];
}

- (CGFloat)scaleOfHeight
{
  return _tiledMapView.frame.size.height / _mapClip.CGRect.size.height;
}
- (CGFloat)scaleOfWidth
{
  return _tiledMapView.frame.size.width / _mapClip.CGRect.size.width;
}
- (CGPoint)centerMigration
{
  return _tiledMapView.frame.origin;
}

/********************************************************************************/
#pragma mark - UIScrollViewDelegate
/********************************************************************************/
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
//  NSLog(@"[%s]",__FUNCTION__);
  
  [_oldTiledMapView removeFromSuperview];
  [_oldTiledMapView release], _oldTiledMapView = nil;
  
  _oldTiledMapView = _tiledMapView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _tiledMapView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	_mapScale *= scale;
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  NSLog(@"[%s] scale=%f mapScale=%f", __FUNCTION__, scale, _mapScale); 
#endif
  CGRect mapClipRect = CGRectScale(_mapClip.CGRect, _mapScale);
  
  //重新设置碰撞检测器
  [_mapClip.hitTester reset];
  
  _tiledMapView = [[WFTiledMapView alloc] initWithFrame:mapClipRect atScale:_mapScale];
  [_tiledMapView setMapClip:_mapClip];
  
  //在第二层插入地图，使气泡始终显示在最上层
  [self insertSubview:_tiledMapView atIndex:1];
  
  //计算并更新缩放比例
  [self calculateZoomScale];
}


/********************************************************************************/
#pragma mark - 手势处理
/********************************************************************************/
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//  NSLog(@"%s", __FUNCTION__);
//}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch =  [touches anyObject];
  if (touch.tapCount == 1) {
    CGPoint point = [touch locationInView:self];

    //修正小比例地图居中显示后的XY轴偏移
    if (_tiledMapView.frame.origin.y > 0) {
      point.y -= _tiledMapView.frame.origin.y;
    }
    if (_tiledMapView.frame.origin.x > 0) {
      point.x -= _tiledMapView.frame.origin.x;
    }
    
    //使用还原坐标比例返回单击点
    [self pickupWithPoint:CGPointDescale(point, _mapScale) currentScale:_mapScale];
  }
}

- (void)handleOnceTap:(UITapGestureRecognizer *)sender
{
  if (sender.numberOfTouchesRequired == 1) { //单指单击后进行拾取
    CGPoint point = [sender locationInView:self];
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
    NSLog(@"point:%@", NSStringFromCGPoint(point));
    NSLog(@"source %@ (%f)", NSStringFromCGPoint(CGPointDescale(point, _mapScale)), _mapScale);
#endif
    //修正小比例地图居中显示后的XY轴偏移
    if (_tiledMapView.frame.origin.y > 0) {
      point.y -= _tiledMapView.frame.origin.y;
    }
    if (_tiledMapView.frame.origin.x > 0) {
      point.x -= _tiledMapView.frame.origin.x;
    }
    //使用还原坐标比例返回单击点
    [self pickupWithPoint:CGPointDescale(point, _mapScale) currentScale:_mapScale];
  } 
  else if (sender.numberOfTouchesRequired == 2) {
    NSLog(@"Once Tap with two finger.");
  } 
}

- (void)handleTwiceTap:(UITapGestureRecognizer *)sender
{ 
  if (sender.numberOfTouchesRequired == 1) { //单指双击后地图放大
    [self zoomInForStepWithPoint:[sender locationInView:self]];
  }
  else if (sender.numberOfTouchesRequired == 2) {
    NSLog(@"Twice Tap with two finger.");
  }
}

/********************************************************************************/
#pragma mark - 拾取处理
/********************************************************************************/
- (void)pickupWithPoint:(CGPoint)point currentScale:(CGFloat)scale
{
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  NSLog(@"[%s]",__FUNCTION__);
#endif
  
  NSMutableArray *tapObjectArray = [[[NSMutableArray alloc] init] autorelease];
  
  for (kWFMapLayerType l = kWFMapLayerMAX; l >= kWFMapLayerBaseMapAnnotation; l--) {
    NSArray *annotations = [_mapClip inLayerAllAnnotations:l];
    if (annotations == nil) {
      continue;
    }
    for (NSInteger i=annotations.count-1; i>=0; i--) {
      WFAnnotation<WFAnnotation> *annotation = [annotations objectAtIndex:i];
      if ([annotation isPointInAnnotation:point]) {
        if ([_mapViewDelegate respondsToSelector:@selector(singleTapPoint:currentScale:tapObject:)]) {
          //mapViewDelegate中实现了singleTapPoint:currentScale:tapObject:方法时候提前返回
          [_mapViewDelegate singleTapPoint:point currentScale:scale tapObject:annotation];
          return;
        }
        [tapObjectArray addObject:annotation];
      }
    }
  }
  
  for (kWFMapLayerType l = kWFMapLayerUserShape; l > kWFMapLayerINVALID; l--) {
    NSArray *shapes = [_mapClip inLayerAllShapes:l];
    if (shapes == nil) {
      continue;
    }
    for (NSInteger i=shapes.count-1; i>=0; i--) {
      WFShape<WFShape> *shape = [shapes objectAtIndex:i];
      if ([shape isPointInShape:point]) {
        if ([_mapViewDelegate respondsToSelector:@selector(singleTapPoint:currentScale:tapObject:)]) {
          //mapViewDelegate中实现了singleTapPoint:currentScale:tapObject:方法时候提前返回
          [_mapViewDelegate singleTapPoint:point currentScale:scale tapObject:shape];
          return;
        }
        [tapObjectArray addObject:shape];
      }
    }
  }
  
  if ([_mapViewDelegate respondsToSelector:@selector(singleTapPoint:currentScale:tapObjectArray:)]) {
    [_mapViewDelegate singleTapPoint:point currentScale:scale tapObjectArray:tapObjectArray];
    return;
  }
  
}

/********************************************************************************/
#pragma mark - 缩放处理
/********************************************************************************/
#define ZOOM_STEP (1.5f)

- (void)zoomInForStepWithPoint:(CGPoint)point
{
  [self zoomInForScale:ZOOM_STEP withPoint:point];
}

- (void)zoomOutForStepWithPoint:(CGPoint)point
{
  [self zoomOutForScale:ZOOM_STEP withPoint:point];
}

- (void)zoomInForScale:(CGFloat)scale withPoint:(CGPoint)point
{
  CGFloat newScale = self.zoomScale * scale;
  CGRect zoomRect = [self zoomRectForScale:newScale withCenter:point];
  [self zoomToRect:zoomRect animated:YES];
}

- (void)zoomOutForScale:(CGFloat)scale withPoint:(CGPoint)point
{
  CGFloat newScale = self.zoomScale / scale;
  CGRect zoomRect = [self zoomRectForScale:newScale withCenter:point];
  [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
  
  CGRect zoomRect;
  
  // the zoom rect is in the content view's coordinates. 
  //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
  //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
  zoomRect.size.height = self.frame.size.height / scale;
  zoomRect.size.width  = self.frame.size.width  / scale;
  
  // choose an origin so as to get the right center.
  zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
  zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
  
  return zoomRect;
}

- (void)calculateZoomScale
{
  //计算并限制控件的缩放比例，控制地图的最小尺寸和最大尺寸
  self.maximumZoomScale = _maximumMapScale / _mapScale;
  self.minimumZoomScale = _minimumMapScale / _mapScale;
}

/********************************************************************************/
#pragma mark - 地图接口
/********************************************************************************/
/**
 * 将一个点转换成一个CityPoint
 */
- (WFCityPoint*)cityPointWithCGPoint:(CGPoint)point
{
  
//  WFCityPoint *cityPoint = [[WFCityPoint alloc] initWithMapClip:_mapClip x:point.x y:point.y];
//  return [cityPoint autorelease];
  return [WFCityPoint cityPointWithMapClipID:_mapClip.ID CGPoint:point];
}

/**
 * 将一个CityPoint转换成一个点
 */
- (CGPoint)CGPointWithCityPoint:(WFCityPoint *)cityPoint
{
  if (cityPoint == nil) {
    return CGPointZero;
  }
  return cityPoint.CGPoint;
}

//

//- (WFCityPoint *)userCityPoint
//{
//  //TODO:获得路牌MAC
//  
//  //TODO:在已下载的本地数据中查找路牌
//  
//  //TODO:读入MapClip数据，并计算用户位置（返回）
//  
//  //TODO:调用网络接口下载MapClip数据
//  
//  //TODO:读入MapClip数据，并计算用户位置（返回）
//  
//  //TODO:异步下载其它楼层信息
//  
//}

- (NSArray*)routeFromCityPoint:(WFCityPoint *)fromCityPoint toCityPoint:(WFCityPoint *)toCityPoint showRoute:(BOOL)showRoute
{
  WFWiseFlagBox *box = [WFWiseFlagBox sharedInstance];
  
  WFWiseFlag *startWiseFlag = [box nearWiseFlagWithCityPoint:fromCityPoint];
  NSLog(@"Start WiseFlag[%@]", startWiseFlag.shortName);
  
  WFWiseFlag *endWiseFlag = [box nearWiseFlagWithCityPoint:toCityPoint];
  NSLog(@"End WiseFlag[%@]", endWiseFlag.shortName);
  
  NSArray *route = [box routeSearchWithStartCityPoint:fromCityPoint andEndCityPoint:toCityPoint];
  for (NSUInteger i = 0; i < route.count; i++) {
    WFWiseFlag *wiseflag = [route objectAtIndex:i];
    NSLog(@"%d.[%@]",i+1 , wiseflag.shortName);
  }
  
  if (showRoute) {
    WFUserMap *userMap = [WFUserMap sharedInstance];
    [userMap showNavigation:route startCityPoint:fromCityPoint endCityPoint:toCityPoint];
    [self setNeedsDisplay];
  }
  
  return route;
}

- (NSArray*)searchRoomsWithKeyword:(NSString*)keyword inBuildingID:buildingID
{
  //TODO:通过buildingID拿到building对象
  
  //TODO:在building中拿到MapClip对象、或者MapClipID
  
  //TODO:解析查找符合的Room
  
  //TODO:在地图上插搜索结果图钉
  
  //返回搜索结果。
  return nil;
}

- (void)testLocation:(NSString *)mac
{
  WFWiseFlag *wiseflag = [[WFWiseFlag alloc] init];
  wiseflag.mac = mac;
  wiseflag.ssid = mac;
  wiseflag.signalLevel = -50;
  
  WFServiceManager *manager = [WFServiceManager sharedInstance];
  WFMapClip *mapClip = [manager updatingMapClipWithWiseFlag:wiseflag];
  
  if (mapClip != nil) {
    [_tiledMapView removeFromSuperview];
    [_tiledMapView release], _tiledMapView = nil;
    [self setMapClip:mapClip];
  }
  
  [wiseflag release];
  
  
  //TODO:从Building中获得楼层;
  NSArray *IDs = [NSArray arrayWithObjects:@"DaYueCheng_B1", @"DaYueCheng_F1", @"DaYueCheng_F2", @"DaYueCheng_F3", @"DaYueCheng_F4", @"DaYueCheng_F5", @"DaYueCheng_F6", nil];
  [manager downloadMapClipsWithIDArray:IDs];
  
  return;
}

@end
