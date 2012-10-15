//
//  WFBaseMap.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-31.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFMapClip;

@interface WFBaseMap : NSObject

@property (nonatomic) CGFloat x;      //地图的左上角TopX.
@property (nonatomic) CGFloat y;      //地图的左上角TopY.
@property (nonatomic) CGFloat width;  //BaseMap宽.
@property (nonatomic) CGFloat height; //BaseMap高.

@property (nonatomic) CGRect  viewBox;

@property (nonatomic, retain) NSString * MapClipID; //基图对应的地图切片ID.在装载数据时置入,原始数据中没有MapClipId.

/**
 * 给MapClip创建BaseMap，读入当前MapClip.ID为文件名的SVG文件来初始化BaseMap。
 */
- (id)initWithMapClip:(WFMapClip *)mapClip;

/**
 * 获得所有基图中图形.
 */
- (NSArray *)allShapes;

/**
 * 获得当前边框中的基图中图形.
 */
//- (NSArray *)inBoundShapes:(CGRect)bound;

/**
 * 获得当前边框中的基图中图形.
 */
- (NSArray *)inBoundShapes:(CGRect)bound atScale:(CGFloat)scale;

/**
 * 获得所有基图中标注.
 */
- (NSArray *)allAnnotations;

/**
 * 获得当前边框中的基图中标注.
 */
//- (NSArray *)inBoundAnnotations:(CGRect)bound;

/**
 * 获得当前边框中的基图中标注.
 */
- (NSArray *)inBoundAnnotations:(CGRect)bound atScale:(CGFloat)scale;
@end
