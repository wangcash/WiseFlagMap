//
//  WFAnnotation.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-8.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFGeometry.h"
#import "WFHitTester.h"

#define WFAnnotationDefaultFontName  (@"Helvetica-Bold")
#define WFAnnotationDefaultFontSize  (12.0f)
#define WFAnnotationDefaultFontColor [UIColor blackColor]

#define WFAnnotationDefaultFont [UIFont fontWithName:WFAnnotationDefaultFontName size:WFAnnotationDefaultFontSize]


#pragma Mark - WFAnnotation interface
@interface WFAnnotation : NSObject

@property (nonatomic, readonly) NSString   * ID;        //标签ID
@property (nonatomic, assign  ) CGPoint      point;     //标注坐标
@property (nonatomic, assign  ) kWFAlignment alignment; //对齐方式
@property (nonatomic, readonly) id           shape;     //标注图形

@property (nonatomic, assign  ) CGFloat      alpha;     //CG 透明度
@property (nonatomic, assign  ) CGBlendMode  blendMode; //CG

//@property (nonatomic, readonly) CGPoint centerOffset;   //
//@property (nonatomic, readonly) CGPoint calloutOffset;  //

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point alignment:(kWFAlignment)alignment;
- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape alignment:(kWFAlignment)alignment;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape;

@end

#pragma Mark - WFAnnotation protocol
@protocol WFAnnotation

@required
/**
 * 获得标注的尺寸
 */
- (CGSize)boundSize;

/**
 * 获得标注的边框矩形
 * 只显示文本时仅为文本边框
 * 只显示图片时仅为图片边框
 * 文本和图片同时显示时边框为图片和文本的外接最小矩形
 */
- (CGAngleRect)boundRectAtScale:(CGFloat)scale;

/**
 * 检测标注是部分或者全部在指定的区域内.
 * @param bound
 * @param scale
 * @return
 */
- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale;

/**
 * 在context上绘制当前标注
 */
- (void)drawAnnotation:(CGContextRef)context atScale:(CGFloat)scale hitTester:(WFHitTester *)hitTester;

/**
 * 检查当前图形是否与bound发生碰撞，并在context上绘制
 */
- (BOOL)drawAnnotation:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale hitTester:(WFHitTester *)hitTester;

/**
 * 检测点是否在标注内.
 * @param point
 * @return
 */
- (BOOL)isPointInAnnotation:(CGPoint)point;



@optional

/**
 * 在context上绘制当前标注
 */
- (void)drawAnnotation:(CGContextRef)context atScale:(CGFloat)scale;

/**
 * 检查当前图形是否与bound发生碰撞，并在context上绘制
 */
- (BOOL)drawAnnotation:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale;

/**
 * 返回标注中间点的CGPoint
 */
- (CGPoint)centerOffset;

/**
 * 返回标注气泡的CGPoint
 */
- (CGPoint)calloutOffset;


@end