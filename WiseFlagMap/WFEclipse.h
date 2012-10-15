//
//  WFEclipse.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"

@interface WFEclipse : WFShape<WFShape>
{
  CGFloat _cx;
  CGFloat _cy;
  CGFloat _rx;
  CGFloat _ry;
}

@property (nonatomic) CGFloat cx; //属性定义圆点的 x 坐标
@property (nonatomic) CGFloat cy; //属性定义圆点的 y 坐标
@property (nonatomic) CGFloat rx; //属性定义水平半径
@property (nonatomic) CGFloat ry; //属性定义垂直半径

- (id)init;

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity cx:(NSString *)cx cy:(NSString *)cy rx:(NSString *)rx ry:(NSString *)ry;

@end