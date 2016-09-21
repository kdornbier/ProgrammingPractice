//
//  Virtual_TourViewPoint.h
//  Walk Through
//
//  Created by Nate Halbmaier on 4/2/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Virtual_TourViewpoint : NSObject

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) Virtual_TourViewpoint *jumpToViewpoint;
@property (nonatomic) int jumpIndex;

@end
