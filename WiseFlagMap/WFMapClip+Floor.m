//
//  WFMapClip+Floor.m
//  ZzPark
//
//  Created by 汪 威 on 12-9-5.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import "WFMapClip+Floor.h"
#import "WFBuilding.h"

@implementation WFMapClip (Floor)

- (void)initCategory
{
  if (_category == nil) {
    _category = [[NSMutableDictionary alloc] init];
  }
}

#define FloorNameKey @"FloorName"
- (void)setFloorName:(NSString*)floorName
{
  [self initCategory];
  [_category setValue:floorName forKey:FloorNameKey];
}
- (NSString*)floorName
{
  [self initCategory];
  return [_category objectForKey:FloorNameKey];
}

#define FloorLevelKey @"FloorLevel"
- (void)setFloorLevel:(NSInteger)floorLevel
{
  [self initCategory];
  [_category setValue:[NSNumber numberWithInteger:floorLevel] forKey:FloorLevelKey];
}
- (NSInteger)floorLevel
{
  [self initCategory];
  return [[_category objectForKey:FloorLevelKey] integerValue];
}

#define BuildingKey @"Building"
- (void)setBuilding:(WFBuilding*)building
{
  [self initCategory];
  [_category setValue:building forKey:BuildingKey];
}
- (WFBuilding*)building
{
  [self initCategory];
  WFBuilding* building = [_category objectForKey:BuildingKey];
  if (building == nil) {
    building = [WFBuilding buildingWithMapClipID:self.ID];
  }
  return building;
}



@end
