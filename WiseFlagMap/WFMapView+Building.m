//
//  WFMapView+Building.m
//  ZzPark
//
//  Created by 汪 威 on 12-8-31.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import "WFMapView+Building.h"
#import "WFServiceManager.h"
#import "WFMapClip.h"
#import "WFMapClip+Floor.h"
#import "WFFloor.h"

@implementation WFMapView (Building)

- (WFBuilding*)currentBuilding
{
  return [_mapClip building];
}


- (void)downloadBuilding
{
  WFBuilding* building = [_mapClip building];
  
  NSMutableArray* arrayMapClipID = [[NSMutableArray alloc] init];
  for (WFFloor* floor in building.floors) {
    if (![floor.mapClipID isEqualToString:_mapClip.ID]) {
      [arrayMapClipID addObject:floor.mapClipID];
    }
  }
  
  WFServiceManager* serviceManager = [WFServiceManager sharedInstance];
  [serviceManager downloadMapClipsWithIDArray:arrayMapClipID];
  [arrayMapClipID release];
}
@end
