//
//  WFViewController.h
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFMapKit.h"

@interface WFViewController : UIViewController<WFMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
  WFMapView * _mapView;
  
  IBOutlet UIView *startView;
  IBOutlet UIView *endView;
}

@property (nonatomic, retain) IBOutlet WFMapView * mapView;

- (IBAction)startSelected:(id)sender;
- (IBAction)endSelected:(id)sender;

@end
