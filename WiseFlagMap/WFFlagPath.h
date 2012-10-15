//
//  WFFlagPath.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-26.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  kWFAccessableLocked=0,
  kWFAccessableAtoB,
  kWFAccessableBtoA,
  kWFAccessableBoth
} kWFAccessable;

typedef enum {
  kWFAccessTypeGate=0,    //门
  kWFAccessTypeStairLift, //自动扶梯
  kWFAccessTypeLift,      //电梯
  kWFAccessTypeStair,     //楼梯
  kWFAccessTypeFireGate,  //防火门
  kWFAccessTypePath       //通道
} kWFAccessType;

@class WFWiseFlag;

@interface WFFlagPath : NSObject

@property (nonatomic, retain) WFWiseFlag * wiseflagA;
@property (nonatomic, retain) WFWiseFlag * wiseflagB;
@property (nonatomic, assign) kWFAccessable defaultAccessable;
@property (nonatomic, assign) float distance;

- (id)initWithMacForWiseFlagA:(NSString *)macForA andMacForWiseFlagB:(NSString *)macForB defaultAccessable:(NSString *)accessable distance:(NSString *)distance;

- (id)initWithWiseFlagA:(WFWiseFlag *)flagA andWiseFlagB:(WFWiseFlag *)flagB defaultAccessable:(kWFAccessable)accessable distance:(float)distance;

@end
