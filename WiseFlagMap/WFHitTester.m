//
//  WFHitTester.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-3.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFHitTester.h"

@implementation WFHitTester
{
  NSMutableArray *hitTestMatrix;  //碰撞检测矩阵
  NSMutableSet   *hitTestKeySet;  //对象清单，用于排除跨单元格文本与自身进行碰撞检测。
}

- (id)init
{
  self = [super init];
  if (self) {
    hitTestMatrix = [[NSMutableArray alloc] init];
    hitTestKeySet = [[NSMutableSet alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [hitTestMatrix release], hitTestMatrix = nil;
  [hitTestKeySet release], hitTestKeySet = nil;
  [super dealloc];
}

- (void)addHitTestRect:(CGRect)rect textKey:(id)key
{
//  NSLog(@"%@", NSStringFromCGRect(rect));
  [hitTestMatrix addObject:[NSValue valueWithCGRect:rect]];
  if (key != nil) {
    [hitTestKeySet addObject:[key retain]];
  }
}

- (BOOL)hitTest:(CGRect)rect textKey:(id)key
{
  //遍历矩阵进行碰撞检测
  for (NSUInteger i=0; i<hitTestMatrix.count; i++) {
    NSValue *rectValue = [hitTestMatrix objectAtIndex:i];
//    NSLog(@"i=%d", i);
    if (rectValue == nil) {
      NSLog(@"rectValue = nil");
    }
//    NSLog(@"rectValue=%@", rectValue);
//    NSLog(@"rect:%@", NSStringFromCGRect([rectValue CGRectValue]));
//  for (NSValue *rectValue in hitTestMatrix) {
    //执行碰撞检测
    if (CGRectIntersectsRect(rect, [rectValue CGRectValue])) {
      //排除文本与自身的碰撞检测
      if ([hitTestKeySet containsObject:key]) {
        return NO;
      }
      return YES;
    }
  }
  return NO;
}

- (void)reset
{  
  [hitTestMatrix release];
  [hitTestKeySet release];
  
  hitTestMatrix = [[NSMutableArray alloc] init];
  hitTestKeySet = [[NSMutableSet alloc] init];
}
@end
