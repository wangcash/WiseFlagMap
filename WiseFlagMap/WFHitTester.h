//
//  WFHitTester.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-3.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFHitTester : NSObject

/**
 * 将对象边框矩形添加入碰撞矩阵
 * @param rect
 * @param key
 */
- (void)addHitTestRect:(CGRect)rect textKey:(id)key;

/**
 * 执行碰撞检测，检查rect是否和检测器中已有矩形发生碰撞。发生碰撞返回YES，没发生碰撞返回NO。
 * 当发生碰撞时检查key值是否相等，以排除同一文本自身碰撞检测。
 * @param rect 文本矩形
 * @param key 文本的标识，一般时候直接传入文本的NSString对象。
 * @return YES=发生碰撞 NO=没发生碰撞
 */
- (BOOL)hitTest:(CGRect)rect textKey:(id)key;

/**
 * 重置碰撞检测器
 */
- (void)reset;
@end
