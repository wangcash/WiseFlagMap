//
//  WFBuilding.h
//  部署有智能路牌的建筑.
//
//  Created by 汪 威 on 12-6-25.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFMapClip;

@interface WFBuilding : NSObject

@property (nonatomic, readonly) NSString* ID;

/**
 * 建筑物名称.
 */
@property (nonatomic, readonly) NSString* name;

/**
 * 建筑内部所有楼层列表.
 */
@property (nonatomic, readonly) NSArray*  floors;

/**
 * 建筑轮廓线.一般情况下为一层建筑轮廓线.
 */
//private List<GeoPoint> buildingOutline;


+ (id)loadBuildingFromDictionary:(NSDictionary*)buildingDict;

+ (id)buildingWithID:(NSString*)ID buildingName:(NSString*)name;

+ (id)buildingWithMapClipID:(NSString*)mapClipID;

- (void)addFloorWithMapClipID:(NSString *)mapClipID name:(NSString *)name level:(NSInteger)level;


@end
