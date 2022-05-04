//
//  MainViewController.h
//  PTQuiz
//
//  Created by Paul Freshney on 19/04/2010.
//  Copyright freshney.org 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "AboutViewController.h"


@interface MainViewController : UIViewController <AboutViewControllerDelegate, FlipsideViewControllerDelegate> {

	IBOutlet UIBarButtonItem *about;
	
	IBOutlet UISegmentedControl *scGameType;
	
	IBOutlet UISegmentedControl *scNumberOfQuestions;
    
    IBOutlet UIImageView *background;	
}

- (IBAction) showInfo;

- (IBAction) showAbout;

@end