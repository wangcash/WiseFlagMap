//
//  WFServiceManager.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-19.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFServiceManager.h"
#import "JSONKit.h"

#import "WFWiseFlag.h"
#import "WFWiseFlagBox.h"
#import "NSString+MD5.h"

#import "WFDebug.h"

#define WiseFlagMapService @"http://211.151.61.93:7777"
//#define WiseFlagMapService @"http://s.wiseflag.com:7777"

NSString* IndoorMapDirectory(void)
{
  return WFMapClipDirectory();
}

static WFServiceManager* sharedServiceManager = nil;

@implementation WFServiceManager
{
  NSString*         _imei;
  ASINetworkQueue*  _queue;
  
  //各种Delegate
  id<WFIndoorMapUpdatedDelegate> _indoorMapUpdatedDelegate;
}

@synthesize imei = _imei;

+ (WFServiceManager*)sharedInstance
{
  if (!sharedServiceManager) {
    sharedServiceManager = [[WFServiceManager alloc] init];
  }
  return sharedServiceManager;
}

- (id)init
{
  if (self = [super init]) {
    if (!_queue) {
      _queue = [[ASINetworkQueue alloc] init];
      [_queue go];
    }
  }
  return self;
}

- (void)dealloc
{
  [_queue release], _queue = nil;
  [super dealloc];
}







/********************************************************************************/
#pragma mark - "Private" methods
/********************************************************************************/

/**
 * 获得MapClip指纹列表文件路径
 */
+ (NSString*)pathForMapClipPList
{
  NSString* dir = WFMapClipDirectory();
  return [dir stringByAppendingPathComponent:@"MapClips.plist"];
}

/**
 * 获得IndoorMap指纹列表文件路径
 */
+ (NSString*)pathForIndoorMapPList
{
  NSString* dir = WFMapClipDirectory();
  return [dir stringByAppendingPathComponent:@"IndoorMap.plist"];
}

/**
 * 返回imei属性经过MD5算法加密过的字符串，如imei为nil则返回空字符串。
 */
- (NSString*)imeiMD5
{
  if (_imei) {
    return [_imei md5];
  }
  else {
    return [NSString string];
  }
}

/**
 * 保存地图切片
 * 根据clips参数中的元素数量可保存一个或多个地图切片
 * sycn参数是基图文件（SVG文件）的下载方式，YES为同步下载，NO为异步下载
 */
- (void)saveMapClips:(NSArray*)clips syncBaseMap:(BOOL)sync
{
  for (NSDictionary* clipDict in clips) {
    NSString* mapClipID = [clipDict objectForKey:@"ID"];
    NSString* mapClipFingerPrint = [clipDict objectForKey:@"fingerprint"];
    
    //基图URL
    NSURL* urlBaseMap = [NSURL URLWithString:[clipDict objectForKey:@"basemap"]];
    
    NSString* jsonFilePath = [[WFMapClipDirectory() stringByAppendingPathComponent:mapClipID] stringByAppendingPathExtension:@"json"];
    NSString* svgFilePath = [[WFMapClipDirectory() stringByAppendingPathComponent:mapClipID] stringByAppendingPathExtension:@"svg"];
    
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
    NSLog(@"MapClipID:%@ FingerPrint:%@", mapClipID, mapClipFingerPrint);
    NSLog(@"urlBaseMap:%@", urlBaseMap);
    NSLog(@"jsonFilePath:%@", jsonFilePath);
    NSLog(@"svgFilePath:%@", svgFilePath);
#endif
    
    //保存MapClip文件
    [[clipDict JSONData] writeToFile:jsonFilePath atomically:YES];
    
    //下载对应基图文件
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:urlBaseMap];
    [request setDownloadDestinationPath:svgFilePath];
    if (sync) {
      [request startSynchronous];
    }
    else {
      [request startAsynchronous];
    }
    
    //更新MapClip指纹
    [WFServiceManager setFingerPrintForMapClipID:mapClipID fingerPrint:mapClipFingerPrint];
  }
}

