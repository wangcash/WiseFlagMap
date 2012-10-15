//
//  WFLine.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"

@interface WFLine : WFShape<WFShape>
{
  CGFloat _x1;
  CGFloat _y1;
  CGFloat _x2;
  CGFloat _y2;
}

@property (nonatomic) CGFloat x1; //属性在 x 轴定义线条的开始
@property (nonatomic) CGFloat y1; //在 y 轴定义线条的开始
@property (nonatomic) CGFloat x2; //在 x 轴定义线条的结束
@property (nonatomic) CGFloat y2; //在 y 轴定义线条的结束

@property (nonatomic) CGLineCap lineCap; //线条两端样式

- (id)init;

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity x1:(NSString *)x1 y1:(NSString *)y1 x2:(NSString *)x2 y2:(NSString *)y2;

@end
