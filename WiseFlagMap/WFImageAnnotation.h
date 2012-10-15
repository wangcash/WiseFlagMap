//
//  WFImageAnnotation.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-6-15.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFAnnotation.h"

@interface WFImageAnnotation : WFAnnotation<WFAnnotation>
{
  UIImage  * _image;
  NSString * _title;
}

@property (nonatomic, retain) UIImage  * image;
@property (nonatomic, retain) NSString * title;

- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point alignment:(kWFAlignment)alignment image:(UIImage *)image;
- (id)initWithID:(NSString *)ID atPoint:(CGPoint)point image:(UIImage *)image;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape alignment:(kWFAlignment)alignment image:(UIImage *)image;
- (id)initWithID:(NSString *)ID inAreaShape:(id)shape image:(UIImage *)image;

@end
