//
//  WFTextAnnotation.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-14.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFAnnotation.h"

@interface WFTextAnnotation : WFAnnotation<WFAnnotation>

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) UIFont   * titleFont;
@property (nonatomic, retain) UIColor  * titleColor;

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point alignment:(kWFAlignment)alignment title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;
- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point alignment:(kWFAlignment)alignment title:(NSString *)title titleFont:(UIFont *)font;
- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point alignment:(kWFAlignment)alignment title:(NSString *)title;

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;
- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point title:(NSString *)title titleFont:(UIFont *)font;
- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point title:(NSString *)title;

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape alignment:(kWFAlignment)alignment title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape alignment:(kWFAlignment)alignment title:(NSString *)title titleFont:(UIFont *)font;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape alignment:(kWFAlignment)alignment title:(NSString *)title;

- (id)initWithID:(NSString *)ID inAreaShape:(id)shape title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape title:(NSString *)title titleFont:(UIFont *)font;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape title:(NSString *)title;

- (void)drawAnnotation:(CGContextRef)context atPoint:(CGPoint)point alignment:(kWFAlignment)alignment;

@end
