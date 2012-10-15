//
//  WFBaseMap.m
//  基图控制类，俗称搞基类
//
//  Created by 汪 威 on 12-5-31.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFBaseMap.h"
#import "SVGKit.h"
#import "TBXML.h"
#import "JSONKit.h"

#import "WFMapClip.h"
#import "WFShape.h"
#import "WFCircle.h"
#import "WFEclipse.h"
#import "WFRect.h"
#import "WFPolygon.h"
#import "WFPath.h"
#import "WFLine.h"
#import "WFAnnotation.h"
#import "WFTextAnnotation.h"
#import "WFImageAnnotation.h"
#import "WFRichAnnotation.h"
#import "WFRoom.h"
#import "WFRoomManager.h"

@interface WFBaseMap ()
{
  CGFloat _x, _y, _width, _height;
  CGRect  _viewBox;
  NSString* _id;
  NSArray*  _shapes;       //BaseMap中的所有图形。
  NSArray*  _annotations;  //BaseMap中的所有标注。
  
  CGRect _limits;           //Map占据的矩形区域。
}
@end

@implementation WFBaseMap
@synthesize x = _x, y = _y, width = _width, height = _height;
@synthesize viewBox = _viewBox;
@synthesize MapClipID = _id;

- (id)initWithMapClip:(WFMapClip*)mapClip
{
  self = [super init];
  if (self) {
    NSString* mapClipID = mapClip.ID;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:mapClipID ofType:@"svg"];
    NSString* filePath = [[WFMapClipDirectory() stringByAppendingPathComponent:mapClipID] stringByAppendingPathExtension:@"svg"];
    NSData* svgData = [NSData dataWithContentsOfFile:filePath];
    
    if (svgData == nil) {
      return self;
    }
    
    NSMutableArray* shapeArray = [[NSMutableArray alloc] init];
    NSMutableArray* annotationArray = [[NSMutableArray alloc] init];
    
    TBXML* svgXml = [TBXML newTBXMLWithXMLData:svgData error:nil];
    
    //拿到svg节点
    TBXMLElement* svgElement = svgXml.rootXMLElement;
    
    _id     = [[TBXML valueOfAttributeNamed:@"id"     forElement:svgElement] retain];
    _x      = [[TBXML valueOfAttributeNamed:@"x"      forElement:svgElement] floatValue];
    _y      = [[TBXML valueOfAttributeNamed:@"y"      forElement:svgElement] floatValue];
    _width  = [[TBXML valueOfAttributeNamed:@"width"  forElement:svgElement] floatValue];
    _height = [[TBXML valueOfAttributeNamed:@"height" forElement:svgElement] floatValue];
    
    NSScanner* scanner = [NSScanner localizedScannerWithString:[TBXML valueOfAttributeNamed:@"viewBox" forElement:svgElement]];
    
    [scanner scanFloat:&_viewBox.origin.x];
    [scanner scanFloat:&_viewBox.origin.y];
    [scanner scanFloat:&_viewBox.size.width];
    [scanner scanFloat:&_viewBox.size.height];
    
#if DISPLAY_DEBUGGING_INFORMATION_FOR_WISEFLAG
    NSLog(@"viewBox(%f %f %f %f)", _viewBox.origin.x, _viewBox.origin.y, _viewBox.size.width, _viewBox.size.height);
#endif
    
    //拿到第一个图形节点
    TBXMLElement* shapeElement = svgElement->firstChild;
    
    do {
      //创建图形对象
      WFShape<WFShape>* shape = [WFShape shapeWithXmlElement:(id)shapeElement];
      if (shape == nil) {
        continue;
      }
      [shapeArray addObject:shape];
      
      
      //创建room
      NSString* shapeID = [TBXML valueOfAttributeNamed:@"id" forElement:shapeElement];
      
      WFRoom* room = [WFRoom roomWithShape:shape shapeIdString:shapeID];
      if (room) {
        WFRoomManager* roomManager = [WFRoomManager sharedInstance];
        [roomManager addRoom:room mapClipID:mapClipID];
        
        //创建标注对象
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", room.roomType]];
        if (image != nil) {
          WFImageAnnotation *annotation = [[WFImageAnnotation alloc] initWithID:room.roomId
                                                                    inAreaShape:room.roomShape
                                                                          image:image];
          annotation.title = room.roomName;
          [annotationArray addObject:annotation];
          [annotation release];
        }
        else {
          WFTextAnnotation* annotation = [[WFTextAnnotation alloc] initWithID:room.roomId
                                                                  inAreaShape:room.roomShape
                                                                        title:room.roomName];
          annotation.titleColor = [UIColor grayColor];
          [annotationArray addObject:annotation];
          [annotation release];
        }
      }

      
//      //创建标注对象
//      
//      //ID格式：{|k|:|DaYueChen_Fl_Jack|,|n|:|A1|,|t|:|SHOP|,|nwl|:[{|w|:|23:33:34:21:11|},{|w|:|24:33:34:21:11|}]}
//      
//      //编码转换
//      //_x7B_ = {
//      //_x7C_ = |
//      //_x5F_ = _
//      //_x2C_ = ,
//      //_x7D_ = }
//      //_x27_ = ’
//      shapeID = [shapeID stringByReplacingOccurrencesOfString:@"_x7B_" withString:@"{"];
//      shapeID = [shapeID stringByReplacingOccurrencesOfString:@"_x7C_" withString:@"|"];
//      shapeID = [shapeID stringByReplacingOccurrencesOfString:@"_x5F_" withString:@"_"];
//      shapeID = [shapeID stringByReplacingOccurrencesOfString:@"_x2C_" withString:@","];
//      shapeID = [shapeID stringByReplacingOccurrencesOfString:@"_x7D_" withString:@"}"];
//      shapeID = [shapeID stringByReplacingOccurrencesOfString:@"_x27_" withString:@"‘"];
//      
//      NSString *json = [shapeID stringByReplacingOccurrencesOfString:@"|" withString:@"\""]; //转义“|”
//      NSDictionary *idDict = [json objectFromJSONString];
//      //判断ID是否是JSON格式
//      if (idDict.count > 0) {
//        NSString *key  = [idDict objectForKey:@"k"];
//        NSString *name = [idDict objectForKey:@"n"];
//        NSString *type = [idDict objectForKey:@"t"];
//        //TODO:nwl暂时没解析处理
//        
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", type]];
//        if (image != nil) {
//          WFImageAnnotation *annotation = [[WFImageAnnotation alloc] initWithID:key inAreaShape:shape image:image];
//          annotation.title = name;
//          [annotationArray addObject:annotation];
//          [annotation release];
//        }
//        else {
//          WFTextAnnotation *annotation = [[WFTextAnnotation alloc] initWithID:key inAreaShape:shape title:name];
//          annotation.titleColor = [UIColor grayColor];
//          [annotationArray addObject:annotation];
//          [annotation release];
//        }
//      }
      


      
    } while ((shapeElement = shapeElement->nextSibling)); // 获取同级元素
    
    _shapes = [shapeArray retain];
    [shapeArray release];
    
    _annotations = [annotationArray retain];
    [annotationArray release];
    
    [svgXml release], svgXml = nil;
    
  }
  return self;
}

