//
//  WFMapView+Location.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-8-16.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFMapView.h"

@interface WFMapView (Location)

- (void)redrawCurrentLocation;
- (void)showCurrentLocation;
- (void)hideCurrentLocation;

@end
