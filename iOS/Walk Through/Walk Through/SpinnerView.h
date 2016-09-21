//
//  SpinnerView.h
//  Walk Through
//
//  Created by Nate Halbmaier on 4/4/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView;
-(void)removeSpinner;
@end
