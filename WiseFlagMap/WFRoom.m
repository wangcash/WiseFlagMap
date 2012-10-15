//
//  WFRoom.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-9-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFRoom.h"
#import "JSONKit.h"

@implementation WFRoom

@synthesize ID, name, type, mapclipID;
@synthesize shape;

#pragma mark - 旧的实现

@synthesize roomId, roomName, roomType, roomShape;
@synthesize centralCityPoint;

+ (WFRoom*)roomWithShape:(WFShape*)shape shapeIdString:(NSString*)idString
{
  if (shape == nil) {
    return nil;
  }
  
  if (idString == nil) {
    return nil;
  }
  
  //ID格式：{|k|:|DaYueChen_Fl_Jack|,|n|:|A1|,|t|:|SHOP|,|nwl|:[{|w|:|23:33:34:21:11|},{|w|:|24:33:34:21:11|}]}
  
  //编码转换
  //_x7B_ = {
  //_x7C_ = |
  //_x5F_ = _
  //_x2C_ = ,
  //_x7D_ = }
  //_x27_ = ’
  idString = [idString stringByReplacingOccurrencesOfString:@"_x7B_" withString:@"{"];
  idString = [idString stringByReplacingOccurrencesOfString:@"_x7C_" withString:@"|"];
  idString = [idString stringByReplacingOccurrencesOfString:@"_x5F_" withString:@"_"];
  idString = [idString stringByReplacingOccurrencesOfString:@"_x2C_" withString:@","];
  idString = [idString stringByReplacingOccurrencesOfString:@"_x7D_" withString:@"}"];
  idString = [idString stringByReplacingOccurrencesOfString:@"_x27_" withString:@"‘"];
  
  NSString* json = [idString stringByReplacingOccurrencesOfString:@"|" withString:@"\""]; //转义“|”
  NSDictionary* dictShapeId = [json objectFromJSONString];
  
  //判断ID是否是JSON格式
  if (dictShapeId.count > 0) {
    NSString* key  = [dictShapeId objectForKey:@"k"];
    NSString* name = [dictShapeId objectForKey:@"n"];
    NSString* type = [dictShapeId objectForKey:@"t"];
    //TODO:nwl暂时没解析处理
    
    WFRoom* room = [[WFRoom alloc] initWithRoomId:key roomName:name roomType:type roomShape:shape];
    return [room autorelease];
  }
  else {
    return nil;
  }
}

- (WFRoom*)initWithRoomId:(NSString*)ID roomName:(NSString*)name roomType:(NSString*)type roomShape:(WFShape*)shape
{
  self = [super init];
  if (self) {
    self.roomId    = ID;
    self.roomName  = name;
    self.roomType  = type;
    self.roomShape = shape;
  }
  return self;
}

- (NSComparisonResult)compareMethodWithRoomName:(WFRoom*)anotherRoom
{
  return [self.roomName compare:anotherRoom.roomName];
}

@end
