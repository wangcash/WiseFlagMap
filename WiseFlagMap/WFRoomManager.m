//
//  WFRoomManager.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-9-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFRoomManager.h"

static WFRoomManager * sharedRoomManager = nil;

@implementation WFRoomManager
{
  NSMutableDictionary * _dictMapClips;
}

+ (WFRoomManager *)sharedInstance
{
  if (!sharedRoomManager) {
    sharedRoomManager = [[WFRoomManager alloc] init];
  }
  return sharedRoomManager;
}

- (id)init
{
  self = [super init];
  if (self) {
    _dictMapClips = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_dictMapClips release], _dictMapClips = nil;
  [super dealloc];
}

- (void)addRoom:(WFRoom *)room mapClipID:(NSString *)mapClipID
{
  room.centralCityPoint = [WFCityPoint cityPointWithMapClipID:mapClipID CGPoint:[room.roomShape centerPoint]];
  
  NSMutableDictionary *dictRooms = [_dictMapClips objectForKey:mapClipID];
  if (dictRooms == nil) {
    dictRooms = [[[NSMutableDictionary alloc] init] autorelease];
  }
  [dictRooms setValue:room forKey:room.roomId];
  [_dictMapClips setValue:dictRooms forKey:mapClipID];
}

- (WFRoom *)roomWithRoomId:(NSString *)roomId
{
  for (NSDictionary *dictRooms in [_dictMapClips allValues]) {
    WFRoom *room = [dictRooms objectForKey:roomId];
    return room;
  }
  return nil;
}

- (NSArray *)roomsWithMapClipID:(NSString *)mapClipID
{
  NSDictionary *dictRooms = [_dictMapClips objectForKey:mapClipID];
  if (dictRooms == nil) {
    return nil;
  }
  NSArray *rooms = [dictRooms allValues];
  return rooms;
}

- (NSArray *)allRooms
{
  NSMutableArray *rooms = [[NSMutableArray alloc] init];
  for (NSDictionary *dictRooms in [_dictMapClips allValues]) {
    [rooms addObjectsFromArray:[dictRooms allValues]];
  }
  return [rooms autorelease];
}

- (NSArray *)allBusinessRooms
{
  NSMutableArray *rooms = [[NSMutableArray alloc] init];
  for (NSDictionary *dictRooms in [_dictMapClips allValues]) {
    for (WFRoom *room in [dictRooms allValues]) {
      if ([room.roomType isEqualToString:@"SHOP"]) {
        [rooms addObject:room];
      }
    }
  }
  return [rooms autorelease];
}

- (NSArray *)searchAllRoomsWithKeyword:(NSString *)keyword
{
  NSMutableArray *rooms = [[NSMutableArray alloc] init];
  return [rooms autorelease];
}

@end
