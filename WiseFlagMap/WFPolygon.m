//
//  WFPolygon.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//


#import "WFPolygon.h"
#import "SVGPointsAndPathsParser.h"

@implementation WFPolygon
{
  CGPathRef _path;
}

@synthesize points = _points;

- (id)init
{
  self = [super init];
  if (self) {
    self.points = nil;
  }
  [self parseData:self.points];
  return self;
}

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity points:(NSString *)points
{
  self = [super initWithID:ID
                    stroke:stroke 
               strokeWidth:strokeWidth 
          strokeMiterlimit:strokeMiterLimit 
                      fill:fill 
                   opacity:opacity];
  if (self) {
    self.points = points;
  }
  [self parseData:self.points];
  return self;
}

- (void)setPoints:(NSString *)aPoints
{
  if (_points) {
    [_points release];
    _points = nil;
	}
	
	if (aPoints) {
		_points = [aPoints retain];
	}
  
  [self parseData:self.points];
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
  
	NSCharacterSet *knownCommands = [NSCharacterSet characterSetWithCharactersInString:@""];
	
	NSString *cmdArgs = nil;
	[dataScanner scanUpToCharactersFromSet:knownCommands intoString:&cmdArgs];
	
	NSString *commandWithParameters = [@"M" stringByAppendingString:cmdArgs];
	NSScanner *commandScanner = [NSScanner scannerWithString:commandWithParameters];
	
	lastCoordinate = [SVGPointsAndPathsParser readMovetoDrawtoCommandGroup:commandScanner
                                                                    path:path
                                                              relativeTo:CGPointZero
                                                              isRelative:FALSE];
	
	[SVGPointsAndPathsParser readCloseCommand:[NSScanner scannerWithString:@"z"]
                                       path:path
                                 relativeTo:lastCoordinate];
  
	[self setPath:path];
	CGPathRelease(path);
}

- (NSString *)TAG
{
  return @"polygon";
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
