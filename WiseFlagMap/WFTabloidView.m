//
//  WFTabloidView.m
//  ZzPark
//
//  Created by 汪 威 on 12-9-3.
//  Copyright (c) 2012年 365path.com. All rights reserved.
//

#import "WFTabloidView.h"

#define WFTabloidItemWidth 64

@implementation WFTabloidView
{
  NSArray* _wiseflags;
}

@synthesize currentWiseFlag;

- (id)initWithWiseFlags:(NSArray*)wiseflags
{
  self = [super init];
  if (self) {
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavTabloidBg.png"]]];
    [self setPagingEnabled:YES];
    [self setUserInteractionEnabled:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    [self setDelegate:self];
    
    NSUInteger wiseflagNumber = 0;
    _wiseflags = [wiseflags retain];
    
    for (NSInteger i = 0; i < _wiseflags.count; i++) {
      WFWiseFlag* wiseflag = [_wiseflags objectAtIndex:i];
      if ([wiseflag real]) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(WFTabloidItemWidth * wiseflagNumber, 
                                                                   0, WFTabloidItemWidth, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:20];
        
        //文字投影
        label.shadowOffset = CGSizeMake(0.0f, -1.0f);
        label.shadowColor = [UIColor colorWithRed:58.0f/255.0f green:58.0f/255.0f blue:58.0f/255.0f alpha:1.0f];
        
        label.text = wiseflag.shortName;
        [self addSubview:label];
        [label release];
        wiseflagNumber++;
      }
    }
    
    [self setContentSize:CGSizeMake(WFTabloidItemWidth * wiseflagNumber, 40)];
    
  }
  return self;
}

- (void)dealloc
{
  [_wiseflags release], _wiseflags = nil;
  [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setCurrentWiseFlag:(WFWiseFlag*)theWiseFlag
{
  if (theWiseFlag == nil) {
    return;
  }
  NSInteger index = -1;
  for (NSUInteger i = 0, j = 0; i < _wiseflags.count; i++) {
    WFWiseFlag* wiseflag = [_wiseflags objectAtIndex:i];
    if ([wiseflag real]) {
      if ([theWiseFlag isEqual:wiseflag]) {
        index = j;
        break;
      }
      j++;
    }
  }
  if (index >= 0) {
    [self setContentOffset:CGPointMake(WFTabloidItemWidth * index, 0) animated:YES];
  }
}

@end
