//
//  FrenchPlayingCard.m
//  M1
//
//  Created by James Cremer on 1/30/14.
//  Copyright (c) 2014 James Cremer. All rights reserved.
//

#import "FrenchPlayingCard.h"


@implementation FrenchPlayingCard
@synthesize suit = _suit;

+(NSArray *) rankStrings {
	return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
			 @"9", @"10", @"J", @"Q", @"K"];
}

+(NSArray *)validSuits {
	return @[@"♦️", @"♥️", @"♠️", @"♣️"];
}

+(NSUInteger) maxRank {
	return [[FrenchPlayingCard rankStrings] count] - 1;
}

-(NSString *) contents {
	NSArray *rankStrings = [FrenchPlayingCard rankStrings];
	return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

#define MATCH_RANK_SCORE 10
#define MATCH_PARTIAL_SCORE 8
#define MATCH_SUIT_SCORE 4

- (int) scoreForMatchWith:(NSArray *)otherCards {
	int score = 0;
	if ([otherCards count] == 1) {
		FrenchPlayingCard *otherCard = [otherCards firstObject];
		if (otherCard.rank == self.rank)
			score = MATCH_RANK_SCORE;
		else if ([otherCard.suit isEqualToString:self.suit])
			score = MATCH_SUIT_SCORE;
	} else if ([otherCards count] == 2) {
		FrenchPlayingCard *otherCard1 = otherCards[0];
        FrenchPlayingCard *otherCard2 = otherCards[1];
        
        //All three match rank
		if (otherCard1.rank == self.rank && otherCard2.rank == self.rank)
			score = MATCH_RANK_SCORE;
        //All three match suit
		else if ([otherCard1.suit isEqualToString:self.suit] && [otherCard2.suit isEqualToString:self.suit])
			score = MATCH_SUIT_SCORE;
        //O1 and self match rank, 02 and self match suit
        if(otherCard1.rank == self.rank && [otherCard2.suit isEqualToString:self.suit])
            score = MATCH_PARTIAL_SCORE;
        //O2 and self match rank, 01 and self match suit
        else if(otherCard2.rank == self.rank && [otherCard1.suit isEqualToString:self.suit])
            score = MATCH_PARTIAL_SCORE;
        //O1 and 02 match rank, 01 and self match suit
        else if(otherCard1.rank == otherCard2.rank && [otherCard1.suit isEqualToString:self.suit])
            score = MATCH_PARTIAL_SCORE;
        //O1 and self match rank, 01 and 02 suit
        else if(otherCard1.rank == self.rank && [otherCard1.suit isEqualToString:otherCard2.suit])
            score = MATCH_PARTIAL_SCORE;
        //O2 and self match rank, 01 and 02 suit
        else if(otherCard2.rank == self.rank && [otherCard1.suit isEqualToString:otherCard2.suit])
            score = MATCH_PARTIAL_SCORE;
        //O2 and 01 match rank, 02 and self suit
        else if(otherCard2.rank == otherCard1.rank && [otherCard2.suit isEqualToString:self.suit])
            score = MATCH_PARTIAL_SCORE;
        
        //No points for only two cards matching on three-card match
            
    }
    return score;
}

- (void)setSuit:(NSString *)suit
{
    if ([[FrenchPlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
	}
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [FrenchPlayingCard maxRank]) {
        _rank = rank;
	}
}

@end
