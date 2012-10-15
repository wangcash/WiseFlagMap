//
//  WFPolygon.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"

@interface WFPolygon : WFShape<WFShape>
{
  NSString * _points;
}

/**
 * 多边形每个角的 x 和 y 坐标 <polygon points="220,100 300,210 170,250 123,234"/>
 * 不支持style属性
 */
@property (nonatomic, retain) NSString * points;

- (id)init;

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity points:(NSString *)points;


@end
