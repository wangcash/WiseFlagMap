//
//  UIColor+Hex.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-25.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
  return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 
                         green:((float)((hexValue & 0xFF00) >> 8))/255.0 
                          blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue
{
  return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alphaValue
{
  if (hexString == nil || hexString.length == 0) {
    return [UIColor blackColor];
  }
  
  NSString *hexColorString;
  if ([hexString characterAtIndex:0] == '#') {
    hexColorString = [hexString substringFromIndex:1];
  }
  else {
    hexColorString = hexString;
  }
  
  NSInteger hexColorInteger;
  
  sscanf([hexColorString UTF8String], "%lx", &hexColorInteger);
  
  return [UIColor colorWithHex:hexColorInteger alpha:alphaValue];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
  if (hexString == nil || hexString.length == 0) {
    return [UIColor blackColor];
  }
  
  NSString *hexColorString;
  if ([hexString characterAtIndex:0] == '#') {
    hexColorString = [hexString substringFromIndex:1];
  }
  else {
    hexColorString = hexString;
  }
  
  NSInteger hexColorInteger;
  
  sscanf([hexColorString UTF8String], "%lx", &hexColorInteger);
    
  return [UIColor colorWithHex:hexColorInteger];
}

+ (UIColor *)whiteColorWithAlpha:(CGFloat)alphaValue
{
  return [UIColor colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor *)blackColorWithAlpha:(CGFloat)alphaValue
{
  return [UIColor colorWithHex:0x000000 alpha:alphaValue];
}

+ (NSString *)colorHexStringFromColorName:(NSString *)colorName
{
  NSString *colorValue = nil;
  if ([colorName isEqualToString:@"aliceblue"])
    colorValue = @"#F0F8FF";
  if ([colorName isEqualToString:@"antiquewhite"])
    colorValue = @"#FAEBD7";
  if ([colorName isEqualToString:@"aqua"])
    colorValue = @"#00FFFF";
  if ([colorName isEqualToString:@"aquamarine"])
    colorValue = @"#7FFFD4";
  if ([colorName isEqualToString:@"azure"])
    colorValue = @"#F0FFFF";
  if ([colorName isEqualToString:@"beige"])
    colorValue = @"#F5F5DC";
  if ([colorName isEqualToString:@"bisque"])
    colorValue = @"#FFE4C4";
  if ([colorName isEqualToString:@"black"])
    colorValue = @"#000000";
  if ([colorName isEqualToString:@"blanchedalmond"])
    colorValue = @"#FFEBCD";
  if ([colorName isEqualToString:@"blue"])
    colorValue = @"#0000FF";
  if ([colorName isEqualToString:@"blueviolet"])
    colorValue = @"#8A2BE2";
  if ([colorName isEqualToString:@"brown"])
    colorValue = @"#A52A2A";
  if ([colorName isEqualToString:@"burlywood"])
    colorValue = @"#DEB887";
  if ([colorName isEqualToString:@"cadetblue"])
    colorValue = @"#5F9EA0";
  if ([colorName isEqualToString:@"chartreuse"])
    colorValue = @"#7FFF00";
  if ([colorName isEqualToString:@"chocolate"])
    colorValue = @"#D2691E";
  if ([colorName isEqualToString:@"coral"])
    colorValue = @"#FF7F50";
  if ([colorName isEqualToString:@"cornflowerblue"])
    colorValue = @"#6495ED";
  if ([colorName isEqualToString:@"cornsilk"])
    colorValue = @"#FFF8DC";
  if ([colorName isEqualToString:@"crimson"])
    colorValue = @"#DC143C";
  if ([colorName isEqualToString:@"cyan"])
    colorValue = @"#00FFFF";
  if ([colorName isEqualToString:@"darkblue"])
    colorValue = @"#00008B";
  if ([colorName isEqualToString:@"darkcyan"])
    colorValue = @"#008B8B";
  if ([colorName isEqualToString:@"darkgoldenrod"])
    colorValue = @"#B8860B";
  if ([colorName isEqualToString:@"darkgray"])
    colorValue = @"#A9A9A9";
  if ([colorName isEqualToString:@"darkgreen"])
    colorValue = @"#006400";
  if ([colorName isEqualToString:@"darkkhaki"])
    colorValue = @"#BDB76B";
  if ([colorName isEqualToString:@"darkmagenta"])
    colorValue = @"#8B008B";
  if ([colorName isEqualToString:@"darkolivegreen"])
    colorValue = @"#556B2F";
  if ([colorName isEqualToString:@"darkorange"])
    colorValue = @"#FF8C00";
  if ([colorName isEqualToString:@"darkorchid"])
    colorValue = @"#9932CC";
  if ([colorName isEqualToString:@"darkred"])
    colorValue = @"#8B0000";
  if ([colorName isEqualToString:@"darksalmon"])
    colorValue = @"#E9967A";
  if ([colorName isEqualToString:@"darkseagreen"])
    colorValue = @"#8FBC8F";
  if ([colorName isEqualToString:@"darkslateblue"])
    colorValue = @"#483D8B";
  if ([colorName isEqualToString:@"darkslategray"])
    colorValue = @"#2F4F4F";
  if ([colorName isEqualToString:@"darkturquoise"])
    colorValue = @"#00CED1";
  if ([colorName isEqualToString:@"darkviolet"])
    colorValue = @"#9400D3";
  if ([colorName isEqualToString:@"deeppink"])
    colorValue = @"#FF1493";
  if ([colorName isEqualToString:@"deepskyblue"])
    colorValue = @"#00BFFF";
  if ([colorName isEqualToString:@"dimgray"])
    colorValue = @"#696969";
  if ([colorName isEqualToString:@"dodgerblue"])
    colorValue = @"#1E90FF";
  if ([colorName isEqualToString:@"firebrick"])
    colorValue = @"#B22222";
  if ([colorName isEqualToString:@"floralwhite"])
    colorValue = @"#FFFAF0";
  if ([colorName isEqualToString:@"forestgreen"])
    colorValue = @"#228B22";
  if ([colorName isEqualToString:@"fuchsia"])
    colorValue = @"#FF00FF";
  if ([colorName isEqualToString:@"gainsboro"])
    colorValue = @"#DCDCDC";
  if ([colorName isEqualToString:@"ghostwhite"])
    colorValue = @"#F8F8FF";
  if ([colorName isEqualToString:@"gold"])
    colorValue = @"#FFD700";
  if ([colorName isEqualToString:@"goldenrod"])
    colorValue = @"#DAA520";
  if ([colorName isEqualToString:@"gray"])
    colorValue = @"#808080";
  if ([colorName isEqualToString:@"green"])
    colorValue = @"#008000";
  if ([colorName isEqualToString:@"greenyellow"])
    colorValue = @"#ADFF2F";
  if ([colorName isEqualToString:@"honeydew"])
    colorValue = @"#F0FFF0";
  if ([colorName isEqualToString:@"hotpink"])
    colorValue = @"#FF69B4";
  if ([colorName isEqualToString:@"indianred"])
    colorValue = @"#CD5C5C";
  if ([colorName isEqualToString:@"indigo"])
    colorValue = @"#4B0082";
  if ([colorName isEqualToString:@"ivory"])
    colorValue = @"#FFFFF0";
  if ([colorName isEqualToString:@"khaki"])
    colorValue = @"#F0E68C";
  if ([colorName isEqualToString:@"lavender"])
    colorValue = @"#E6E6FA";
  if ([colorName isEqualToString:@"lavenderblush"])
    colorValue = @"#FFF0F5";
  if ([colorName isEqualToString:@"lawngreen"])
    colorValue = @"#7CFC00";
  if ([colorName isEqualToString:@"lemonchiffon"])
    colorValue = @"#FFFACD";
  if ([colorName isEqualToString:@"lightblue"])
    colorValue = @"#ADD8E6";
  if ([colorName isEqualToString:@"lightcoral"])
    colorValue = @"#F08080";
  if ([colorName isEqualToString:@"lightcyan"])
    colorValue = @"#E0FFFF";
  if ([colorName isEqualToString:@"lightgoldenrodyellow"])
    colorValue = @"#FAFAD2";
  if ([colorName isEqualToString:@"lightgreen"])
    colorValue = @"#90EE90";
  if ([colorName isEqualToString:@"lightgrey"])
    colorValue = @"#D3D3D3";
  if ([colorName isEqualToString:@"lightpink"])
    colorValue = @"#FFB6C1";
  if ([colorName isEqualToString:@"lightsalmon"])
    colorValue = @"#FFA07A";
  if ([colorName isEqualToString:@"lightseagreen"])
    colorValue = @"#20B2AA";
  if ([colorName isEqualToString:@"lightskyblue"])
    colorValue = @"#87CEFA";
  if ([colorName isEqualToString:@"lightslategray"])
    colorValue = @"#778899";
  if ([colorName isEqualToString:@"lightsteelblue"])
    colorValue = @"#B0C4DE";
  if ([colorName isEqualToString:@"lightyellow"])
    colorValue = @"#FFFFE0";
  if ([colorName isEqualToString:@"lime"])
    colorValue = @"#00FF00";
  if ([colorName isEqualToString:@"limegreen"])
    colorValue = @"#32CD32";
  if ([colorName isEqualToString:@"linen"])
    colorValue = @"#FAF0E6";
  if ([colorName isEqualToString:@"magenta"])
    colorValue = @"#FF00FF";
  if ([colorName isEqualToString:@"maroon"])
    colorValue = @"#800000";
  if ([colorName isEqualToString:@"mediumaquamarine"])
    colorValue = @"#66CDAA";
  if ([colorName isEqualToString:@"mediumblue"])
    colorValue = @"#0000CD";
  if ([colorName isEqualToString:@"mediumorchid"])
    colorValue = @"#BA55D3";
  if ([colorName isEqualToString:@"mediumpurple"])
    colorValue = @"#9370DB";
  if ([colorName isEqualToString:@"mediumseagreen"])
    colorValue = @"#3CB371";
  if ([colorName isEqualToString:@"mediumslateblue"])
    colorValue = @"#7B68EE";
  if ([colorName isEqualToString:@"mediumspringgreen"])
    colorValue = @"#00FA9A";
  if ([colorName isEqualToString:@"mediumturquoise"])
    colorValue = @"#48D1CC";
  if ([colorName isEqualToString:@"mediumvioletred"])
    colorValue = @"#C71585";
  if ([colorName isEqualToString:@"midnightblue"])
    colorValue = @"#191970";
  if ([colorName isEqualToString:@"mintcream"])
    colorValue = @"#F5FFFA";
  if ([colorName isEqualToString:@"mistyrose"])
    colorValue = @"#FFE4E1";
  if ([colorName isEqualToString:@"moccasin"])
    colorValue = @"#FFE4B5";
  if ([colorName isEqualToString:@"navajowhite"])
    colorValue = @"#FFDEAD";
  if ([colorName isEqualToString:@"navy"])
    colorValue = @"#000080";
  if ([colorName isEqualToString:@"oldlace"])
    colorValue = @"#FDF5E6";
  if ([colorName isEqualToString:@"olive"])
    colorValue = @"#808000";
  if ([colorName isEqualToString:@"olivedrab"])
    colorValue = @"#6B8E23";
  if ([colorName isEqualToString:@"orange"])
    colorValue = @"#FFA500";
  if ([colorName isEqualToString:@"orangered"])
    colorValue = @"#FF4500";
  if ([colorName isEqualToString:@"orchid"])
    colorValue = @"#DA70D6";
  if ([colorName isEqualToString:@"palegoldenrod"])
    colorValue = @"#EEE8AA";
  if ([colorName isEqualToString:@"palegreen"])
    colorValue = @"#98FB98";
  if ([colorName isEqualToString:@"paleturquoise"])
    colorValue = @"#AFEEEE";
  if ([colorName isEqualToString:@"palevioletred"])
    colorValue = @"#DB7093";
  if ([colorName isEqualToString:@"papayawhip"])
    colorValue = @"#FFEFD5";
  if ([colorName isEqualToString:@"peachpuff"])
    colorValue = @"#FFDAB9";
  if ([colorName isEqualToString:@"peru"])
    colorValue = @"#CD853F";
  if ([colorName isEqualToString:@"pink"])
    colorValue = @"#FFC0CB";
  if ([colorName isEqualToString:@"plum"])
    colorValue = @"#DDA0DD";
  if ([colorName isEqualToString:@"powderblue"])
    colorValue = @"#B0E0E6";
  if ([colorName isEqualToString:@"purple"])
    colorValue = @"#800080";
  if ([colorName isEqualToString:@"red"])
    colorValue = @"#FF0000";
  if ([colorName isEqualToString:@"rosybrown"])
    colorValue = @"#BC8F8F";
  if ([colorName isEqualToString:@"royalblue"])
    colorValue = @"#4169E1";
  if ([colorName isEqualToString:@"saddlebrown"])
    colorValue = @"#8B4513";
  if ([colorName isEqualToString:@"salmon"])
    colorValue = @"#FA8072";
  if ([colorName isEqualToString:@"sandybrown"])
    colorValue = @"#F4A460";
  if ([colorName isEqualToString:@"seagreen"])
    colorValue = @"#2E8B57";
  if ([colorName isEqualToString:@"seashell"])
    colorValue = @"#FFF5EE";
  if ([colorName isEqualToString:@"sienna"])
    colorValue = @"#A0522D";
  if ([colorName isEqualToString:@"silver"])
    colorValue = @"#C0C0C0";
  if ([colorName isEqualToString:@"skyblue"])
    colorValue = @"#87CEEB";
  if ([colorName isEqualToString:@"slateblue"])
    colorValue = @"#6A5ACD";
  if ([colorName isEqualToString:@"slategray"])
    colorValue = @"#708090";
  if ([colorName isEqualToString:@"snow"])
    colorValue = @"#FFFAFA";
  if ([colorName isEqualToString:@"springgreen"])
    colorValue = @"#00FF7F";
  if ([colorName isEqualToString:@"steelblue"])
    colorValue = @"#4682B4";
  if ([colorName isEqualToString:@"tan"])
    colorValue = @"#D2B48C";
  if ([colorName isEqualToString:@"teal"])
    colorValue = @"#008080";
  if ([colorName isEqualToString:@"thistle"])
    colorValue = @"#D8BFD8";
  if ([colorName isEqualToString:@"tomato"])
    colorValue = @"#FF6347";
  if ([colorName isEqualToString:@"turquoise"])
    colorValue = @"#40E0D0";
  if ([colorName isEqualToString:@"violet"])
    colorValue = @"#EE82EE";
  if ([colorName isEqualToString:@"wheat"])
    colorValue = @"#F5DEB3";
  if ([colorName isEqualToString:@"white"])
    colorValue = @"#FFFFFF";
  if ([colorName isEqualToString:@"whitesmoke"])
    colorValue = @"#F5F5F5";
  if ([colorName isEqualToString:@"yellow"])
    colorValue = @"#FFFF00";
  if ([colorName isEqualToString:@"yellowgreen"])
    colorValue = @"#9ACD32";
  return colorValue;
}

+ (UIColor *)colorWithString:(NSString *)string
{
  if (string == nil || string.length == 0) {
    return nil;
  }
  
  if ([string isEqualToString:@"none"]) {
    return nil;
  }
  
  if ([string characterAtIndex:0] == '#') {
    return [UIColor colorWithHexString:string];
  }
  
  NSString *colorValue = [UIColor colorHexStringFromColorName:string];
  return [UIColor colorWithHexString:colorValue];
}

@end