- (BOOL)checkHalfWiseFlag:(WFWiseFlag*)halfWiseFlag
{
  if (halfWiseFlag == nil) {
    return NO;
  }
  if (halfWiseFlag.mac == nil || halfWiseFlag.mac.length == 0) {
    return NO;
  }
  if (halfWiseFlag.ssid == nil || halfWiseFlag.ssid.length == 0) {
    return NO;
  }
  if (halfWiseFlag.signalLevel == 0) {
    return NO;
  }
  return YES;
}

/**
 * 保存一个城市的IndoorMap
 */
- (void)saveIndoorMap:(NSDictionary*)indoorMap
{
  NSString* city = [indoorMap objectForKey:@"city"];
  NSString* indoorMapFingerPrint = [indoorMap objectForKey:@"fingerprint"];
  
  //TODO:此检查应该在接受数据时做，现在暂时放在这里，等通讯结构修改了在转移
  if (city == nil) {
    return;
  }
  
  NSString* indoorMapFilePath = [[IndoorMapDirectory() stringByAppendingPathComponent:city] stringByAppendingPathExtension:@"json"];
    
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  NSLog(@"city:%@ FingerPrint:%@", city, indoorMapFingerPrint);
  NSLog(@"indoorMapFilePath:%@", indoorMapFilePath);
#endif
    
  //保存IndoorMap文件
  [[indoorMap JSONData] writeToFile:indoorMapFilePath atomically:YES];
    
  //更新IndoorMap指纹
  [WFServiceManager setFingerPrintForCity:city fingerPrint:indoorMapFingerPrint];
}

/********************************************************************************/
#pragma mark - 指纹访问
/********************************************************************************/

#pragma mark 地图切片
/**
 * 获得一个MapClip的FingerPrint
 */
+ (NSString*)fingerPrintForMapClipID:(NSString*)mapClipID
{
  NSString* path = [WFServiceManager pathForMapClipPList];
  
  NSDictionary* mapClipsDict = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
  if ([mapClipsDict valueForKey:mapClipID] == nil) {
    return [NSString string];
  }
  else {
    return [mapClipsDict valueForKey:mapClipID];
  }
}

/**
 * 设置或重写一个MapClip的FingerPrint
 */
+ (void)setFingerPrintForMapClipID:(NSString*)mapClipID fingerPrint:(NSString*)fingerPrint
{
  if (mapClipID == nil || fingerPrint == nil) {
    return;
  }
  
  NSMutableDictionary* mapClipsDict;
  NSString* path = [WFServiceManager pathForMapClipPList];
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    mapClipsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
  }
  else {
    mapClipsDict = [[NSMutableDictionary alloc] init];
  }
  [mapClipsDict setValue:fingerPrint forKey:mapClipID];
  [mapClipsDict writeToFile:path atomically:YES];
  [mapClipsDict release];
}

#pragma mark IndoorMap
/**
 * 获得一个城市IndoorMap的指纹
 */
+ (NSString*)fingerPrintForCity:(NSString*)city
{
  NSString* path = [WFServiceManager pathForIndoorMapPList];
  
  NSDictionary* cityDict = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
  if ([cityDict valueForKey:city] == nil) {
    return [NSString string];
  }
  else {
    return [cityDict valueForKey:city];
  }
}

/**
 * 设置或重写一个城市IndoorMap指纹
 */
+ (void)setFingerPrintForCity:(NSString*)city fingerPrint:(NSString*)fingerPrint
{
  if (city == nil || fingerPrint == nil) {
    return;
  }
  
  NSMutableDictionary *cityDict;
  NSString *path = [WFServiceManager pathForIndoorMapPList];
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    cityDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
  }
  else {
    cityDict = [[NSMutableDictionary alloc] init];
  }
  [cityDict setValue:fingerPrint forKey:city];
  [cityDict writeToFile:path atomically:YES];
  [cityDict release];
}








/********************************************************************************/
#pragma mark - 地图切片更新、下载
/********************************************************************************/

/**
 * 使用一个不完整路牌（只有mac、ssid、signal信息）来更新（同步方式下载）地图切片
 * 更新成功后返回地图切片
 * 更新失败或路牌信息无效返回nil
 */
