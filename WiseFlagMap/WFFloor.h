//
//  WFFloor.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-9-5.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFFloor : NSObject

@property (nonatomic, copy)   NSString* mapClipID;
@property (nonatomic, copy)   NSString* name;
@property (nonatomic, assign) NSInteger level;

- (id)initWithMapClipID:(NSString*)mapClipID name:(NSString*)name level:(NSInteger)level;

- (NSComparisonResult)compareMethodWithFloorLevel:(WFFloor*)anotherFloor;

@end
