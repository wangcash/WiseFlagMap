//
//  WFServiceManager.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-19.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@class WFMapClip;
@class WFCityPoint;
@class WFWiseFlag;

@protocol WFIndoorMapUpdatedDelegate <NSObject>
@required

- (void)indoorMapUpdated:(NSArray*)buildings;

@end

@interface WFServiceManager : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, retain) NSString* imei;

/**
 * 获得ServiceManager
 */
+ (WFServiceManager *)sharedInstance;



/********************************************************************************/
#pragma mark - 地图切片指纹访问
/********************************************************************************/

/**
 * 获得一个MapClip的FingerPrint
 */
+ (NSString*)fingerPrintForMapClipID:(NSString*)mapClipID;

/**
 * 设置或重写一个MapClip的FingerPrint
 */
+ (void)setFingerPrintForMapClipID:(NSString*)mapClipID fingerPrint:(NSString*)fingerPrint;



/********************************************************************************/
#pragma mark - 地图切片更新、下载方法
/********************************************************************************/

/**
 * 使用一个不完整路牌（只有mac、ssid、signal信息）来更新（同步方式下载）地图切片
 * 更新成功后返回地图切片
 * 更新失败或路牌信息无效返回nil
 */
- (WFMapClip*)updatingMapClipWithWiseFlag:(WFWiseFlag*)halfWiseFlag;

/**
 * 使用一个不完整路牌（只有mac、ssid、signal信息）来下载（异步方式下载）地图切片
 */
- (void)downloadMapClipWithWiseFlag:(WFWiseFlag*)halfWiseFlag;

/**
 * 使用地图切片ID来更新（同步方式下载）地图切片
 * 更新成功后返回地图切片
 * 更新失败或地图切片无效返回nil
 */
- (WFMapClip*)updatingMapClipWithID:(NSString*)mapClipID;

/**
 * 使用地图切片ID来下载（异步方式下载）地图切片
 */
- (void)downloadMapClipWithID:(NSString*)mapClipID;

/**
 * 使用地图切片ID列表来进行批量下载（异步方式下载）地图切片
 */
- (void)downloadMapClipsWithIDArray:(NSArray*)idArray;

/**
 * 使用城市代码来下载（异步方式下载）该城市内支持室内地图建筑清单
 */
- (void)downloadIndoorMapWithCity:(NSString*)city updatedDelegate:(id<WFIndoorMapUpdatedDelegate>)delegate;



#pragma mark - 
- (void)userRegister:(NSString*)mobile;
- (NSString*)userLogin:(NSString*)mobile password:(NSString*)password;
- (void)userLogout:(NSString*)mobile sessionId:(NSString*)sid;
- (void)userChangePassword:(NSString*)mobile sessionId:(NSString*)sid password:(NSString*)password newPassword:(NSString*)newPassword;
- (void)userResetPassword:(NSString*)mobile;

@end