- (WFMapClip*)updatingMapClipWithWiseFlag:(WFWiseFlag*)halfWiseFlag
{
  //检查传入路牌是否可用
  if ([self checkHalfWiseFlag:halfWiseFlag] == NO) {
    return nil;
  }
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/map/whereAmI", WiseFlagMapService]];
  
  NSMutableDictionary *wiseflagDict = [[NSMutableDictionary alloc] init];
  [wiseflagDict setValue:halfWiseFlag.mac forKey:@"MAC"];
  [wiseflagDict setValue:halfWiseFlag.ssid forKey:@"SSID"];
  [wiseflagDict setValue:[NSString stringWithFormat:@"%d", halfWiseFlag.signalLevel] forKey:@"signalLevel"];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:wiseflagDict forKey:@"wiseFlag"];
  [requestDict setValue:[self imeiMD5] forKey:@"imei"];
  [requestDict setValue:@"" forKey:@"fingerprint"];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request startSynchronous];
  
  [wiseflagDict release];
  [requestDict release];
  
  NSError *error = [request error];
  if (error) {
    NSLog(@"error:%@", [error localizedDescription]);
    return nil;
  }
  
  NSData *responseData = [request responseData];
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
  NSString *code = [responseDict valueForKey:@"code"];
  
  if (![code isEqualToString:@"0"]) {
    NSLog(@"[%@]%@", code, [responseDict valueForKey:@"desc"]);
    return nil;
  }
  
  NSArray *clips = [responseDict objectForKey:@"clips"];
  
  NSDictionary *clipDict = [clips lastObject];
  
  if (clipDict == nil) {
    //服务器上没有对应的地图切片
    return nil;
  }

  [self saveMapClips:clips syncBaseMap:YES];
  
  //创建当前位置的MapClip
  return [WFMapClip MapClipWithMapClipID:[clipDict objectForKey:@"ID"]];
}

/**
 * 使用一个不完整路牌（只有mac、ssid、signal信息）来下载（异步方式下载）地图切片
 */
//TODO:没测试
- (void)downloadMapClipWithWiseFlag:(WFWiseFlag*)halfWiseFlag
{
  //检查传入路牌是否可用
  if ([self checkHalfWiseFlag:halfWiseFlag] == NO) {
    return;
  }
  
  //生成key
  NSString *key = [NSString stringWithFormat:@"/map/whereAmI?%@", halfWiseFlag.mac];
  
  //检查request是否已在queue
  for (ASIHTTPRequest *r in [_queue operations]) {
    NSString *k = [r.userInfo objectForKey:@"key"];
    if ([k isEqualToString:key]) {
      //队列中已存在request时，退出
      return;
    }
  }
  
  NSMutableDictionary *wiseflagDict = [[NSMutableDictionary alloc] init];
  [wiseflagDict setValue:halfWiseFlag.mac forKey:@"MAC"];
  [wiseflagDict setValue:halfWiseFlag.ssid forKey:@"SSID"];
  [wiseflagDict setValue:[NSString stringWithFormat:@"%d", halfWiseFlag.signalLevel] forKey:@"signalLevel"];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:wiseflagDict forKey:@"wiseFlag"];
  [requestDict setValue:[self imeiMD5] forKey:@"imei"];
  [requestDict setValue:@"" forKey:@"fingerprint"];
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/map/whereAmI", WiseFlagMapService]];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(downloadMapClipsComplete:)];
  [request setDidFailSelector:@selector(downloadMapClipsWentWrong:)];
  [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:key, @"key", nil]];
  [_queue addOperation:request];
  
  [wiseflagDict release];
  [requestDict release];
}

/**
 * 使用地图切片ID来更新（同步方式下载）地图切片
 * 更新成功后返回地图切片
 * 更新失败或地图切片无效返回nil
 */
