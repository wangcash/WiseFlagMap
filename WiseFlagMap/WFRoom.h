//
//  WFRoom.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-9-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFShape.h"
#import "WFCityPoint.h"


@interface WFRoom : NSObject

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * mapclipID;

@property (nonatomic, readonly) WFShape * shape;

#pragma mark - 旧的实现

@property (nonatomic, retain) NSString* roomId;
@property (nonatomic, retain) NSString* roomName;
@property (nonatomic, retain) NSString* roomType;
@property (nonatomic, retain) WFShape*  roomShape;

@property (nonatomic, retain) WFCityPoint* centralCityPoint;

+ (WFRoom*)roomWithShape:(WFShape*)shape shapeIdString:(NSString*)idString;

- (NSComparisonResult)compareMethodWithRoomName:(WFRoom*)anotherRoom;

@end
