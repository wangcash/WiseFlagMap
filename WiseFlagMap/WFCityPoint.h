//
//  WFCityPoint.h
//  城市中的一个点.
//
//  Created by 汪 威 on 12-6-22.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFMapClip.h"
#import "WFGeoPoint.h"

@interface WFCityPoint : NSObject

//精度
@property (nonatomic) float accuracy;

@property (nonatomic, readonly) NSString* mapClipID;
@property (nonatomic, readonly) NSNumber* x;
@property (nonatomic, readonly) NSNumber* y;


@property (nonatomic, readonly) WFMapClip* mapClip;
@property (nonatomic, readonly) CGPoint    CGPoint;


+ (WFCityPoint*)cityPointWithMapClipID:(NSString*)mapClipID x:(NSNumber*)x y:(NSNumber*)y;

+ (WFCityPoint*)cityPointWithMapClipID:(NSString*)mapClipID CGPoint:(CGPoint)point;

- (BOOL)isGeoPoint;

/**
 * 计算与另一个CityPoint的距离，方法内没有处理不同MapClip的CityPoint。
 */
- (CGFloat)distance:(WFCityPoint *)other;

@end
