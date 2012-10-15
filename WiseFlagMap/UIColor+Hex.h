//
//  UIColor+Hex.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-25.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 \
                                                 alpha:1.0]

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHexString:(NSString *)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHexString:(NSString *)hexValue;
+ (UIColor *)whiteColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor *)blackColorWithAlpha:(CGFloat)alphaValue;
+ (NSString *)colorHexStringFromColorName:(NSString *)colorName;
+ (UIColor *)colorWithString:(NSString *)string;
@end
