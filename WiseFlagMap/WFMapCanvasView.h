//
//  WFMapCanvasView.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-23.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFBaseMapDocument.h"

@interface WFMapCanvasView : UIView
{
  CGFloat _scale;
}

@property (nonatomic) CGFloat scale;


- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale;
//- (void)setPage:(CGPDFPageRef)newPage;
//
//- (id)initWithMapClip:(WFBaseMapDocument *)mapClip;
//- (id)initWithMapClip:(WFBaseMapDocument *)mapClip atScale:(CGFloat)scale;

@end
