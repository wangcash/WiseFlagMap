//
//  WFPolyline.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-12.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"

@interface WFPolyline : WFShape<WFShape>
{
  NSString * _points;
}

/**
 * 多点线每个节点的 x 和 y 坐标 <polyline points="220,100 300,210 170,250 123,234"/>
 * 不支持style属性
 */
@property (nonatomic, retain) NSString * points;

- (id)init;

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity points:(NSString *)points;

@end
