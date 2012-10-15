//
//  WFWiseFlag.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-25.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFCityPoint.h"

@interface WFWiseFlag : NSObject
{
  
}


/**
 * 路牌ID，暂时未使用
 */
@property (nonatomic, retain) NSString* ID;

/**
 * WiFi点的MAC地址
 */
@property (nonatomic, retain) NSString* mac;

/**
 * WiFi点的SSID
 */
@property (nonatomic, retain) NSString* ssid;

/**
 * 路牌短名称，如：A1
 */
@property (nonatomic, retain) NSString* shortName;

/**
 * 路牌长名称，如：大悦城一层A1
 */
@property (nonatomic, retain) NSString* longName;

/**
 * 信号强度基础值，当signalLevel大于此值时认为终端在此路牌附近
 */
@property (nonatomic, assign) NSInteger signalLevel;

/**
 * 虚拟路牌标志，YES：虚拟路牌，NO：真实路牌，默认值为NO
 */
@property (nonatomic, assign)   BOOL fake;
@property (nonatomic, readonly) BOOL real;

/**
 * 城市点，标志路牌所在位置
 */
@property (nonatomic, retain) WFCityPoint* cityPoint;

/**
 * 当前路牌对应的MapClipID
 */
@property (nonatomic, readonly) NSString* mapClipID;


/**
 * 使用mac地址构造一个空路牌
 */
- (id)initWithMac:(NSString*)mac;

@end
