//
//  DPViewController.m
//  Dynamics Project
//
//  Created by Kaitlyn Dornbier on 3/19/14.
//  Copyright (c) 2014 Kaitlyn Dornbier. All rights reserved.
//

#import "DPViewController.h"

@interface DPViewController ()
@property (strong, nonatomic) IBOutlet UIView *ball;
@property (strong, nonatomic) IBOutlet UIView *bar1;
@property (strong, nonatomic) IBOutlet UIView *bar2;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *highScore;

@property (strong, nonatomic) NSNumber *currentScore;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *push;
@property (strong, nonatomic) UICollisionBehavior *collision;

@end

@implementation DPViewController

int highestScore;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.currentScore = [NSNumber numberWithInt:0];
    
    //setting up animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //setting up push behaviour
    self.push = [[UIPushBehavior alloc] initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    [self.push setPushDirection:CGVectorMake(-0.1, 0.1)];
    
    //setting up collision behavior and boundaries
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.ball]];
    [self.collision addBoundaryWithIdentifier:@"bar1" fromPoint:self.bar1.frame.origin toPoint:CGPointMake(self.bar1.frame.origin.x, self.bar1.frame.origin.y + self.bar1.frame.size.height)];
    [self.collision addBoundaryWithIdentifier:@"bar2" fromPoint:self.bar2.frame.origin toPoint:CGPointMake(self.bar2.frame.origin.x, self.bar2.frame.origin.y + self.bar2.frame.size.height)];
    [self.collision addBoundaryWithIdentifier:@"topWall" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(self.view.frame.size.width ,0 )];
    [self.collision addBoundaryWithIdentifier:@"bottomWall" fromPoint:CGPointMake(0, self.view.frame.size.height) toPoint:CGPointMake(self.view.frame.size.height, self.view.frame.size.width )];
    self.collision.collisionDelegate = self;
    
    //retrieve high score
    highestScore = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"highestScore"] integerValue];
    self.highScore.text = [NSString stringWithFormat:@"High Score: %d", highestScore];
    
    //adding behaviour to animator
    [self.animator addBehavior:self.push];
    [self.animator addBehavior:self.collision];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id )item withBoundaryIdentifier:(id )identifier atPoint:(CGPoint)p {
    if ([(NSString*)identifier isEqualToString:@"bar1"]) {
        self.currentScore = [NSNumber numberWithInt:1+[self.currentScore intValue]];
        [self.score setText: [NSString stringWithFormat:@"Score: %ld", (long)[self.currentScore integerValue]]];
        [self.push setPushDirection:CGVectorMake(0.1, -0.1)];
        [self.push setActive:YES];
    } else if ([(NSString*)identifier isEqualToString:@"bar2"]) {
        self.currentScore = [NSNumber numberWithInt:1+[self.currentScore intValue]];
        [self.score setText: [NSString stringWithFormat:@"Score: %ld", (long)[self.currentScore integerValue]]];
        [self.push setPushDirection:CGVectorMake(0.1, -0.1)];
        [self.push setActive:YES];
    } else if ([(NSString*)identifier isEqualToString:@"topWall"]) {
        [self.push setPushDirection:CGVectorMake(-0.1, 0.1)];
        [self.push setActive:YES];
    } else if ([(NSString*)identifier isEqualToString:@"bottomWall"]) {
        [self.push setPushDirection:CGVectorMake(0.1, -0.1)];
        [self.push setActive:YES];
    } else {
        [self.push setPushDirection:CGVectorMake(-0.1, -0.1)];
        [self.push setActive:YES];
    }
    
    //update highestScore
    if([self.currentScore integerValue] > highestScore)
    {
        highestScore = (int)[self.currentScore integerValue];
        self.highScore.text = [NSString stringWithFormat:@"High Score: %d", highestScore];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:highestScore] forKey:@"highestScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //update bars
    if([self.currentScore integerValue]%5 == 0)
    {
        if(self.bar1.frame.size.height > 20)
        {
            CGRect newFrame1 = self.bar1.frame;
            newFrame1.size.height = newFrame1.size.height - 10;
            [self.bar1 setFrame:newFrame1];
            CGRect newFrame2 = self.bar2.frame;
            newFrame2.size.height = newFrame2.size.height - 10;
            [self.bar2 setFrame:newFrame2];
        }
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if(touchPoint.x < self.view.frame.size.width / 2)
    {
        [self.collision removeBoundaryWithIdentifier:@"bar1"];
        CGRect frame = self.bar1.frame;
        [self.bar1 setCenter:CGPointMake(frame.origin.x + frame.size.width/2, touchPoint.y)];
        [self.collision addBoundaryWithIdentifier:@"bar1" fromPoint:self.bar1.frame.origin toPoint:CGPointMake(self.bar1.frame.origin.x, self.bar1.frame.origin.y+self.bar1.frame.size.height)];
    } else {
        [self.collision removeBoundaryWithIdentifier:@"bar2"];
        CGRect frame = self.bar2.frame;
        [self.bar2 setCenter:CGPointMake(frame.origin.x + frame.size.width/2, touchPoint.y)];
        [self.collision addBoundaryWithIdentifier:@"bar2" fromPoint:self.bar2.frame.origin toPoint:CGPointMake(self.bar2.frame.origin.x, self.bar2.frame.origin.y+self.bar1.frame.size.height)];
    }
}

- (IBAction)newGame {
    self.currentScore = 0;
    [self.ball removeFromSuperview];
    [self.collision removeItem:self.ball];
    self.score.text = [NSString stringWithFormat:@"Score: 0"];
    self.ball = [[UIView alloc] initWithFrame:CGRectMake(104,170,20,20)];
    [self.ball setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview:self.ball];
    [self.push addItem:self.ball];
    [self.collision addItem:self.ball];
    
    self.push = [[UIPushBehavior alloc] initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    [self.push setPushDirection:CGVectorMake(-0.1, 0.1)];
    
    CGRect newFrame1 = self.bar1.frame;
    newFrame1.size.height = 160;
    [self.bar1 setFrame:newFrame1];
    CGRect newFrame2 = self.bar2.frame;
    newFrame2.size.height = 160;
    [self.bar2 setFrame:newFrame2];
    
    [self.animator removeBehavior:self.push];
    [self.animator addBehavior:self.push];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
