//
//  WFMapClip.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-31.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFMapClip.h"
#import "WFBaseMap.h"
#import "WFWiseFlagMap.h"
#import "WFUserMap.h"
#import "WFHitTester.h"
#import "WFWiseFlagBox.h"
#import "WFServiceManager.h"

#import "WFDebug.h"

NSString* WFMapClipDirectory(void)
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths lastObject];
  NSString* retMapClipsDir = [documentsDirectory stringByAppendingPathComponent:@"MapClips"];
  
  NSFileManager* fileManager = [NSFileManager defaultManager];
  BOOL isDir = NO;
  BOOL isDirExist = [fileManager fileExistsAtPath:retMapClipsDir isDirectory:&isDir];
  
  if (!(isDirExist && isDir)) {
    BOOL dirCreated = [fileManager createDirectoryAtPath:retMapClipsDir withIntermediateDirectories:YES attributes:nil error:nil];
    if(!dirCreated){
      NSLog(@"Create Directory [%@] Failed.", retMapClipsDir);
    }
    NSLog(@"Create Directory [%@] Success.", retMapClipsDir);
  }
  
  return retMapClipsDir;
}

@implementation WFMapClip
{
  NSString*  _mapClipID;   //地图切片ID
  NSString*  _fingerPrint; //指纹
  NSUInteger _width;       //转换地图对应的宽度
  NSUInteger _height;      //转换地图对应的高度
  NSUInteger _zoomLevel;   //缩放级别
  
  WFBaseMap*      _baseMap;      //基图图层
  WFWiseFlagMap*  _wiseflagMap;  //路牌图层
  WFUserMap*      _userMap;      //用户图层
  WFHitTester*    _hitTester;    //碰撞检测器
}

@synthesize CGRect;
@synthesize hitTester = _hitTester;
@synthesize ID = _mapClipID;

+ (id)MapClipWithMapClipID:(NSString*)ID
{
  return [[[WFMapClip alloc] initWithMapClipID:ID] autorelease];
}

- (id)initWithMapClipID:(NSString*)ID
{
  self = [super init];
  if (self) {
    _mapClipID = [ID copy];
    
    //检查MapClip数据是否存在，不存在着以同步方式下载后继续运行。
    if ([[WFServiceManager fingerPrintForMapClipID:_mapClipID] isEqualToString:@""]) {
      //终端中没有当前MapClip中的数据
      WFServiceManager *manager = [WFServiceManager sharedInstance];
      [manager updatingMapClipWithID:_mapClipID];
    }
    
    //创建BaseMap对象
    _baseMap = [[WFBaseMap alloc] initWithMapClip:self];
    
    //使用全局的WiseFlagBox，从WiseFlagBox中获取一个MapClip对应的WiseFlagMap
    _wiseflagMap = [[[WFWiseFlagBox sharedInstance] wiseflagMap:self] retain];
    
    //读入UserMap对象实例
    _userMap = [[WFUserMap sharedInstance] retain];
    
    //创建碰撞检测器
    _hitTester = [[WFHitTester alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [_baseMap release],     _baseMap = nil;
  [_wiseflagMap release], _wiseflagMap = nil;
  [_mapClipID release],   _mapClipID = nil;
  [_hitTester release],   _hitTester = nil;
  [_category release],    _category = nil;
  [super dealloc];
}

- (NSArray *)inLayerAllShapes:(kWFMapLayerType)layerType
{
  switch (layerType) {
    case kWFMapLayerBaseMapShape:
      return [_baseMap allShapes];
      break;
    case kWFMapLayerWiseFlagShape:
      return [_wiseflagMap allShapes];
      break;
    case kWFMapLayerBusinessShape:
      return nil;
      break;
    case kWFMapLayerUserShape:
      [_userMap generateShapesForMapClip:self];
      [_userMap generateAnnotationsForMapClip:self];
      return [_userMap allShapes];
      break;
    default:
      return nil;
      break;
  }
}

- (NSArray *)inLayerShapes:(kWFMapLayerType)layerType inBound:(CGRect)bound atScale:(CGFloat)scale
{
  switch (layerType) {
    case kWFMapLayerBaseMapShape:
      return [_baseMap inBoundShapes:bound atScale:scale];
      break;
    case kWFMapLayerWiseFlagShape:
      return [_wiseflagMap inBoundShapes:bound atScale:scale];
      break;
    case kWFMapLayerBusinessShape:
      return nil;
      break;
    case kWFMapLayerUserShape:
      [_userMap generateShapesForMapClip:self];
      [_userMap generateAnnotationsForMapClip:self];
      return [_userMap inBoundShapes:bound atScale:scale];
      break;
    default:
      return nil;
      break;
  }
}

- (CGRect)CGRect
{
  return _baseMap.viewBox;
}

- (NSArray *)inLayerAllAnnotations:(kWFMapLayerType)layerType
{
  switch (layerType) {
    case kWFMapLayerBaseMapAnnotation:
      return [_baseMap allAnnotations];
      break;
    case kWFMapLayerWiseFlagAnnotation:
      return [_wiseflagMap allAnnotations];
      break;
    case kWFMapLayerBusinessAnnotation:
      return nil;
      break;
    case kWFMapLayerUserAnnotation:
      [_userMap generateShapesForMapClip:self];
      [_userMap generateAnnotationsForMapClip:self];
      return [_userMap allAnnotations];
      break;
    default:
      return nil;
      break;
  }
}

- (NSArray *)inLayerAnnotations:(kWFMapLayerType)layerType inBound:(CGRect)bound atScale:(CGFloat)scale
{
  switch (layerType) {
    case kWFMapLayerBaseMapAnnotation:
      return [_baseMap inBoundAnnotations:bound atScale:scale];
      break;
    case kWFMapLayerWiseFlagAnnotation:
      return [_wiseflagMap inBoundAnnotations:bound atScale:scale];
      break;
    case kWFMapLayerBusinessAnnotation:
      return nil;
      break;
    case kWFMapLayerUserAnnotation:
      [_userMap generateShapesForMapClip:self];
      [_userMap generateAnnotationsForMapClip:self];
      return [_userMap inBoundAnnotations:bound atScale:scale];
      break;
    default:
      return nil;
      break;
  }
}




//暂时先比较MapClipID，在实现了从内存中取MapClip后，修改为比较MapClip对象。
-(BOOL)isEqual:(id)object
{
  WFMapClip* other = (WFMapClip*)object;
  
  if ([self.ID isEqualToString:other.ID]) {
    return YES;
  }
  else {
    return NO;
  }
}


@end
