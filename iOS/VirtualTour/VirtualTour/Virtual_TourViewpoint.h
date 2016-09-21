//
//  Virtual_TourViewpoint.h
//  VirtualTour
//
//  Created by Kaitlyn Dornbier on 2/17/14.
//  Copyright (c) 2014 Kaitlyn Dornbier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Virtual_TourViewpoint : NSObject

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) Virtual_TourViewpoint *jumpToViewpoint;
@property (nonatomic) int jumpIndex;

@end
