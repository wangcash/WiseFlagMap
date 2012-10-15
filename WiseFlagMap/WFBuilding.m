//
//  WFBuilding.m
//  部署有智能路牌的建筑.
//
//  Created by 汪 威 on 12-6-25.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFBuilding.h"
#import "WFFloor.h"

#define FloorNameKey  @"FloorName"
#define FloorLevelKey @"FloorLevel"
#define MapClipIDKey  @"MapClipID"
#define MapClipKey    @"MapClip"

@implementation WFBuilding
{
  NSString*       _ID;
  NSString*       _name;
  NSMutableArray* _floors;
}

@synthesize ID = _ID, name = _name;

static NSMutableDictionary* g_BuildingDict = nil;

+ (id)loadBuildingFromDictionary:(NSDictionary*)buildingDict
{
  WFBuilding* building = [WFBuilding buildingWithID:[buildingDict objectForKey:@"id"]
                                       buildingName:[buildingDict objectForKey:@"name"]];
  //插入楼层数据
  NSArray* floors = [buildingDict objectForKey:@"floors"];
  for (NSDictionary* floorDict in floors) {
    [building addFloorWithMapClipID:[floorDict objectForKey:@"clipId"]
                               name:[floorDict objectForKey:@"nameFloor"]
                              level:[[floorDict valueForKey:@"innerLevel"] integerValue]];
  }
  
  return building;
}

+ (id)buildingWithID:(NSString*)ID buildingName:(NSString*)name
{
  if (g_BuildingDict == nil) {
    g_BuildingDict = [[NSMutableDictionary alloc] init];
  }
  
  WFBuilding* building = [g_BuildingDict objectForKey:ID];
  
  if (building == nil) {
    building = [[[self alloc] initWithID:ID buildingName:name] autorelease];
    [g_BuildingDict setValue:building forKey:ID];
  }
  
  return building;
}

+ (id)buildingWithID:(NSString *)ID
{
  if (g_BuildingDict == nil) {
    g_BuildingDict = [[NSMutableDictionary alloc] init];
  }
  
  WFBuilding* building = [g_BuildingDict objectForKey:ID];
  
  if (building == nil) {
    building = [[[self alloc] initWithID:ID buildingName:@""] autorelease];
    [g_BuildingDict setValue:building forKey:ID];
  }
  
  return building;
}

+ (id)buildingWithMapClipID:(NSString*)mapClipID
{
  for (WFBuilding* building in [g_BuildingDict allValues]) {
    for (WFFloor* floor in building.floors) {
      if ([floor.mapClipID isEqualToString:mapClipID]) {
        return building;
      }
    }
  }
  return nil;
}

- (id)initWithID:(NSString*)ID buildingName:(NSString*)name
{
  self = [super init];
  if (self) {
    _ID = [ID copy];
    _name = [name copy];
    _floors = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_ID release], _ID = nil;
  [_name release], _name = nil;
  [_floors release], _floors = nil;
  [super dealloc];
}

#pragma mark - 
- (NSArray*)floors
{
  NSArray *floors = [_floors sortedArrayUsingSelector:@selector(compareMethodWithFloorLevel:)];
  return floors;
}

- (void)addFloorWithMapClipID:(NSString *)mapClipID name:(NSString *)name level:(NSInteger)level
{
  WFFloor *floor = nil;
  
  //遍历所有楼层，如果已经有对应MapClipID则拿到楼层对象指针赋值给floor，如果没有则保持floor为nil。
  for (WFFloor *f in _floors) {
    if ([f.mapClipID isEqualToString:mapClipID]) {
      floor = f;
      break;
    }
  }
  
  if (floor == nil) {
    //当前楼层不在列表中时，创建一个新楼层，在后面会加入到floors中。
    floor = [[WFFloor alloc] initWithMapClipID:mapClipID name:name level:level];
  }
  else {
    //这里也是要创建一个新楼层，不过在此之前，要先将floors中的移除啊亲，后面还是会自动加入到floors中，这里就不用丫担心了。
    [_floors removeObject:floor];
    floor = [[WFFloor alloc] initWithMapClipID:mapClipID name:name level:level];
  }
  
  //我是一段很NB的代码，不管上面如何执行，我都会把数据添加到floors中，V5吧。
  [_floors addObject:floor];
  //对了，后面别忘了释放，不然溢出哦！！
  [floor release];
}




@end
