//
//  WFUserMap.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFMapClip;
@class WFCityPoint;

@interface WFUserMap : NSObject

/**
 * 获得一个UserMap实例
 */
+ (WFUserMap *)sharedInstance;

/**
 * 生成图形和标注
 */
- (void)generateShapesForMapClip:(WFMapClip *)mapClip;
- (void)generateAnnotationsForMapClip:(WFMapClip *)mapClip;

/**
 * 获得所有用户图层中的图形.
 */
- (NSArray *)allShapes;

/**
 * 获得当前边框中的用户图层中的图形.
 */
- (NSArray *)inBoundShapes:(CGRect)bound atScale:(CGFloat)scale;

/**
 * 获得所有用户图层中的标注.
 */
- (NSArray *)allAnnotations;

/**
 * 获得当前边框中的用户图层中的标注.
 */
- (NSArray *)inBoundAnnotations:(CGRect)bound atScale:(CGFloat)scale;

- (void)showNavigation:(NSArray *)wiseflagArray startCityPoint:(WFCityPoint *)start endCityPoint:(WFCityPoint *)end;


@end
