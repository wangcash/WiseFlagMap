//
//  WFWiseFlagBox.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFWiseFlagBox.h"
#import "JSONKit.h"
#import "PESGraph.h"
#import "PESGraphNode.h"
#import "PESGraphEdge.h"
#import "PESGraphRoute.h"
#import "PESGraphRouteStep.h"

#import "WFMapClip.h"
#import "WFMapClip+Floor.h"
#import "WFWiseFlag.h"
#import "WFWiseFlagMap.h"
#import "WFFlagPath.h"
#import "WFBuilding.h"

#import "WFDebug.h"

@implementation WFWiseFlagBox
{
  NSMutableArray* _wiseflagArray;
  NSMutableArray* _wiseflagPathArray;
  
  NSMutableSet*   _mapClipSet;
}

static WFWiseFlagBox* g_WiseFlagBox = nil;

+ (WFWiseFlagBox*)sharedInstance
{
  if (g_WiseFlagBox == nil) {
    g_WiseFlagBox = [[self alloc] init];
  }
  return g_WiseFlagBox;
}

- (id)init
{
  self = [super init];
  if (self) {
    _wiseflagArray = [[NSMutableArray alloc] init];
    _wiseflagPathArray = [[NSMutableArray alloc] init];
    
    _mapClipSet = [[NSMutableSet alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_wiseflagArray release], _wiseflagArray = nil;
  [_wiseflagPathArray release], _wiseflagPathArray = nil;
  
  [_mapClipSet release], _mapClipSet = nil;
  [super dealloc];
}


#pragma mark - 旧版本方法

- (void)loadWiseFlagWithMapClip:(WFMapClip*)mapClip
{
  NSString* mapClipID = mapClip.ID;
  NSString* filePath = [[WFMapClipDirectory() stringByAppendingPathComponent:mapClipID] stringByAppendingPathExtension:@"json"];
  NSData*   jsonData = [NSData dataWithContentsOfFile:filePath];
  
  if (jsonData == nil) {
    return;
  }
  
  //解析Json结构
  NSDictionary* jsonDict = [jsonData objectFromJSONData];
  
//  NSLog(@"ID:%@", [jsonDict objectForKey:@"ID"]);
//  NSLog(@"fingerprint:%@", [jsonDict objectForKey:@"fingerprint"]);
//  NSLog(@"basemap:%@", [jsonDict objectForKey:@"basemap"]);
  
  //解析建筑、创建Building对象
  NSDictionary* buildingDict = [jsonDict objectForKey:@"building"];
  WFBuilding* building = [WFBuilding loadBuildingFromDictionary:buildingDict];
//  WFBuilding* building = [WFBuilding buildingWithID:[buildingDict objectForKey:@"id"]
//                                       buildingName:[buildingDict objectForKey:@"name"]];
//  //插入楼层数据
//  NSArray* floors = [buildingDict objectForKey:@"floors"];
//  for (NSDictionary* floorDict in floors) {
//    [building addFloorWithMapClipID:[floorDict objectForKey:@"clipId"]
//                               name:[floorDict objectForKey:@"nameFloor"]
//                              level:[[floorDict valueForKey:@"innerLevel"] integerValue]];
//  }
  //建立MapClip和Building关系
  [mapClip setBuilding:building];
  
  //解析路牌数据
  NSArray* wiseflags = [jsonDict objectForKey:@"flagMap"];
  
  for (NSDictionary* wiseflagDict in wiseflags) {
    
    WFWiseFlag* wiseflag = [[WFWiseFlag alloc] init];
    
    wiseflag.shortName   = [wiseflagDict objectForKey:@"ShortName"];
    wiseflag.longName    = [wiseflagDict objectForKey:@"LongName"];
    wiseflag.mac         = [wiseflagDict objectForKey:@"MAC"];
    wiseflag.ssid        = [wiseflagDict objectForKey:@"SSID"];
    wiseflag.ID          = [wiseflagDict objectForKey:@"ID"];
    wiseflag.signalLevel = [[wiseflagDict objectForKey:@"signalLevel"] integerValue];
    wiseflag.fake        = [[wiseflagDict objectForKey:@"IsFake"] isEqualToString:@"false"] ? NO : YES;
    
    NSDictionary* cityPointDict = [wiseflagDict objectForKey:@"cityPoint"];
//    NSLog(@"MapClipID : %@", [cityPointDict objectForKey:@"MapClipID"]);
    
    NSDictionary* svgPointDict = [cityPointDict objectForKey:@"svgPoint"];
    
    NSNumber* x = [svgPointDict valueForKey:@"x"];
    NSNumber* y = [svgPointDict valueForKey:@"y"];
    
//    wiseflag.cityPoint = [[[WFCityPoint alloc] initWithMapClip:mapClip x:x.floatValue y:y.floatValue] autorelease];
    wiseflag.cityPoint = [WFCityPoint cityPointWithMapClipID:mapClipID x:x y:y];
    
    //解析路牌相关路径
    NSArray* flagPaths = [wiseflagDict objectForKey:@"flagPathlist"];
    for (NSDictionary* flagPathDict in flagPaths) {
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
//      NSLog(@"distance:%@", [flagPathDict objectForKey:@"distance"]);
//      NSLog(@"AccessType:%@", [flagPathDict objectForKey:@"AccessType"]);
//      NSLog(@"accessable:%@", [flagPathDict objectForKey:@"accessable"]);
//      NSLog(@"Direction:%@", [flagPathDict objectForKey:@"Direction"]);
//
//      NSDictionary *wiseFlagA = [flagPathDict objectForKey:@"wiseFlagA"];
//      NSLog(@"wiseflag a mac:%@", [wiseFlagA objectForKey:@"MAC"]);
//      
//      NSDictionary *wiseFlagB = [flagPathDict objectForKey:@"wiseFlagB"];
//      NSLog(@"wiseflag b mac:%@", [wiseFlagB objectForKey:@"MAC"]);
#endif
      WFFlagPath* flagPath = [[WFFlagPath alloc] initWithMacForWiseFlagA:[[flagPathDict objectForKey:@"wiseFlagA"]
                                                                          objectForKey:@"MAC"] 
                                                      andMacForWiseFlagB:[[flagPathDict objectForKey:@"wiseFlagB"] 
                                                                          objectForKey:@"MAC"]
                                                       defaultAccessable:[flagPathDict objectForKey:@"accessable"]
                                                                distance:[flagPathDict objectForKey:@"distance"]];
      [self addFlagPath:flagPath];
      [flagPath release];
    }
    
    [self addWiseFlag:wiseflag];
    [wiseflag release];
  }
  
}



//使用MapClip获得路牌列表
- (WFWiseFlagMap*)wiseflagMap:(WFMapClip*)mapClip
{
  
  //当前WiseFlagMap还没读入
  if ([_mapClipSet containsObject:mapClip.ID] == NO) {
    [self loadWiseFlagWithMapClip:mapClip];
    [_mapClipSet addObject:mapClip.ID];
  }
  
  //创建WiseFlagMap
  WFWiseFlagMap *wiseflagMap = [[[WFWiseFlagMap alloc] init] autorelease];
  
  
  
  //查找属于MapClip的WiseFlag，加入到WiseFlagMap中。
  for (WFWiseFlag *wiseflag in _wiseflagArray) {
    if ([wiseflag.mapClipID isEqualToString:mapClip.ID]) {
      [wiseflagMap addWiseFlag:wiseflag];
    }
  }

#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  //在调试时候创建出当前MapClip的FlagPath，并显示所有路径
  for (WFFlagPath *path in _wiseflagPathArray) {
    if ([path.wiseflagA.mapClipID isEqualToString:mapClip.ID] &&[path.wiseflagB.mapClipID isEqualToString:mapClip.ID]) {
      [wiseflagMap addWiseFlagPath:path];
    }
  }
#endif
  
  //根据wiseflag生成路线和标注
  [wiseflagMap generateShapes];
  [wiseflagMap generateAnnotations];
  
  return wiseflagMap;
}

//使用ID查找路牌
- (WFWiseFlag*)wiseflagWithID:(NSString*)ID
{
  for (WFWiseFlag *wiseflag in _wiseflagArray) {
    if ([wiseflag.ID isEqualToString:ID]) {
      return wiseflag;
    }
  }
  return nil;
}

//使用mac查找路牌
- (WFWiseFlag*)wiseflagWithMac:(NSString*)mac
{
  for (WFWiseFlag *wiseflag in _wiseflagArray) {
    if ([wiseflag.mac isEqualToString:mac]) {
      return wiseflag;
    }
  }
  return nil;
}



//找到CityPoint的就近路牌
- (WFWiseFlag*)nearWiseFlagWithCityPoint:(WFCityPoint*)cityPoint
{
  WFWiseFlag *nearWiseFlag = nil;
  
  for (WFWiseFlag *wiseflag in _wiseflagArray) {
    //字处理同一MapClip的路牌
    if ([wiseflag.mapClipID isEqualToString:cityPoint.mapClipID]) {
      if (nearWiseFlag == nil) {
        nearWiseFlag = wiseflag;
      }
      
      //比较路牌距离，保存最近的路牌
      if ([cityPoint distance:nearWiseFlag.cityPoint] > [cityPoint distance:wiseflag.cityPoint]) {
        nearWiseFlag = wiseflag;
      }
    }
  }
  return nearWiseFlag;
}

//增加一个空路牌
- (void)addNullWiseFlag:(WFWiseFlag*)wiseflag
{
  WFWiseFlag *wiseflagInBox = [self wiseflagWithMac:wiseflag.mac];
  if (wiseflagInBox == nil) {
    //Box中无相同的路牌，加入空路牌
    [_wiseflagArray addObject:wiseflag];
  }
}

//增加一个路牌或填充一个路牌
- (void)addWiseFlag:(WFWiseFlag*)wiseflag
{
  WFWiseFlag *wiseflagInBox = [self wiseflagWithMac:wiseflag.mac];
  if (wiseflagInBox == nil) {
    //Box中无相同的路牌，加入新的路牌
    [_wiseflagArray addObject:wiseflag];
  }
  else {
    //Box中有相同路牌，覆盖路牌
    [wiseflagInBox copy:wiseflag];
  }
}

//增加一个路径
- (void)addFlagPath:(WFFlagPath*)flagpath
{
  //TODO:相同路径排除处理
  [_wiseflagPathArray addObject:flagpath];
}

//使用两个路牌进行导航，返回路牌列表
- (NSArray*)routeSearchWithStartWiseFlag:(WFWiseFlag*)start andEndWiseFlag:(WFWiseFlag*)end
{
  PESGraph *graph = [[PESGraph alloc] init];
  
  NSMutableDictionary *nodes = [[NSMutableDictionary alloc] init];
  
  for (WFWiseFlag *wiseflag in _wiseflagArray) {
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
//    NSLog(@"%@", wiseflag.debugDescription);
#endif
    PESGraphNode *newNode = [PESGraphNode nodeWithIdentifier:wiseflag.mac];
    [nodes setObject:newNode forKey:newNode.identifier];
  }
  
  for (WFFlagPath *flagpath in _wiseflagPathArray) {
    NSString *path = flagpath.debugDescription;
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
//    NSLog(@"%@", path);
#endif
    PESGraphNode *nodeA = [nodes objectForKey:flagpath.wiseflagA.mac];
    PESGraphNode *nodeB = [nodes objectForKey:flagpath.wiseflagB.mac];
    
    NSNumber *distance = [NSNumber numberWithFloat:flagpath.distance];
    
    switch (flagpath.defaultAccessable) {
      case kWFAccessableAtoB:
        [graph addEdge:[PESGraphEdge edgeWithName:path andWeight:distance] fromNode:nodeA toNode:nodeB];
        break;
        
      case kWFAccessableBtoA:
        [graph addEdge:[PESGraphEdge edgeWithName:path andWeight:distance] fromNode:nodeB toNode:nodeA];
        break;
        
      case kWFAccessableBoth:
        [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:path andWeight:distance] fromNode:nodeA toNode:nodeB];
        break;
        
      case kWFAccessableLocked:
        break;
    }
  }
  
  //TODO:通行规则处理
  
  NSMutableArray *routeArray = [[NSMutableArray alloc] init];
  
  PESGraphRoute *route = [graph shortestRouteFromNode:[nodes objectForKey:start.mac] 
                                               toNode:[nodes objectForKey:end.mac]];
  
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
//  NSLog(@"%@", route);
#endif
  
  for (PESGraphRouteStep *step in route.steps) {
    [routeArray addObject:[self wiseflagWithMac:step.node.identifier]];
  }
  
  [graph release];
  [nodes release];
  
  return [routeArray autorelease];
}



//使用两个CityPoint进行导航
- (NSArray*)routeSearchWithStartCityPoint:(WFCityPoint*)start andEndCityPoint:(WFCityPoint*)end
{
  WFWiseFlag *startWiseFlag = [self nearWiseFlagWithCityPoint:start];
  WFWiseFlag *endWiseFlag = [self nearWiseFlagWithCityPoint:end];
  return [self routeSearchWithStartWiseFlag:startWiseFlag andEndWiseFlag:endWiseFlag];
}

@end
