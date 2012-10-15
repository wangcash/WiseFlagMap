//
//  WFFloor.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-9-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFFloor.h"

@implementation WFFloor

@synthesize mapClipID = _mapClipID, name = _name, level = _level;

- (id)initWithMapClipID:(NSString*)mapClipID name:(NSString*)name level:(NSInteger)level
{
  self = [super init];
  if (self) {
    self.mapClipID = mapClipID;
    self.name      = name;
    self.level     = level;
  }
  return self;
}

- (NSComparisonResult)compareMethodWithFloorLevel:(WFFloor*)anotherFloor
{
  if (self.level < anotherFloor.level) {
    return NSOrderedAscending;
  }
  else if (self.level > anotherFloor.level) {
    return NSOrderedDescending;
  }
  else {
    return NSOrderedSame;
  }
}


@end
