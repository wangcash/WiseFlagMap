//
//  WFWiseFlagBox.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFMapClip;
@class WFCityPoint;
@class WFWiseFlag;
@class WFWiseFlagMap;

@interface WFWiseFlagBox : NSObject

/**
 * 获得一个WiseFlagBox实例
 */
+ (WFWiseFlagBox *)sharedInstance;

#pragma mark - 旧版本方法

/**
 * 
 */
- (void)loadWiseFlagWithMapClip:(WFMapClip*)mapClip;

/**
 * 使用MapClip获得路牌列表
 */
- (WFWiseFlagMap*)wiseflagMap:(WFMapClip*)mapClip;

/**
 * 使用ID查找路牌
 */
- (WFWiseFlag*)wiseflagWithID:(NSString*)ID;

/**
 * 使用MAC查找路牌
 */
- (WFWiseFlag*)wiseflagWithMac:(NSString*)mac;

/**
 * 得到距离CityPoint最近的路牌
 */
- (WFWiseFlag*)nearWiseFlagWithCityPoint:(WFCityPoint*)cityPoint;

/**
 * 增加一个空路牌
 */
- (void)addNullWiseFlag:(WFWiseFlag*)wiseflag;

/**
 * 增加一个路牌或填充一个路牌
 */
- (void)addWiseFlag:(WFWiseFlag*)wiseflag;

/**
 * 使用两个路牌进行导航
 */
- (NSArray*)routeSearchWithStartWiseFlag:(WFWiseFlag*)start andEndWiseFlag:(WFWiseFlag*)end;

/**
 * 使用两个CityPoint进行导航
 */
- (NSArray*)routeSearchWithStartCityPoint:(WFCityPoint*)start andEndCityPoint:(WFCityPoint*)end;

@end
