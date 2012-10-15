//
//  WFCircle.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFShape.h"

@interface WFCircle : WFShape<WFShape>
{
  CGFloat _cx;
  CGFloat _cy;
  CGFloat _r;
}

@property (nonatomic) CGFloat cx;
@property (nonatomic) CGFloat cy;
@property (nonatomic) CGFloat r;

- (id)init;

- (id)initWithID:(NSString *)ID stroke:(NSString *)stroke strokeWidth:(NSString *)strokeWidth strokeMiterlimit:(NSString *)strokeMiterLimit fill:(NSString *)fill opacity:(NSString *)opacity cx:(NSString *)cx cy:(NSString *)cy r:(NSString *)r;

@end
