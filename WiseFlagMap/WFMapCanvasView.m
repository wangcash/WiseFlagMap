//
//  WFMapCanvasView.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-23.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFMapCanvasView.h"

@interface WFMapCanvasView ()
{
  WFBaseMapDocument * _mapClip;
  UIColor * _fillColor;
}



@end


@implementation WFMapCanvasView

@synthesize scale = _scale;

#define DEFAULT_SCALE 1.0 

- (CGFloat)scale  
{  
  if (!_scale) {
    return DEFAULT_SCALE;
  } 
  else {
    return _scale;
  } 
}  

- (void)setScale:(CGFloat)scale  
{  
  if (_scale != scale)  
  {
    _scale = scale;  
    [self setNeedsDisplay];  
  }  
}  

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}
- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale{
  if ((self = [super initWithFrame:frame])) {
		
		CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
		// levelsOfDetail and levelsOfDetailBias determine how
		// the layer is rendered at different zoom levels.  This
		// only matters while the view is zooming, since once the 
		// the view is done zooming a new TiledPDFView is created
		// at the correct size and scale.
    tiledLayer.levelsOfDetail = 4;
		tiledLayer.levelsOfDetailBias = 4;
		tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
		
		_scale = scale;
  }
  return self;
}

- (id)initWithMapClip:(WFBaseMapDocument *)mapClip
{
  self = [super initWithFrame:mapClip.viewBox];
  if (self) {
    _mapClip = mapClip.retain;
  }
  return self;
}

- (CGRect)currentFrame:(CGRect)frame
{
  CGRect currentFrame = CGRectMake(frame.origin.x*_scale, frame.origin.x*_scale, frame.size.width*_scale, frame.size.height*_scale);
  return currentFrame;
}


- (id)initWithMapClip:(WFBaseMapDocument *)mapClip atScale:(CGFloat)scale
{
  _scale = scale;
  self = [super initWithFrame:[self currentFrame:mapClip.viewBox]];
  if (self) {
    _mapClip = mapClip.retain;
  }
  return self;
}


- (void)dealloc
{
  [_mapClip release], _mapClip = nil;
  [super dealloc];
}

- (void)layoutSubviews 
{
//  NSLog(@"[%s]", __FUNCTION__);
}

- (void)drawRect:(CGRect)rect
{
  
  if (_fillColor != [UIColor whiteColor]) {
    _fillColor = [UIColor whiteColor];
  }
  else if (_fillColor != [UIColor grayColor]){
    _fillColor = [UIColor grayColor];
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
    
  //画背景
  CGContextSaveGState(context);
  CGContextSetFillColorWithColor(context, _fillColor.CGColor);
  CGContextFillRect(context, self.frame);
  CGContextRestoreGState(context);
  NSLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
  
  
  
  NSArray *shapes = [_mapClip getShapes];
  NSLog(@"shapes count = %d", [shapes count]);
  
  for (NSInteger i=0; i<[shapes count]; i++) {
    WFShape<WFShape> *shape = [shapes objectAtIndex:i];
    if ([shape isKindOfClass:[WFSvgRect class]]) {
      WFSvgRect *rect = (WFSvgRect *)shape;
      [rect drawShape:context atScale:_scale];
      NSLog(@"rect:%@ center:%@", NSStringFromCGRect(rect.CGRect), NSStringFromCGPoint(rect.centerPoint));
    }
  }
  
  
  
//  CGContextSelectFont(context, "Helvetica", 20, kCGEncodingMacRoman);
//  CGContextSetCharacterSpacing(context, 10);

//  CGContextSetRGBStrokeColor(context, 0, 0, 1, 1); 
//  CGContextSetTextMatrix(context, CGAffineTransformMakeRotation(45));

//  UIFont *tfont = [UIFont fontWithName:@"Helvetica" size:9.0];
  
  for (NSInteger i=0; i<[shapes count]; i++) {
    WFShape<WFShape> *shape = [shapes objectAtIndex:i];
    if ([shape isKindOfClass:[WFSvgRect class]]) {

      WFSvgRect *rect = (WFSvgRect *)shape;
      
      CGContextSaveGState(context);
      CGContextSetTextDrawingMode(context, kCGTextFillClip);
      CGContextSetRGBFillColor(context, 0, 0, 0, 1);
      [rect.ID drawAtPoint:CGPointMake(rect.x,rect.y) withFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
      CGContextRestoreGState(context);

    }
  }

 
  
  
  
  
}


 
@end
