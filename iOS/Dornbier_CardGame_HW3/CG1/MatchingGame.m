//
//  MatchingGame.m
//  CardGame1
//
//  Created by James Cremer on 2/6/14.
//  Copyright (c) 2014 James Cremer. All rights reserved.
//

#import "MatchingGame.h"

@interface MatchingGame ()

@property (strong, nonatomic) NSMutableArray *cardsInPlay;
@property (nonatomic, readwrite) NSInteger score;

@end

@implementation MatchingGame

-(NSMutableArray *) cardsInPlay {
	if (!_cardsInPlay)
		_cardsInPlay = [[NSMutableArray alloc] init];
	return _cardsInPlay;
}

-(NSMutableArray *) highScores
{
    if(!_highScores)
    {
        _highScores = [[NSMutableArray alloc] initWithCapacity:5];
        [_highScores insertObject:[NSNumber numberWithInt:0] atIndex:0];
    }
    return _highScores;
}

-(instancetype) initWithNumCards:(NSUInteger)numCards fromDeck:(Deck *)deck {
	self = [super init];
	for (int i = 0; i < numCards; i++) {
		Card *card = [deck drawRandomCard];
		if (card)
        {
			[self.cardsInPlay addObject:card];
        }
		else {
			self = nil;
			break;
		}
	}
	return self;
};

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 1;
static const int COST_TO_CHOOSE = 1;
static const int COST_TO_CHANGE = 2;

-(void) chooseCardAtIndex: (NSUInteger)index forAmount:(NSUInteger)matches{
	Card *chosenCard = [self cardAtIndex:index];
	if (!chosenCard.isMatched) {
		if (chosenCard.isChosen) {
			chosenCard.chosen = NO;
		} else {
            NSMutableArray *otherCards;
            for(Card *selectedCard in self.cardsInPlay)
            {
                if(selectedCard.isChosen && !selectedCard.isMatched)
                {
                    if(!otherCards)
                    {
                        otherCards = [NSMutableArray arrayWithObject:selectedCard];
                    } else {
                        [otherCards addObject:selectedCard];
                    }
                }
            }
            if([otherCards count] == matches + 1)
            {
                int matchScore = [chosenCard scoreForMatchWith:otherCards];
                if(matchScore != 0)
                {
                    self.score += matchScore * MATCH_BONUS;
                    for(Card *otherCard in otherCards)
                    {
                        otherCard.matched = YES;
                    }
                    chosenCard.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for(Card *otherCard in otherCards)
                    {
                        otherCard.chosen = NO;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
			chosenCard.chosen = YES;
		}
	}
}

-(Card *) cardAtIndex: (NSUInteger)index {
	return (index <[self.cardsInPlay count]) ? self.cardsInPlay[index] : nil;
}

static const int MAX_HIGH_SCORES = 5;

-(void) startNewGame
{
 
    while(self.highScores.count > MAX_HIGH_SCORES)
    {
        [self.highScores removeLastObject];
    }
    self.cardsInPlay = nil;
    self.score = 0;
}

-(void) requestNewCard:(NSUInteger)index fromDeck:(Deck *)deck
{
    Card *chosenCard = [self cardAtIndex:index];
    chosenCard.chosen = NO;
    [self.cardsInPlay replaceObjectAtIndex:index
                                withObject:[deck drawRandomCard]];
    self.score -= COST_TO_CHANGE;
}

@end
