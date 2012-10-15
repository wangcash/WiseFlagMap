//
//  WFRoomManager.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-9-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFRoom.h"

@interface WFRoomManager : NSObject

+ (WFRoomManager*)sharedInstance;

- (void)addRoom:(WFRoom*)room mapClipID:(NSString*)mapClipID;

- (WFRoom*)roomWithRoomId:(NSString*)roomId;

- (NSArray*)roomsWithMapClipID:(NSString*)mapClipID;

- (NSArray*)allRooms;

- (NSArray*)allBusinessRooms;

- (NSArray*)searchAllRoomsWithKeyword:(NSString*)keyword;

@end
