//
//  WFWiseFlagMap.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-31.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFMapClip;

@interface WFWiseFlagMap : NSObject

/**
 * 创建一个空的WiseFlagMap
 */
- (id)init;

/**
 * 给MapClip创建WiseFlagMap，读入当前MapClip.ID为文件名的WFM文件来初始化WiseFlagMap。
 */
- (id)initWithMapClip:(WFMapClip *)mapClip;

/**
 * 增加一个路牌
 */
- (void)addWiseFlag:(id)wiseflag;


//增加一个路径，debug用
- (void)addWiseFlagPath:(id)wiseflagPath;

/**
 * 生成图形和标注
 */
- (void)generateShapes;
- (void)generateAnnotations;

/**
 * 获得所有路牌图层中的图形.
 */
- (NSArray *)allShapes;

/**
 * 获得当前边框中的路牌图层中的图形.
 */
- (NSArray *)inBoundShapes:(CGRect)bound atScale:(CGFloat)scale;

/**
 * 获得所有路牌图层中的标注.
 */
- (NSArray *)allAnnotations;

/**
 * 获得当前边框中的路牌图层中的标注.
 */
- (NSArray *)inBoundAnnotations:(CGRect)bound atScale:(CGFloat)scale;

@end
