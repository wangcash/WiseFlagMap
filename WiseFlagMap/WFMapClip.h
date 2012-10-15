//
//  WFMapClip.h
//  附属有智能路牌的地图切片.
//
//  Created by 汪 威 on 12-5-31.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* WFMapClipDirectory(void);

@class WFHitTester;

#define kWFMapLayerNumber 7
typedef enum {
  kWFMapLayerINVALID=-1,
  kWFMapLayerBaseMapShape,      //基图图形层
  kWFMapLayerWiseFlagShape,     //路牌图形层
  kWFMapLayerBusinessShape,     //商业图形层
  kWFMapLayerUserShape,         //用户图形层
  kWFMapLayerBaseMapAnnotation, //基图标注层
  kWFMapLayerWiseFlagAnnotation,//路牌标注层
  kWFMapLayerBusinessAnnotation,//商业标注层
  kWFMapLayerUserAnnotation,    //用户标注层
  kWFMapLayerControls,          //控件层
  kWFMapLayerMAX
} kWFMapLayerType;


@interface WFMapClip : NSObject
{
  NSMutableDictionary* _category;
}

@property (nonatomic, readonly) CGRect        CGRect;
@property (nonatomic, retain)   WFHitTester*  hitTester;
@property (nonatomic, readonly) NSString*     ID;

+ (id)MapClipWithMapClipID:(NSString*)ID;

- (id)initWithMapClipID:(NSString*)ID;

- (NSArray*)inLayerAllShapes:(kWFMapLayerType)layerType;

- (NSArray*)inLayerShapes:(kWFMapLayerType)layerType inBound:(CGRect)bound atScale:(CGFloat)scale;

- (NSArray*)inLayerAllAnnotations:(kWFMapLayerType)layerType;

- (NSArray*)inLayerAnnotations:(kWFMapLayerType)layerType inBound:(CGRect)bound atScale:(CGFloat)scale;
@end
