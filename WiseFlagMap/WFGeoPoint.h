//
//  WFGeoPoint.h
//  地球上的经纬度坐标. 表示一个地理坐标点，存放经度和纬度，以微度的整数形式存储。 10^6 * 经纬度.
//
//  Created by 汪 威 on 12-6-22.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface WFGeoPoint : NSObject

@property (nonatomic) NSInteger longitudeE6;  //精度E6
@property (nonatomic) NSInteger latitudeE6;   //纬度E6

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (id)initWithLongitudeE6:(NSInteger)longitudeE6 LatitudeE6:(NSInteger)latitudeE6;

@end
