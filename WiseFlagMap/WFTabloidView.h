//
//  WFTabloidView.h
//  ZzPark
//
//  Created by 汪 威 on 12-9-3.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFWiseFlag.h"

@interface WFTabloidView : UIScrollView<UIScrollViewDelegate>
{
  
}

@property (nonatomic, retain, readwrite) WFWiseFlag* currentWiseFlag;

- (id)initWithWiseFlags:(NSArray*)wiseflags;

@end
