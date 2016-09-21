//
//  Virtual_TourCreator.h
//  Walk Through
//
//  Created by Nate Halbmaier on 4/2/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Virtual_Tour.h"
#import "Virtual_TourViewpoint.h"

@interface Virtual_TourCreator : NSObject
@property(nonatomic, strong) Virtual_Tour *tour;
@property(nonatomic, strong) Virtual_TourViewpoint *currentView;
@property(nonatomic) int currentViewpointIndex;
-(Virtual_Tour *)getTour;
-(void) setViewImage: (UIImage *)image;
-(void) moveRight;
-(void) moveLeft;
-(void) makeJump;
-(BOOL) canJump;
-(void) jumpBack;

@end
