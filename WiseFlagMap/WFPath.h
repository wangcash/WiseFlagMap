//
//  WFPath.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"

@interface WFPath : WFShape<WFShape>
{
  NSString * _d;
}

/**
 * 路径。
 * 
 * 下面的命令可用于路径数据：
 * 
 * M = moveto L = lineto H = horizontal lineto V = vertical lineto C = curveto S
 * = smooth curveto Q = quadratic Belzier curve T = smooth quadratic Belzier
 * curveto A = elliptical Arc Z = closepath
 * 
 * 以上所有命令均允许小写字母。大写表示绝对定位，小写表示相对定位。
 * 
 */
@property (nonatomic, retain) NSString * d;

- (id)init;

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity d:(NSString *)d;

@end
