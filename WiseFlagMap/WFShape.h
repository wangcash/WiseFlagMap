//
//  WFShape.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Hex.h"
#import "WFGeometry.h"

#import "WFDebug.h"


#pragma Mark - WFShape interface
@interface WFShape : NSObject

@property (nonatomic, readonly) NSString  * TAG;          //标签名称
@property (nonatomic, retain)   NSString  * ID;           //标签ID
@property (nonatomic, retain)   UIColor   * stroke;       //画笔颜色
@property (nonatomic)           CGFloat     stroke_width; //画笔宽度
@property (nonatomic, retain)   UIColor   * fill;         //填充颜色
@property (nonatomic)           CGFloat     opacity;      //透明度.
@property (nonatomic)           CGFloat     stroke_miterlimit;//指定角度的浮点值，在该角度以上，尖角的尖端将被一个线段截断。
                                                              //这意味着只有在尖角大于 miterLimit 的值的情况下，才会截断尖角.

- (id)init;
- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity;

/**
 * 返回当前图形的中心点（内嵌最大矩形中心点）
 */
- (CGPoint)centerPoint;

+ (id)shapeWithXmlElement:(id)element;
@end


#pragma Mark - WFShape protocol
@protocol WFShape
@required

/**
 * 当前图形标签名称
 */
- (NSString *)TAG;

/**
 * 检测形状是部分或者全部在指定的区域内.
 * @param bound
 * @return
 */
- (BOOL)isInBound:(CGRect)bound;

/**
 * 检测形状是部分或者全部在指定的区域内.
 * @param bound
 * @param scale
 * @return
 */
- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale;

/**
 * 检测点是否在形状内.
 * @param point
 * @return
 */
- (BOOL)isPointInShape:(CGPoint)point;

/**
 * 在context上绘制当前图形
 */
- (void)drawShape:(CGContextRef)context atScale:(CGFloat)scale;

/**
 * 检查当前图形是否与bound发生碰撞，并在context上绘制
 */
- (BOOL)drawShape:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale;

/**
 * 返回当前图形的内嵌最大矩形
 */
- (CGAngleRect)insideRect;

/**
 * 返回当前图形的外括最小矩形
 */
- (CGAngleRect)outsideRect;

@optional

/**
 * 返回当前图形的内嵌最大矩形
 */
- (CGAngleRect)insideRectAtScale:(CGFloat)scale;

/**
 * 返回当前图形的中心点（内嵌最大矩形中心点）
 */
- (CGPoint)centerPoint;

//废弃的方法稍后删除
- (NSString *)childXMLElement;

@end