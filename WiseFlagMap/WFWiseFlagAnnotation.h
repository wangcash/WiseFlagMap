//
//  WFWiseFlagAnnotation.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-7-6.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFAnnotation.h"

@interface WFWiseFlagAnnotation : WFAnnotation<WFAnnotation>

@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * longName;

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point shortName:(NSString *)shortName longName:(NSString *)longName;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape shortName:(NSString *)shortName longName:(NSString *)longName;

@end
