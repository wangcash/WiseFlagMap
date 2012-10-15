//
//  WFWiFiScan.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-8.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define __Jailbreak__

#ifdef __Jailbreak__
#include <dlfcn.h>
#endif

typedef NSInteger WFWiseflagSignal;


#define WIFI_MAC   @"MAC"
#define WIFI_BSSID @"BSSID"
#define WIFI_SSID  @"SSID_STR"
#define WIFI_RSSI  @"RSSI"
#define WIFI_CHAN  @"CHANNEL"

@interface WFWiFiScan : NSObject

@property (nonatomic) WFWiseflagSignal signalFilter;

/**
 * scan all 802.11 network(s)
 */
- (void)scanNetworks;

/**
 * returns 802.11 number
 */
- (NSUInteger)numberOfNetworks;

/**
 * returns 802.11 scanned network(s)
 */
- (NSArray *)networks;

/**
 * return specific 802.11 network by MAC Address
 */
- (NSDictionary *)network:(NSString *)mac;

@end