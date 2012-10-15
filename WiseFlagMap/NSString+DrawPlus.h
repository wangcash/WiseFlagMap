//
//  NSString+DrawPlus.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-3.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DrawPlus)
- (CGRect)rectWithCenterPoint:(CGPoint)point withFont:(UIFont *)font;
- (CGSize)drawAtCenterPoint:(CGPoint)point withFont:(UIFont *)font; // Uses UILineBreakModeWordWrap

- (CGRect)rectWithTopCenterPoint:(CGPoint)point withFont:(UIFont *)font;
- (CGSize)drawAtTopCenterPoint:(CGPoint)point withFont:(UIFont *)font; // Uses UILineBreakModeWordWrap

- (CGRect)rectWithBottomCenterPoint:(CGPoint)point withFont:(UIFont *)font;
- (CGSize)drawAtBottomCenterPoint:(CGPoint)point withFont:(UIFont *)font; // Uses UILineBreakModeWordWrap

- (CGRect)rectWithLeftCenterPoint:(CGPoint)point withFont:(UIFont *)font;
- (CGSize)drawAtLeftCenterPoint:(CGPoint)point withFont:(UIFont *)font; // Uses UILineBreakModeWordWrap

- (CGRect)rectWithRightCenterPoint:(CGPoint)point withFont:(UIFont *)font;
- (CGSize)drawAtRightCenterPoint:(CGPoint)point withFont:(UIFont *)font; // Uses UILineBreakModeWordWrap



@end