- (WFMapClip*)updatingMapClipWithID:(NSString*)mapClipID
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/map/getRecentClip", WiseFlagMapService]];
  
  NSMutableDictionary *mapClipDict = [[NSMutableDictionary alloc] init];
  [mapClipDict setValue:mapClipID forKey:@"ID"];
  [mapClipDict setValue:[WFServiceManager fingerPrintForMapClipID:mapClipID] forKey:@"fingerprint"];
  
  NSMutableArray *mapClipArray = [[NSMutableArray alloc] initWithObjects:mapClipDict, nil];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:mapClipArray forKey:@"mapclips"];
  [requestDict setValue:[self imeiMD5] forKey:@"imei"];
  
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request startSynchronous];
  
  [mapClipDict release];
  [mapClipArray release];
  [requestDict release];
  
  NSError *error = [request error];
  if (error) {
    NSLog(@"error:%@", [error localizedDescription]);
    return nil;
  }
  
  NSData *responseData = [request responseData];
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
  NSString *code = [responseDict valueForKey:@"code"];
  
  if (![code isEqualToString:@"0"]) {
    NSLog(@"[%@]%@", code, [responseDict valueForKey:@"desc"]);
    return nil;
  }
  
  NSArray *clips = [responseDict objectForKey:@"clips"];
  
  [self saveMapClips:clips syncBaseMap:YES];
  
  //创建当前位置的MapClip
  return [WFMapClip MapClipWithMapClipID:mapClipID];
}

/**
 * 使用地图切片ID来下载（异步方式下载）地图切片
 */
- (void)downloadMapClipWithID:(NSString*)mapClipID
{
  [self downloadMapClipsWithIDArray:[NSArray arrayWithObject:mapClipID]];
}

/**
 * 使用地图切片ID列表来进行批量下载（异步方式下载）地图切片
 */
- (void)downloadMapClipsWithIDArray:(NSArray*)idArray
{
  //检查地图切片ID列表
  if (idArray == nil) {
    return;
  }
  if (idArray.count == 0) {
    return;
  }
  
  //生成key
  NSMutableString *IDs = [[NSMutableString alloc] init];
  for (NSString *ID in idArray) {
    [IDs appendFormat:@"%@,", ID];
  }
  NSString *key = [NSString stringWithFormat:@"/map/getRecentClip?%@", IDs];
  [IDs release];
  
  //检查request是否已在queue
  for (ASIHTTPRequest *r in [_queue operations]) {
    NSString *k = [r.userInfo objectForKey:@"key"];
    if ([k isEqualToString:key]) {
      //队列中已存在request时，退出
      return;
    }
  }
  
  NSMutableArray *mapClipArray = [[NSMutableArray alloc] init];
  for (NSInteger i=0; i < idArray.count; i++) {
    NSString *mapClipID = [idArray objectAtIndex:i];
    NSString *fingerPrint = [WFServiceManager fingerPrintForMapClipID:mapClipID];
    NSMutableDictionary *mapClipDict = [[NSMutableDictionary alloc] init];
    [mapClipDict setValue:mapClipID forKey:@"ID"];
    [mapClipDict setValue:fingerPrint forKey:@"fingerprint"];
    [mapClipArray addObject:mapClipDict];
    [mapClipDict release];
  }
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:mapClipArray forKey:@"mapclips"];
  [requestDict setValue:[self imeiMD5] forKey:@"imei"];
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/map/getRecentClip", WiseFlagMapService]];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(downloadMapClipsComplete:)];
  [request setDidFailSelector:@selector(downloadMapClipsWentWrong:)];
  [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:key, @"key", nil]];
  [_queue addOperation:request];
  
  [requestDict release];
  [mapClipArray release];
}

/********************************************************************************/
#pragma mark 异步下载回调接口
/********************************************************************************/

/**
 * MapClip下载完毕，拆包保存。
 */
- (void)downloadMapClipsComplete:(ASIHTTPRequest*)request
{
  NSData *responseData = [request responseData];
  
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  NSLog(@"code:%@", [responseDict valueForKey:@"code"]);
  NSLog(@"desc:%@", [responseDict valueForKey:@"desc"]);
#endif
  
  NSArray *clips = [responseDict objectForKey:@"clips"];
  
  [self saveMapClips:clips syncBaseMap:NO];
  
  [request clearDelegatesAndCancel];
}

/**
 * MapClip下载时发生错误。
 */
- (void)downloadMapClipsWentWrong:(ASIHTTPRequest*)request
{
  NSError *error = [request error];
  NSLog(@"error:%@", error);
  [request clearDelegatesAndCancel];
}

/********************************************************************************/
#pragma mark - IndoorMap下载接口
/********************************************************************************/

/**
 * 使用城市代码来下载（异步方式下载）该城市内支持室内地图建筑清单
 */
