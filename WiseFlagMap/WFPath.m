//
//  WFPath.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFPath.h"
#import "SVGPointsAndPathsParser.h"

@implementation WFPath
{
  CGPathRef _path;
}

@synthesize d = _d;

- (id)init
{
  self = [super init];
  if (self) {
    self.d = nil;
  }
  [self parseData:self.d];
  return self;
}

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity d:(NSString *)d
{
  self = [super initWithID:ID
                    stroke:stroke 
               strokeWidth:strokeWidth 
          strokeMiterlimit:strokeMiterLimit 
                      fill:fill 
                   opacity:opacity];
  if (self) {
    self.d = d;
  }
  [self parseData:self.d];
  return self;
}

- (void)setD:(NSString *)aData
{
  if (_d) {
    [_d release];
    _d = nil;
	}
	
	if (aData) {
		_d = [aData retain];
	}
  
  [self parseData:self.d];
}

- (void)setPath:(CGPathRef)aPath
{
	if (_path) {
		CGPathRelease(_path);
		_path = NULL;
	}
	
	if (aPath) {
		_path = CGPathCreateCopy(aPath);
	}
}

- (void)parseData:(NSString *)data
{
  if (data == nil) {
    return;
  }
	CGMutablePathRef path = CGPathCreateMutable();
  NSScanner *dataScanner = [NSScanner scannerWithString:data];
  CGPoint lastCoordinate = CGPointZero;
  SVGCurve lastCurve = SVGCurveZero;
  BOOL foundCmd;
  
  do {
    NSCharacterSet *knownCommands = [NSCharacterSet characterSetWithCharactersInString:@"MmLlCcVvHhAaSsQqTtZz"];
    NSString *command = nil;
    foundCmd = [dataScanner scanCharactersFromSet:knownCommands intoString:&command];
    
    if (foundCmd) {
      if ([@"z" isEqualToString:command] || [@"Z" isEqualToString:command]) {
        lastCoordinate = [SVGPointsAndPathsParser readCloseCommand:[NSScanner scannerWithString:command]
                                                              path:path
                                                        relativeTo:lastCoordinate];
      } else {
        NSString *cmdArgs = nil;
        BOOL foundParameters = [dataScanner scanUpToCharactersFromSet:knownCommands
                                                           intoString:&cmdArgs];
        
        if (foundParameters) {
          NSString *commandWithParameters = [command stringByAppendingString:cmdArgs];
          NSScanner *commandScanner = [NSScanner scannerWithString:commandWithParameters];
          
          if ([@"m" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readMovetoDrawtoCommandGroup:commandScanner
                                                                              path:path
                                                                        relativeTo:lastCoordinate
                                                                        isRelative:TRUE];
            lastCurve = SVGCurveZero;
          } else if ([@"M" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readMovetoDrawtoCommandGroup:commandScanner
                                                                              path:path
                                                                        relativeTo:CGPointZero
                                                                        isRelative:FALSE];
            lastCurve = SVGCurveZero;
          } else if ([@"l" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readLinetoCommand:commandScanner
                                                                   path:path
                                                             relativeTo:lastCoordinate
                                                             isRelative:TRUE];
            lastCurve = SVGCurveZero;
          } else if ([@"L" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readLinetoCommand:commandScanner
                                                                   path:path
                                                             relativeTo:CGPointZero
                                                             isRelative:FALSE];
            lastCurve = SVGCurveZero;
          } else if ([@"v" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readVerticalLinetoCommand:commandScanner
                                                                           path:path
                                                                     relativeTo:lastCoordinate];
            lastCurve = SVGCurveZero;
          } else if ([@"V" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readVerticalLinetoCommand:commandScanner
                                                                           path:path
                                                                     relativeTo:CGPointZero];
            lastCurve = SVGCurveZero;
          } else if ([@"h" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readHorizontalLinetoCommand:commandScanner
                                                                             path:path
                                                                       relativeTo:lastCoordinate];
            lastCurve = SVGCurveZero;
          } else if ([@"H" isEqualToString:command]) {
            lastCoordinate = [SVGPointsAndPathsParser readHorizontalLinetoCommand:commandScanner
                                                                             path:path
                                                                       relativeTo:CGPointZero];
            lastCurve = SVGCurveZero;
          } else if ([@"c" isEqualToString:command]) {
            lastCurve = [SVGPointsAndPathsParser readCurvetoCommand:commandScanner
                                                               path:path
                                                         relativeTo:lastCoordinate
                                                         isRelative:TRUE];
            lastCoordinate = lastCurve.p;
          } else if ([@"C" isEqualToString:command]) {
            lastCurve = [SVGPointsAndPathsParser readCurvetoCommand:commandScanner
                                                               path:path
                                                         relativeTo:CGPointZero
                                                         isRelative:FALSE];
            lastCoordinate = lastCurve.p;
          } else if ([@"s" isEqualToString:command]) {
            lastCurve = [SVGPointsAndPathsParser readSmoothCurvetoCommand:commandScanner
                                                                     path:path
                                                               relativeTo:lastCoordinate
                                                            withPrevCurve:lastCurve];
            lastCoordinate = lastCurve.p;
          } else if ([@"S" isEqualToString:command]) {
            lastCurve = [SVGPointsAndPathsParser readSmoothCurvetoCommand:commandScanner
                                                                     path:path
                                                               relativeTo:CGPointZero
                                                            withPrevCurve:lastCurve];
            lastCoordinate = lastCurve.p;
          } else {
            NSLog(@"unsupported command %@", command);
          }
        }
      }
    }
    
  } while (foundCmd);
  
	[self setPath:path];
	CGPathRelease(path);
}

