//
//  WFMapClip+Floor.h
//  ZzPark
//
//  Created by 汪 威 on 12-9-5.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import "WFMapClip.h"

@class WFBuilding;

@interface WFMapClip (Floor)

/**
 * 名义楼成名.
 */
@property (nonatomic, retain) NSString* floorName;

/**
 * 实际楼层.
 */
@property (nonatomic, assign) NSInteger floorLevel;

/**
 * 楼层切片所属建筑.
 */
@property (nonatomic, retain) WFBuilding* building;



@end
