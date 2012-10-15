//
//  WFRichAnnotation.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-15.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFAnnotation.h"

typedef enum {
  kWFRichAnnotationAdditionNone = 0,
  kWFRichAnnotationRightAddition,     //在右边附加
  kWFRichAnnotationBottomAddition,    //在下边附加
  kWFRichAnnotationLeftAddition,      //在左边附加
  kWFRichAnnotationTopAddition,       //在上边附加
} kWFRichAnnotationAddition;

@interface WFRichAnnotation : WFAnnotation<WFAnnotation>

@property (nonatomic, retain) WFAnnotation * main;
@property (nonatomic, retain) WFAnnotation * addition;

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point image:(UIImage *)image title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;
- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point image:(UIImage *)image title:(NSString *)title;
  
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape image:(UIImage *)image title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape image:(UIImage *)image title:(NSString *)title;

@end