- (NSString *)TAG
{
  return @"path";
}

- (BOOL)isInBound:(CGRect)bound
{
  CGRect rect = CGPathGetBoundingBox(_path);
  return CGRectIntersectsRect(bound, rect);
}

- (BOOL)isInBound:(CGRect)bound atScale:(CGFloat)scale
{
  CGRect rect = CGRectScale(CGPathGetBoundingBox(_path), scale);
  return CGRectIntersectsRect(bound, rect);
}

- (BOOL)isPointInShape:(CGPoint)point
{
  return CGPathContainsPoint(_path, nil, point, NO);
}

- (void)drawShape:(CGContextRef)context atScale:(CGFloat)scale
{
  CGAffineTransform tf = CGAffineTransformMakeScale(scale, scale);
  CGMutablePathRef drawPath = CGPathCreateMutableCopyByTransformingPath(_path, &tf);
  
  CGContextSaveGState(context);
  
  if (self.fill != nil) {
    CGContextSetFillColorWithColor(context, self.fill.CGColor);
    CGContextAddPath(context, drawPath);
    CGContextFillPath(context);
  }
  
  if (self.stroke != nil) {
    CGContextSetStrokeColorWithColor(context, self.stroke.CGColor);
    if (scale < 1) {
      CGContextSetLineWidth(context, self.stroke_width * scale);
    }
    else {
      CGContextSetLineWidth(context, self.stroke_width);
    }
    CGContextAddPath(context, drawPath);
    CGContextStrokePath(context);
  }
  
  CGContextRestoreGState(context);
  
  //测试图像绘制
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG_
  CGContextSaveGState(context);
  
  CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, CGPathGetBoundingBox(drawPath));
  CGContextStrokePath(context);
  
  CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextAddRect(context, CGPathGetPathBoundingBox(drawPath));
  CGContextStrokePath(context);
  
  CGContextRestoreGState(context);
#endif
  
  CGPathRelease(drawPath);
}

- (BOOL)drawShape:(CGContextRef)context inBound:(CGRect)bound atScale:(CGFloat)scale
{
  if ([self isInBound:bound atScale:scale]) {
    [self drawShape:context atScale:scale];
    return YES;
  }
  return NO;
}

//TODO:待实现(临时算法)
- (CGAngleRect)insideRect
{
  CGAngleRect arect = CGAngleRectMake(CGPathGetPathBoundingBox(_path), 0);
  return arect;
}

//TODO:待实现(临时算法)
- (CGAngleRect)outsideRect
{
  return [self insideRect];
}

@end