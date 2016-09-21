//
//  Database.h
//  Walk Through
//
//  Created by Nate Halbmaier on 2/20/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject{
    sqlite3 *_database;
    
}

+ (Database*)database;
- (NSArray *)userInfo;
-(void)getData:(NSString*)email;

@end

