//
//  WFWiFiScan.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-8.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFWiFiScan.h"

#define WISEFLAG_PREFIX @"365PATH"

@implementation WFWiFiScan
{
	NSMutableArray *networks;
  
#ifdef __Jailbreak__
  void *libHandle;
	void *airportHandle;    
	int (*apple80211Open)(void *);
	int (*apple80211Bind)(void *, NSString *);
	int (*apple80211Close)(void *);
	int (*associate)(void *, NSDictionary*, NSString*);
	int (*apple80211Scan)(void *, NSArray **, void *);
#endif
}

@synthesize signalFilter;

- (id)init
{
	self = [super init];
  if (self) {
    self.signalFilter = -100;
    
    networks = [[NSMutableArray alloc] init];
    
#ifdef __Jailbreak__
    float version = [[[UIDevice currentDevice] systemVersion] floatValue]; 
    if (version >= 5.0) {
      //iOS5版本中扫描wifi
      libHandle = dlopen("/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);
    }
    else {
      //iOS4版本中扫描wifi
      libHandle = dlopen("/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager", RTLD_LAZY);
    }
    char *error;
    if (libHandle == NULL && (error = dlerror()) != NULL) {
      NSLog(@"%s", error);
    }
    apple80211Open  = dlsym(libHandle, "Apple80211Open");
    apple80211Bind  = dlsym(libHandle, "Apple80211BindToInterface");
    apple80211Close = dlsym(libHandle, "Apple80211Close");
    apple80211Scan  = dlsym(libHandle, "Apple80211Scan");
    apple80211Open(&airportHandle);
    apple80211Bind(airportHandle, @"en0");
#endif
    
  }
	return self;
}

- (void)dealloc
{
#ifdef __Jailbreak__
  apple80211Close(airportHandle);
#endif
  [networks release];
  [super dealloc];
}

- (NSString *)outputDirectory
{
  NSString *path = NSTemporaryDirectory();
  return path;
}

- (NSString *)outputPath
{
  NSString *outputDir = [self outputDirectory];
  BOOL isDir = YES;
  //如果logs文件夹存不存在，则创建
  if([[NSFileManager defaultManager] fileExistsAtPath:outputDir isDirectory:&isDir] == NO)
  {
    [[NSFileManager defaultManager] createDirectoryAtPath:outputDir withIntermediateDirectories:YES attributes:nil error:nil];
  }
  NSString *fileName = @"wifi.plist";
  NSString *path = [outputDir stringByAppendingPathComponent:fileName];
  
  NSLog(@"path:%@", path);
  return path;
}

- (void)scanNetworks
{
//	NSLog(@"Scanning WiFi Channels...");
  
#ifdef __Jailbreak__
  NSLog(@"NSDictionary *parameters = [[NSDictionary alloc] init];");
  NSDictionary *parameters = [[NSDictionary alloc] init];
  NSLog(@"apple80211Scan(airportHandle, &scan_networks, parameters);");
	NSArray *scan_networks; //is a CFArrayRef of CFDictionaryRef(s) containing key/value data on each discovered network
	apple80211Scan(airportHandle, &scan_networks, parameters);
//	NSLog(@"===--======\n%@", scan_networks);
  
  NSLog(@"networks removeAllObjects");
  [networks removeAllObjects];
  
  NSLog(@"[scan_networks count]=%d", [scan_networks count]);
	for (int i = 0; i < [scan_networks count]; i++) {
    
    NSDictionary *wifi = [scan_networks objectAtIndex: i];
    NSString *ssid = [wifi objectForKey:WIFI_SSID];
    
    if ([[ssid uppercaseString] hasPrefix:WISEFLAG_PREFIX]) {
      NSString *bssid = [wifi objectForKey:WIFI_BSSID];
      NSArray *array = [[bssid uppercaseString] componentsSeparatedByString:@":"];
      NSMutableString *mac = [[NSMutableString alloc] initWithCapacity:17];
      
      for (NSUInteger i = 0; i < array.count ; i++) {
        NSString *s = [array objectAtIndex:i];
        if (s.length == 1) [mac appendString:@"0"];
        [mac appendString:s];
        if (i < 5) [mac appendString:@":"];
      }
      
      if ([[wifi objectForKey:WIFI_RSSI] integerValue] < self.signalFilter) { //过滤掉信号小于过滤值的WIFI节点
        continue;
      }
      
      [wifi setValue:mac forKey:WIFI_MAC];
      [networks addObject:wifi];
      [mac release];
    }
    
	}
  [parameters release];
#else

  NSString *path = [self outputPath];
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    networks = [NSMutableArray arrayWithArray:[[NSArray alloc] initWithContentsOfFile:path]];
  }
  else {
    networks = [[NSMutableArray alloc] init];
  }
  
#endif
  
//	NSLog(@"Scanning WiFi Channels Finished.");
}

#pragma mark - 接口实现

- (NSUInteger)numberOfNetworks
{
	return [networks count];
}

NSInteger WiFiSignalCompare(id WiFi_A, id WiFi_B, void *context)
{
  NSInteger signalA = abs([[((NSDictionary *)WiFi_A) objectForKey:WIFI_RSSI] integerValue]);
  NSInteger signalB = abs([[((NSDictionary *)WiFi_B) objectForKey:WIFI_RSSI] integerValue]);
  
  if (signalA < signalB) {
    return NSOrderedAscending;
  }
  else if (signalA > signalB) {
    return NSOrderedDescending;
  }
  else {
    return NSOrderedSame;
  }
}

- (NSArray *)networks
{
	return [networks sortedArrayUsingFunction:WiFiSignalCompare context:nil];
}

- (NSDictionary *)network:(NSString *)mac
{
  NSDictionary *wifi = nil;
  for (NSDictionary *network in networks) {
    if ([[network objectForKey:WIFI_MAC] isEqualToString:mac]) {
      wifi = network;
    }
  }
	return wifi;
}

- (NSString *)description
{
	NSMutableString *result = [[NSMutableString alloc] initWithString:@"Networks State: \n"];
	for (NSDictionary *network in networks) {
    NSString *wifiInfo = [NSString stringWithFormat:@"%@ (MAC: %@), RSSI: %@, Channel: %@ \n", [network objectForKey:WIFI_SSID], [network objectForKey:WIFI_MAC], [network objectForKey:WIFI_RSSI], [network objectForKey:WIFI_CHAN]];
		[result appendString:wifiInfo];
	}
	return [NSString stringWithString:[result autorelease]];
}

@end