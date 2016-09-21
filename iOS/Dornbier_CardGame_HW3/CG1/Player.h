//
//  Player.h
//  CardGame1
//
//  Created by Kaitlyn Dornbier on 2/26/14.
//  Copyright (c) 2014 James Cremer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Score.h"

@interface Player : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) int highestScore;
@property(nonatomic) int mostRecentScore;

@end
