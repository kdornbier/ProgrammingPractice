//
//  CGViewController.m
//  CG1
//
//  Created by James Cremer on 1/30/14.
//  Copyright (c) 2014 James Cremer. All rights reserved.
//

#import "CGViewController.h"
#import "Card.h"
#import "Deck.h"
#import "FrenchPlayingCardDeck.h"
#import "MatchingGame.h"

@interface CGViewController ()
//@property (strong, nonatomic) MatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UIButton *deckButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchAmount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@end

@implementation CGViewController

int currentHighScore = 0;
BOOL requestNewCard = NO;
Deck *currentDeck;

- (MatchingGame *) game {
	if (!_game)
    {
		_game = [[MatchingGame alloc] initWithNumCards:[self.cardButtons count]
                                              fromDeck:[self createDeck]];
        //currentHighScore = [[_game.highScores objectAtIndex:0] integerValue];
    }
	return _game;
}

- (Deck *) createDeck {
    currentDeck = [[FrenchPlayingCardDeck alloc] init];
	return currentDeck;
}

- (void) updateUI {
		
    //NSLog(@"%@", self.game.highScores);
    //NSLog(@"current high score is %@", [self.game.highScores objectAtIndex:0]);
    for(UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = (int) [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        if(card.isMatched) [cardButton setOpaque:YES];
        cardButton.enabled = !card.isMatched; //disable matched card
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    if(self.game.score > currentHighScore)
    {
        currentHighScore = self.game.score;
        self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d", currentHighScore];
    }
    
    if(currentDeck.cards.count == 0)
    {
        [self.deckButton setHidden:YES];
    }
}
- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}
-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (IBAction)touchedCardButton:(UIButton *)sender {
	
    if([self.matchAmount isEnabled])
    {
        [self.matchAmount setEnabled:NO];
    }
    int chosenButtonIndex = (int)[self.cardButtons indexOfObject:sender];
    if(requestNewCard)
    {
        requestNewCard = !requestNewCard;
        [self.game requestNewCard:chosenButtonIndex fromDeck: currentDeck];
    } else {
        [self.game chooseCardAtIndex:chosenButtonIndex forAmount: [self.matchAmount selectedSegmentIndex]];
    }
    
    //[[NSUserDefaults standardUserDefaults] setObject:self.game.highScores forKey:@"highScores"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateUI]; //Controller interprets model into view
}

- (IBAction)newGame {
    for(int i = 0; i < self.game.highScores.count; i++)
        if(self.game.score > [[self.game.highScores objectAtIndex:i] integerValue])
        {
            [self.game.highScores insertObject:[NSNumber numberWithInt:self.game.score] atIndex:i];
            break;
        }
    
    [self.game startNewGame];
    MatchingGame *newGame = [self.game initWithNumCards:[self.cardButtons count]
                        fromDeck:[self createDeck]];
    self.game = newGame;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.game.highScores forKey:@"highScores"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateUI];
    [self.matchAmount setEnabled:YES];
}

- (IBAction)newCard
{
    requestNewCard = !requestNewCard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSMutableArray *savedHighScores = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"highScores"] mutableCopy];
	self.game.highScores = savedHighScores;
    self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %@", [self.game.highScores objectAtIndex:0]];
    currentHighScore = [[self.game.highScores objectAtIndex:0] integerValue];
    
}

-(BOOL)shouldAutorotate
{
    return NO;
}
@end
