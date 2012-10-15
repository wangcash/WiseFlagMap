//
//  WFTiledMapView.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-30.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFMapClip;

@interface WFTiledMapView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic, retain) WFMapClip * mapClip;

- (id)initWithFrame:(CGRect)frame atScale:(CGFloat)scale;

@end