- (void)downloadIndoorMapWithCity:(NSString*)city updatedDelegate:(id<WFIndoorMapUpdatedDelegate>)delegate
{
  //检查传入参数
  if (city == nil) {
    return;
  }
  if (city.length == 0) {
    return;
  }
  
  _indoorMapUpdatedDelegate = delegate;
  
  //生成key
  NSString *key = [NSString stringWithFormat:@"/map/indoormap?%@", city];
  
  //检查request是否已在queue
  for (ASIHTTPRequest *r in [_queue operations]) {
    NSString *k = [r.userInfo objectForKey:@"key"];
    if ([k isEqualToString:key]) {
      //队列中已存在request时，退出
      return;
    }
  }
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:city forKey:@"city"];
  [requestDict setValue:[WFServiceManager fingerPrintForCity:city] forKey:@"fingerprint"];
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/map/indoormap", WiseFlagMapService]];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(downloadIndoorMapComplete:)];
  [request setDidFailSelector:@selector(downloadIndoorMapWentWrong:)];
  [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:key, @"key", city, @"city", nil]];
  [_queue addOperation:request];
  
  [requestDict release];
}

/********************************************************************************/
#pragma mark 异步下载回调接口
/********************************************************************************/

/**
 * IndoorMap下载完毕，拆包保存。
 */
- (void)downloadIndoorMapComplete:(ASIHTTPRequest*)request
{
  NSData* responseData = [request responseData];
  
  NSDictionary* responseDict = [responseData objectFromJSONData];
  
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  NSLog(@"code:%@", [responseDict valueForKey:@"code"]);
  NSLog(@"desc:%@", [responseDict valueForKey:@"desc"]);
#endif
  
  NSDictionary *indoorMap = [responseDict objectForKey:@"building"];
  
  [self saveIndoorMap:indoorMap];
  
  NSString* city = [[request userInfo] objectForKey:@"city"];
  if (city) {
    [self loadIndoorMap:city];
  }
  
  [request clearDelegatesAndCancel];
}

/**
 * IndoorMap下载时发生错误。
 */
- (void)downloadIndoorMapWentWrong:(ASIHTTPRequest*)request
{
  NSError* error = [request error];
  NSLog(@"error:%@", error);
  
  NSString* city = [[request userInfo] objectForKey:@"city"];
  if (city) {
    [self loadIndoorMap:city];
  }
  
  [request clearDelegatesAndCancel];
}


- (void)loadIndoorMap:(NSString*)city
{
  if (city == nil) {
    return;
  }
  
  NSString* indoorMapFilePath = [[IndoorMapDirectory() stringByAppendingPathComponent:city] stringByAppendingPathExtension:@"json"];
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:indoorMapFilePath]) {
    NSData* jsonData = [NSData dataWithContentsOfFile:indoorMapFilePath];
    NSDictionary* indoorMapDict = [jsonData objectFromJSONData];
    NSArray* buildings = [indoorMapDict objectForKey:@"buildings"];
    if ([_indoorMapUpdatedDelegate respondsToSelector:@selector(indoorMapUpdated:)]) {
      [_indoorMapUpdatedDelegate indoorMapUpdated:buildings];
    }
  }
}



#pragma mark - 用户接口

//后台接口协议-用户注册

