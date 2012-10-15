//
//  WFTiledMapView.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-30.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFTiledMapView.h"

#import <QuartzCore/QuartzCore.h>
#import "WFMapClip.h"
#import "WFShape.h"
#import "WFAnnotation.h"
#import "NSString+DrawPlus.h"
#import "UIImage+DrawPlus.h"

#import "WFDebug.h"

#define DEFAULT_SCALE 1.0 

@interface WFTiledMapView ()
{
  CGFloat _scale;
  
  UIColor * _fillColor;
}
@end

@implementation WFTiledMapView

@synthesize scale = _scale;
@synthesize mapClip;

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

#pragma mark init method
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame atScale:(CGFloat)scale
{
  self = [super initWithFrame:frame];
  if (self) {
    _scale = scale;
    
//    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
		// levelsOfDetail and levelsOfDetailBias determine how
		// the layer is rendered at different zoom levels. This
		// only matters while the view is zooming, since once the 
		// the view is done zooming a new TiledPDFView is created
		// at the correct size and scale.
//    tiledLayer.levelsOfDetail = 4;
//		tiledLayer.levelsOfDetailBias = 4;
//		tiledLayer.tileSize = CGSizeMake(640.0f, 640.0f);
  }
  return self;
}

-(void)dealloc
{
  [super dealloc];
}

// Set the layer's class to be CATiledLayer.
+ (Class)layerClass {
	return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect
{
#ifdef DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
//  NSLog(@"%s: %@",__FUNCTION__,NSStringFromCGRect(rect));
  
//  NSLog(@"rect  : %@", NSStringFromCGRect(rect));
//  NSLog(@"frame : %@", NSStringFromCGRect(self.frame));
//  NSLog(@"bounds: %@", NSStringFromCGRect(self.bounds));
#endif
    
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //画背景色--------------------------------------------------------------------
  CGContextSaveGState(context);
  CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
  CGContextFillRect(context, rect);
#ifdef DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
  //画参照线
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
  CGContextSetLineWidth(context, 0.5f);
  CGContextAddRect(context, rect);
  CGContextStrokePath(context);
#endif
  CGContextRestoreGState(context);
  
  //画图形----------------------------------------------------------------------
  CGContextSaveGState(context);
  for (kWFMapLayerType l = kWFMapLayerBaseMapShape; l <= kWFMapLayerUserShape; l++) {
    NSArray *shapes = [mapClip inLayerShapes:l inBound:rect atScale:_scale];
    if (shapes == nil) {
      continue;
    }
    for (NSInteger i=0; i<[shapes count]; i++) {
      WFShape<WFShape> *shape = [shapes objectAtIndex:i];
      [shape drawShape:context inBound:rect atScale:_scale];
    }
  }
  CGContextRestoreGState(context);

  //画标注----------------------------------------------------------------------
  WFHitTester *hitTester = [[mapClip hitTester] retain];  //拿到一个碰撞检测器
  
  CGContextSaveGState(context);
  for (kWFMapLayerType l = kWFMapLayerMAX; l >= kWFMapLayerBaseMapAnnotation; l--) {
    NSArray *annotations = [mapClip inLayerAnnotations:l inBound:rect atScale:_scale];
    if (annotations == nil) {
      continue;
    }
    for (NSInteger i=0; i<[annotations count]; i++) {
      WFAnnotation<WFAnnotation> *annotation = [annotations objectAtIndex:i];
      [annotation drawAnnotation:context inBound:rect atScale:_scale hitTester:hitTester];
    }
  }
  CGContextRestoreGState(context);
  
  [hitTester release];
  
}
 

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
//{
//  NSLog(@"%s",__FUNCTION__);
//}



@end
