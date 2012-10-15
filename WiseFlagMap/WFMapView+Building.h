//
//  WFMapView+Building.h
//  ZzPark
//
//  Created by 汪 威 on 12-8-31.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import "WFMapView.h"
#import "WFBuilding.h"

@interface WFMapView (Building)

- (WFBuilding*)currentBuilding;

- (void)downloadBuilding;
  
@end
