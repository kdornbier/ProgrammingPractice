//
//  TakeTourNavigator.h
//  Walk Through
//
//  Created by Kaitlyn Dornbier on 4/7/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Virtual_Tour.h"
#import "Virtual_TourViewpoint.h"

@interface TakeTourNavigator : NSObject

@property(nonatomic, weak) Virtual_Tour *tour;
@property(nonatomic, weak) Virtual_TourViewpoint *currentView;
@property(nonatomic) int currentViewpointIndex;
-(void) setTour:(Virtual_Tour *)newTour;
-(void) moveRight;
-(void) moveLeft;
-(void) jumpBack;

@end
