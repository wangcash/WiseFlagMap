//
//  WFViewController.m
//  WiseFlagMap
//
//  Created by 汪 威 on 12-5-11.
//  Copyright (c) 2012年 wiseflag.com. All rights reserved.
//

#import "WFViewController.h"

@implementation WFViewController
{
  NSArray * floorArray;
  
  WFCityPoint * _tapCityPoint;
  
  WFCityPoint * _startCityPoint;
  WFCityPoint * _endCityPoint;
}

@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    floorArray = [[NSArray alloc] initWithObjects: @"F11", @"F10", @"F9", @"F8", @"F7", @"F6", @"F5", @"F4", @"F3", @"F2", @"F1",@"B1", nil];
  }
  return self;
}

- (void)dealloc
{
  [floorArray release];
  [_mapView release], _mapView = nil;
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //地图View
  _mapView = [[WFMapView alloc] initWithFrame:self.mapView.frame];
  _mapView.mapViewDelegate = self;
  [self.view addSubview:_mapView];
  
  //楼层切换Table
  UITableView *floorTable = [[UITableView alloc] initWithFrame:CGRectMake(270, 70, 40, 200)];
  floorTable.delegate = self;
  floorTable.dataSource = self;
  floorTable.showsVerticalScrollIndicator = NO;
  [[floorTable layer] setBorderWidth:1.0f];
  floorTable.rowHeight = 40.0f;
  floorTable.alpha = 0.4f;
  [self.view addSubview:floorTable];
  
  [self.mapView testLocation:@"13439821615380"];
  
//  //测试按钮
//  UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//  [b setFrame:CGRectMake(100, 100, 70, 30)];
//  [b setTitle:@"Button" forState:UIControlStateNormal];
//  [b addTarget:_mapView action:@selector(hideOutdoorMap) forControlEvents:UIControlEventTouchUpInside];
//  [self.view addSubview:b];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

//- (void)singleTapPoint:(CGPoint)point currentScale:(CGFloat)scale tapObject:(id)object
//{
//  NSLog(@"[%s]",__FUNCTION__);
//  NSLog(@"%f,%f(%f)", point.x,point.y,scale);
//  WFShape *shape = object;
//  NSLog(@"shape_id = %@", shape.ID);
//  
//  shape.fill = [UIColor cyanColor];
//  [self.mapView setNeedsDisplay];
//}



- (void)singleTapPoint:(CGPoint)point currentScale:(CGFloat)scale tapObjectArray:(NSArray *)array
{
  NSLog(@"==== ====[%s]==== ====",__FUNCTION__);

  NSLog(@"point: %@", NSStringFromCGPoint(point));
  
  //拾取
  for (NSInteger i=0; i<array.count; i++) {
    id object = [array objectAtIndex:i];
    if ([object isKindOfClass:[WFWiseFlagAnnotation class]]) {
      WFWiseFlagAnnotation *annotation = object;
      [self.mapView popupBubbleAtPoint:annotation.point contentString:annotation.shortName];
      return;
    }
    if ([object isKindOfClass:[WFImageAnnotation class]]) {
      WFImageAnnotation *annotation = object;
      [self.mapView popupBubbleAtPoint:annotation.point contentString:annotation.title];
      return;
    }
  }
  
  _tapCityPoint = [[self.mapView cityPointWithCGPoint:point] retain];

  if (_startCityPoint == nil) {
    [self.mapView popupBubbleAtPoint:point contentView:startView contentSize:startView.frame.size];
    return;
  }
  else {
    [self.mapView popupBubbleAtPoint:point contentView:endView contentSize:startView.frame.size];
    return;
  }

}

- (IBAction)startSelected:(id)sender
{
  NSLog(@"%s", __FUNCTION__);
  
  _startCityPoint = [_tapCityPoint retain];
  [_tapCityPoint release], _tapCityPoint = nil;
  
  [self.mapView destroyBubble];
}


- (IBAction)endSelected:(id)sender
{
  NSLog(@"%s", __FUNCTION__);
  _endCityPoint = [_tapCityPoint retain];
  [_tapCityPoint release], _tapCityPoint = nil;
  
  [self.mapView destroyBubble];
  
  //导航
  WFWiseFlagBox *box = [WFWiseFlagBox sharedInstance];
  
  WFWiseFlag *startWiseFlag = [box nearWiseFlagWithCityPoint:_startCityPoint];
  NSLog(@"Start WiseFlag[%@]", startWiseFlag.shortName);
  
  WFWiseFlag *endWiseFlag = [box nearWiseFlagWithCityPoint:_endCityPoint];
  NSLog(@"End WiseFlag[%@]", endWiseFlag.shortName);
  
  NSArray *route = [box routeSearchWithStartCityPoint:_startCityPoint andEndCityPoint:_endCityPoint];
  for (NSUInteger i = 0; i < route.count; i++) {
    WFWiseFlag *wiseflag = [route objectAtIndex:i];
    NSLog(@"%d.[%@]",i+1 , wiseflag.shortName);
  }
  
  WFUserMap *userMap = [WFUserMap sharedInstance];
  [userMap showNavigation:route startCityPoint:_startCityPoint endCityPoint:_endCityPoint];

  [self.mapView setNeedsDisplay];
  
  [_startCityPoint release], _startCityPoint = nil;
  [_endCityPoint release], _endCityPoint = nil;
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  NSArray *floors = [[self.mapView currentBuilding] floors];
  
  if (floors) {
    return floors.count;
  }
  else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *reuseIdetify = @"FloorTableViewCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify] autorelease];
  }
  
  NSArray *floors = [[self.mapView currentBuilding] floors];
  
  //由高到低方式显示楼层名
  WFFloor *floor = [floors objectAtIndex:(floors.count - indexPath.row - 1)];

  cell.textLabel.text = floor.name;
  
  cell.textLabel.textAlignment = UITextAlignmentCenter;
  cell.textLabel.font = [cell.textLabel.font fontWithSize:15.0f];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  CGRect rect = tableView.frame;
//  rect.size.height -= 100;
//  tableView.frame = rect;
  
  
  NSLog(@"indexPath.row=%d", indexPath.row);
  NSString *floorID = [NSString stringWithFormat:@"DaYueCheng_%@", [floorArray objectAtIndex:indexPath.row]]; 
  [self.mapView setMapClipID:floorID];
}

@end
