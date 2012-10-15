//
//  WFAreaAnnotation.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-9.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFAnnotation.h"
#import "WFShape.h"

@interface WFAreaAnnotation : WFAnnotation<WFAnnotation>

//公共设施信息
//@property (nonatomic, retain) NSString * areaName;  //标注名称
//@property (nonatomic, retain) NSString * areaType;  //标注类型

@property (nonatomic, assign) CGAngleRect areaRect;  //区域矩形，一般为图形内嵌矩形。

- (id)initWithID:(NSString *)ID text:(NSString *)text image:(UIImage *)image inAreaShape:(WFShape<WFShape> *)shape alignment:(kWFAlignment)alignment;
- (id)initWithID:(NSString *)ID text:(NSString *)text image:(UIImage *)image inAreaShape:(WFShape<WFShape> *)shape;

@end
