//
//  WFMapView+Bubble.h
//  ZzPark
//
//  Created by 汪 威 on 12-8-15.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import "WFMapView.h"
#import "SNPopupView.h"

@interface WFMapView (Bubble)

/**
 * 创建气泡
 */
- (void)redrawBubble;
- (void)destroyBubble;
- (void)popupBubbleAtPoint:(CGPoint)aPoint contentString:(NSString *)aString withFontOfSize:(float)aSize;
- (void)popupBubbleAtPoint:(CGPoint)aPoint contentString:(NSString *)aString;
- (void)popupBubbleAtPoint:(CGPoint)aPoint contentImage:(UIImage*)aImage;
- (void)popupBubbleAtPoint:(CGPoint)aPoint contentView:(UIView*)aView contentSize:(CGSize)contentSize;


@end
