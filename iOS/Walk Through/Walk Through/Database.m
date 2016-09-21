//
//  Database.m
//  Walk Through
//
//  Created by Nate Halbmaier on 2/20/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "Database.h"
#import "ProfileManagement.h"

@implementation Database

static Database *_database;

+ (Database*)database {
    if (_database == nil) {
        _database = [[Database alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"userDatabase"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }else{
            NSLog(@"Opened just fine");
        }

    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
    //[super dealloc];
}

-(void)getData:(NSString*)email {
    NSString * newEmail = [NSString stringWithFormat:@"'%@'", email];
    //NSLog(@"Email is  %@", newEmail);
    //NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * FROM users where email is ";
    query = [query stringByAppendingString:newEmail];
    sqlite3_stmt *statement;
    NSLog(@"Query is  %@", query);
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"inside if");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *emailChars = (char *) sqlite3_column_text(statement, 2);
            char *passwordChars = (char *) sqlite3_column_text(statement, 3);
            char *phoneChars = (char *) sqlite3_column_text(statement, 4);
            char *cityChars = (char *) sqlite3_column_text(statement, 5);
            char *stateChars = (char *) sqlite3_column_text(statement, 6);
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *email = [[NSString alloc] initWithUTF8String:emailChars];
            NSString *password = [[NSString alloc] initWithUTF8String:passwordChars];
            NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
            NSString *city = [[NSString alloc] initWithUTF8String:cityChars];
            NSString *state = [[NSString alloc] initWithUTF8String:stateChars];
            
            NSLog(@" %@, %@, %@, %@, %@, %@", name, email, password, phone, city, state);
            
            ProfileManagement* profile = [ProfileManagement getInstance];
            profile.name = name;
            profile.email = email;
            profile.password = password;
            profile.phone = phone;
            profile.city = city;
            profile.state = state;
        }
    }
}

- (NSArray *)userInfo{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * FROM users where id is 1";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"inside if");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *emailChars = (char *) sqlite3_column_text(statement, 2);
            char *passwordChars = (char *) sqlite3_column_text(statement, 3);
            char *phoneChars = (char *) sqlite3_column_text(statement, 4);
            char *cityChars = (char *) sqlite3_column_text(statement, 5);
            char *stateChars = (char *) sqlite3_column_text(statement, 6);
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *email = [[NSString alloc] initWithUTF8String:emailChars];
            NSString *password = [[NSString alloc] initWithUTF8String:passwordChars];
            NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
            NSString *city = [[NSString alloc] initWithUTF8String:cityChars];
            NSString *state = [[NSString alloc] initWithUTF8String:stateChars];
            
            
            ProfileManagement* profile = [ProfileManagement getInstance];
            profile.name = name;
            profile.email = email;
            profile.password = password;
            profile.phone = phone;
            profile.city = city;
            profile.state = state;
            
//            ProfileManagement *info = [[ProfileManagement alloc]
//                                       initWithUniqueId:uniqueId name:name email:email password:password phone:phone city:city state:state];
//            [retval addObject:info];

        }
        sqlite3_finalize(statement);
    }else{
        NSLog(@"ERROR");
    }
    return retval;
    
}

@end
