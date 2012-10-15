//
//  WFMapView+Bubble.m
//  ZzPark
//
//  Created by 汪 威 on 12-8-15.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import "WFMapView+Bubble.h"

@implementation WFMapView (Bubble)

/********************************************************************************/
#pragma mark - 气泡显示
/********************************************************************************/
- (SNPopupView *)bubble
{
  return (SNPopupView *)_bubble;
}

- (void)redrawBubble
{
  if (_bubble != nil) {
    CGPoint p = [self offsetBubblePoint:_bubblePoint];
    NSLog(@"%@", NSStringFromCGPoint(p));
    [_bubble showAtPoint:p inView:self];
  }
}

- (CGPoint)offsetBubblePoint:(CGPoint)aPoint
{
  //计算当前缩放比例
  CGFloat scaleOfHeight = [self scaleOfHeight];
  CGFloat scaleOfWidth = [self scaleOfWidth];
  CGFloat scale = MIN(scaleOfHeight, scaleOfWidth);
  
  //按比例计算新坐标
  CGPoint newPoint = CGPointScale(aPoint, scale);
  
  //修正小比例地图居中显示后的XY轴偏移
  if ([self centerMigration].y > 0) {
    newPoint.y += [self centerMigration].y;
  }
  if ([self centerMigration].x > 0) {
    newPoint.x += [self centerMigration].x;
  }
  
  return newPoint;
}

- (void)destroyBubble
{
  [_bubble dismiss:YES];
  [_bubble release];
  _bubble = nil;
  _bubblePoint = CGPointZero;
}

- (void)popupBubbleAtPoint:(CGPoint)aPoint contentString:(NSString *)aString withFontOfSize:(float)aSize
{
  //存在旧气泡的时候进行销毁
  if (_bubble) {
    [self destroyBubble];
  }
  
  //保存气泡坐标点
  _bubblePoint = aPoint;
  
  //换算气泡坐标点
  CGPoint newPoint = [self offsetBubblePoint:_bubblePoint];
  
  //创建气泡
  _bubble = [[SNPopupView alloc] initWithString:aString withFontOfSize:aSize];
  
  //显示气泡
  [_bubble showAtPoint:newPoint inView:self animated:YES];
}

- (void)popupBubbleAtPoint:(CGPoint)aPoint contentString:(NSString *)aString
{
  //存在旧气泡的时候进行销毁
  if (_bubble) {
    [self destroyBubble];
  }
  
  //保存气泡坐标点
  _bubblePoint = aPoint;
  
  //换算气泡坐标点
  CGPoint newPoint = [self offsetBubblePoint:_bubblePoint];
  
  //创建气泡
  _bubble = [[SNPopupView alloc] initWithString:aString];
  
  //显示气泡
  [_bubble showAtPoint:newPoint inView:self animated:YES];
}

- (void)popupBubbleAtPoint:(CGPoint)aPoint contentImage:(UIImage *)aImage
{
  //存在旧气泡的时候进行销毁
  if (_bubble) {
    [self destroyBubble];
  }
  
  //保存气泡坐标点
  _bubblePoint = aPoint;
  
  //换算气泡坐标点
  CGPoint newPoint = [self offsetBubblePoint:_bubblePoint];
  
  //创建气泡
  _bubble = [[SNPopupView alloc] initWithImage:aImage];
  
  //显示气泡
  [_bubble showAtPoint:newPoint inView:self animated:YES];
}

- (void)popupBubbleAtPoint:(CGPoint)aPoint contentView:(UIView *)aView contentSize:(CGSize)contentSize
{
  //存在旧气泡的时候进行销毁
  if (_bubble) {
    [self destroyBubble];
  }
  
  //保存气泡坐标点
  _bubblePoint = aPoint;
  
  //换算气泡坐标点
  CGPoint newPoint = [self offsetBubblePoint:_bubblePoint];
  
  //创建气泡
  _bubble = [[SNPopupView alloc] initWithContentView:aView contentSize:contentSize];
  
  //显示气泡
  [_bubble showAtPoint:newPoint inView:self animated:YES];
}

@end