- (void)userRegister:(NSString*)mobile
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/reg", WiseFlagMapService]];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:mobile forKey:@"mobile"];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request startSynchronous];
  
  NSLog(@"%@", [requestDict JSONString]);
  NSLog(@"%@", [request responseString]);

  [requestDict release];
  
  NSError *error = [request error];
  if (error) {
    NSLog(@"error:%@", [error localizedDescription]);
    return;
  }
  
  NSData *responseData = [request responseData];
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
  NSString *code = [responseDict valueForKey:@"code"];
  
  if (![code isEqualToString:@"0"]) {
    NSString* desc = [responseDict valueForKey:@"code"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"出错"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:[NSString stringWithFormat:@"[%@]%@", code, desc]
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
  }
  else {
    NSString* desc = [responseDict valueForKey:@"desc"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:desc
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  return;
}

//后台接口协议-用户登录
- (NSString*)userLogin:(NSString*)mobile password:(NSString*)password
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/login", WiseFlagMapService]];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:mobile forKey:@"mobile"];
  [requestDict setValue:[password md5] forKey:@"password"];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request startSynchronous];
  
  NSLog(@"%@", [requestDict JSONString]);
  NSLog(@"%@", [request responseString]);
  
  [requestDict release];
  
  NSError *error = [request error];
  if (error) {
    NSLog(@"error:%@", [error localizedDescription]);
    return nil;
  }
  
  NSData *responseData = [request responseData];
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
  NSString *code = [responseDict valueForKey:@"code"];
  
  if (![code isEqualToString:@"0"]) {
    NSString* desc = [responseDict valueForKey:@"code"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"出错"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:[NSString stringWithFormat:@"[%@]%@", code, desc]
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return nil;
  }
  else {
    NSString* desc = [responseDict valueForKey:@"desc"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:desc
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return [responseDict valueForKey:@"sid"];
  }
}

//后台接口协议-用户登出
- (void)userLogout:(NSString*)mobile sessionId:(NSString*)sid
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/logout", WiseFlagMapService]];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:mobile forKey:@"mobile"];
  [requestDict setValue:sid forKey:@"sid"];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request startSynchronous];
  
  NSLog(@"%@", [requestDict JSONString]);
  NSLog(@"%@", [request responseString]);
  
  [requestDict release];
  
  NSError *error = [request error];
  if (error) {
    NSLog(@"error:%@", [error localizedDescription]);
    return;
  }
  
  NSData *responseData = [request responseData];
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
  NSString *code = [responseDict valueForKey:@"code"];
  
  if (![code isEqualToString:@"0"]) {
    NSString* desc = [responseDict valueForKey:@"code"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"出错"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:[NSString stringWithFormat:@"[%@]%@", code, desc]
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
  }
  else {
    NSString* desc = [responseDict valueForKey:@"desc"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:desc
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  return;
}

//后台接口协议-修改密码
- (void)userChangePassword:(NSString*)mobile sessionId:(NSString*)sid password:(NSString*)password newPassword:(NSString*)newPassword
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/changePw", WiseFlagMapService]];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:mobile forKey:@"mobile"];
  [requestDict setValue:sid forKey:@"sid"];
  [requestDict setValue:[password md5] forKey:@"oldpassword"];
  [requestDict setValue:[newPassword md5] forKey:@"password"];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request startSynchronous];
  
  NSLog(@"%@", [requestDict JSONString]);
  NSLog(@"%@", [request responseString]);
  
  [requestDict release];
  
  NSError *error = [request error];
  if (error) {
    NSLog(@"error:%@", [error localizedDescription]);
    return;
  }
  
  NSData *responseData = [request responseData];
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
  NSString *code = [responseDict valueForKey:@"code"];
  
  if (![code isEqualToString:@"0"]) {
    NSString* desc = [responseDict valueForKey:@"code"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"出错"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:[NSString stringWithFormat:@"[%@]%@", code, desc]
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  else {
    NSString* desc = [responseDict valueForKey:@"desc"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:desc
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  return;
}

//后台协议-密码重置
- (void)userResetPassword:(NSString*)mobile
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/resetPw", WiseFlagMapService]];
  
  NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
  [requestDict setValue:mobile forKey:@"mobile"];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setPostBody:(NSMutableData *)[requestDict JSONData]];
  [request startSynchronous];
  
  NSLog(@"%@", [requestDict JSONString]);
  NSLog(@"%@", [request responseString]);
  
  [requestDict release];
  
  NSError *error = [request error];
  if (error) {
    NSLog(@"error:%@", [error localizedDescription]);
    return;
  }
  
  NSData *responseData = [request responseData];
  NSDictionary *responseDict = [responseData objectFromJSONData];
  
  NSString *code = [responseDict valueForKey:@"code"];
  
  if (![code isEqualToString:@"0"]) {
    NSString* desc = [responseDict valueForKey:@"code"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"出错"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:[NSString stringWithFormat:@"[%@]%@", code, desc]
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
  }
  else {
    NSString* desc = [responseDict valueForKey:@"desc"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:desc
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  return;
}

@end