//
//  WFFlagPath.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-26.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFFlagPath.h"
#import "WFWiseFlag.h"
#import "WFWiseFlagBox.h"

@interface WFFlagPath ()
{
  WFWiseFlag * _flagA;
  WFWiseFlag * _flagB;
  
  NSString   * _flagNameA;
  NSString   * _flagNameB;
  /**
   * A to B 的方向.
   */
//  private EightDirection direction;
  
  /**
   * 距离。
   */
  float _distance;
  
  /**
   * 默认的通行规则。
   */
  kWFAccessable _defaultAccessable;
  
  /**
   * 通道类型，门，电梯等类型。
   */
  kWFAccessType _accesstype;
}

@end

@implementation WFFlagPath

@synthesize wiseflagA = _flagA, wiseflagB = _flagB, defaultAccessable = _defaultAccessable, distance = _distance;


/**
 * 如果需要知道B to A 的方向，使用
 * EightDirection.oppsiteDirection(theflagPath.getDirection()).
 * 
 * @return A to B 方向.
 */
//public EightDirection getDirection() {
//  return direction;
//}



/**
 * 通行规则。如果通行规则存在，则以通行规则定义的通行行为为准，否则以默认通行规则为准。
 */
//private List<AccessableRule> accessrules;




- (id)initWithMacForWiseFlagA:(NSString *)macForA andMacForWiseFlagB:(NSString *)macForB defaultAccessable:(NSString *)accessable distance:(NSString *)distance
{
  self = [super init];
  if (self) {
    WFWiseFlagBox *wiseflagBox = [WFWiseFlagBox sharedInstance];
    
    _flagA = [wiseflagBox wiseflagWithMac:macForA];
    if (_flagA) {
      [_flagA retain];
    }
    else {
      _flagA = [[WFWiseFlag alloc] initWithMac:macForA];
      [wiseflagBox addNullWiseFlag:_flagA];
    }
    
    _flagB = [wiseflagBox wiseflagWithMac:macForB];
    if (_flagB) {
      [_flagB retain];
    }
    else {
      _flagB = [[WFWiseFlag alloc] initWithMac:macForB];
      [wiseflagBox addNullWiseFlag:_flagB];
    }
    
    if ([accessable isEqualToString:@"LOCKED"]) {
      _defaultAccessable = kWFAccessableLocked;
    }
    else if ([accessable isEqualToString:@"AtoB"]) {
      _defaultAccessable = kWFAccessableAtoB;
    }
    else if ([accessable isEqualToString:@"BtoA"]) {
      _defaultAccessable = kWFAccessableBtoA;
    }
    else if ([accessable isEqualToString:@"BOTH"]) {
      _defaultAccessable = kWFAccessableBoth;
    }
    
    _distance = [distance floatValue];
    
    //TODO:在路牌对象中加入路径
  }
  return self;
}

- (id)initWithWiseFlagA:(WFWiseFlag *)flagA andWiseFlagB:(WFWiseFlag *)flagB defaultAccessable:(kWFAccessable)accessable distance:(float)distance
{
  self = [super init];
  if (self) {
    _flagA = [flagA retain];
    _flagB = [flagB retain];
    _defaultAccessable = accessable;
    _distance = distance;
    
    //TODO:在路牌对象中加入路径
  }
  return self;
}

- (void)dealloc
{
  [_flagA release], _flagA = nil;
  [_flagB release], _flagB = nil;
  [super dealloc];
}

/**
 * 取得路径上指定路牌的另一端对应路牌.
 * 
 * @param sgf
 * @return
 */
- (WFWiseFlag *)oppsiteFlag:(WFWiseFlag *)sgf
{
  if (_flagA == sgf) {
    return _flagB;
  }
  else if (_flagB == sgf) {
    return _flagA;
  }
  return nil;
}

- (WFWiseFlag *)getOppsiteFlag:(WFWiseFlag *)main
{
  if (main != nil) {
    if (_flagA == main) {
      return _flagB;
    }
    if (_flagB == main) {
      return _flagA;
    }
  }
  return nil;
}


/**
 * 给定路牌是否是当前路径的一端.
 * @param flag 
 * @return
 */
- (BOOL)hasFlag:(WFWiseFlag *)flag
{
  if (_flagA == flag || _flagB == flag) {
    return YES;
  }
  return NO;
}

- (NSString *)debugDescription
{
  switch (_defaultAccessable) {
    case kWFAccessableAtoB:
      return [NSString stringWithFormat:@"%@ --> %@", _flagA.debugDescription, _flagB.debugDescription];
      break;
      
    case kWFAccessableBtoA:
      return [NSString stringWithFormat:@"%@ <-- %@", _flagA.debugDescription, _flagB.debugDescription];
      break;
      
    case kWFAccessableBoth:
      return [NSString stringWithFormat:@"%@ <-> %@", _flagA.debugDescription, _flagB.debugDescription];
      break;
      
    case kWFAccessableLocked:
      return [NSString stringWithFormat:@"%@ -*- %@", _flagA.debugDescription, _flagB.debugDescription];
      break;

    default:
      return @"**************";
      break;
  }
}


@end
