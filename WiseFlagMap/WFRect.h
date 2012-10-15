//
//  WFRect.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"

@interface WFRect : WFShape<WFShape>
{
  CGFloat _x;
  CGFloat _y;
  CGFloat _width;
  CGFloat _height;
}

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, readonly) CGRect CGRect;

- (id)init;

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity x:(NSString *)x y:(NSString *)y width:(NSString *)width height:(NSString *)height;

- (CGRect)CGRect;

@end
