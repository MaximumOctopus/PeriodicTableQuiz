//
//  FlipsideViewController.h
//  SquareWordz3
//
//  Created by Paul Freshney on 05/11/2010.
//  Copyright freshney.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutViewControllerDelegate;

@interface AboutViewController : UIViewController <UIActionSheetDelegate> {
	
	id <AboutViewControllerDelegate> delegate;
    
    IBOutlet UIImageView *background;
}

@property (nonatomic, assign) id <AboutViewControllerDelegate> delegate;

- (IBAction) done;

@end


@protocol AboutViewControllerDelegate

- (void) aboutViewControllerDidFinish:(AboutViewController *)controller;

@end
