//
//  Virtual_TourCreator.h
//  VirtualTour
//
//  Created by Kaitlyn Dornbier on 2/24/14.
//  Copyright (c) 2014 Kaitlyn Dornbier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Virtual_Tour.h"
#import "Virtual_TourViewpoint.h"

@interface Virtual_TourCreator : NSObject

@property(nonatomic, strong) Virtual_Tour *tour;
@property(nonatomic, strong) Virtual_TourViewpoint *currentView;
@property(nonatomic) int currentViewpointIndex;

-(void) setViewImage: (UIImage *)image;
-(void) moveRight;
-(void) moveLeft;
-(void) makeJump;
-(BOOL) canJump;
-(void) jumpBack;

@end