- (void)dealloc
{
  [_id release], _id = nil;
  [_shapes release], _shapes = nil;
  [_annotations release], _annotations = nil;
  [super dealloc];
}

- (NSArray *)allShapes
{
  return _shapes;
}

//- (NSArray *)inBoundShapes:(CGRect)bound
//{
//  NSMutableArray *shapesInBound = [[[NSMutableArray alloc] init] autorelease];
//  for (NSInteger i=0; i<[_shapes count]; i++) {
//    WFShape<WFShape> *shape = [_shapes objectAtIndex:i];
//    if ([shape isInBound:bound]) {
//      [shapesInBound addObject:shape];
//    }
//  }
//  return shapesInBound;
//}

- (NSArray *)inBoundShapes:(CGRect)bound atScale:(CGFloat)scale
{
  NSMutableArray *shapesInBound = [[[NSMutableArray alloc] init] autorelease];
  for (NSInteger i=0; i<[_shapes count]; i++) {
    WFShape<WFShape> *shape = [_shapes objectAtIndex:i];
    if ([shape isInBound:bound atScale:scale]) {
      [shapesInBound addObject:shape];
    }
  }
  return shapesInBound;
}

- (NSArray *)allAnnotations
{
  return _annotations;
}

//- (NSArray *)inBoundAnnotations:(CGRect)bound
//{
//  NSMutableArray *annotationsInBound = [[[NSMutableArray alloc] init] autorelease];
//  for (NSInteger i=0; i<[_annotations count]; i++) {
//    WFAnnotation<WFAnnotation> *annotation = [_annotations objectAtIndex:i];
//    if ([annotation isInBound:bound]) {
//      [annotationsInBound addObject:annotation];
//    }
//  }
//  return annotationsInBound;
//}

- (NSArray *)inBoundAnnotations:(CGRect)bound atScale:(CGFloat)scale
{
  NSMutableArray *annotationsInBound = [[[NSMutableArray alloc] init] autorelease];
  for (NSInteger i=0; i<[_annotations count]; i++) {
    WFAnnotation<WFAnnotation> *annotation = [_annotations objectAtIndex:i];
    if ([annotation isInBound:bound atScale:scale]) {
      [annotationsInBound addObject:annotation];
    }
  }
  return annotationsInBound;
}

@end
