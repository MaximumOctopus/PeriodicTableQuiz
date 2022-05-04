//
//  MainViewController.m
//  PTQuiz
//
//  Created by Paul Freshney on 19/04/2010.
//  Copyright freshney.org 2010. All rights reserved.
//

#import "MainViewController.h"
#import "settings.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

extern settings *ptqSettings;

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
		
	[super viewDidLoad];
    
    if (IS_WIDESCREEN)
    {
        [background setImage:[UIImage imageNamed:@"menu-568h.png"]];
    }
	
	scGameType.selectedSegmentIndex = ptqSettings.sGameType - 1;
	
	scNumberOfQuestions.selectedSegmentIndex = ptqSettings.sNumberOfQuestions - 1;
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[[controller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)aboutViewControllerDidFinish:(AboutViewController *)controller {
    
    [[controller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo {    
	
	ptqSettings.sGameType          = scGameType.selectedSegmentIndex + 1;
	
	ptqSettings.sNumberOfQuestions = scNumberOfQuestions.selectedSegmentIndex + 1;
	
	NSUserDefaults *savePrefs = [NSUserDefaults standardUserDefaults];
	
	[savePrefs setInteger:ptqSettings.sGameType forKey:@"sgametype"];
	[savePrefs setInteger:ptqSettings.sNumberOfQuestions forKey:@"snumberofquestions"];
	
	[savePrefs synchronize];

	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:controller animated:YES completion:nil];
    
	[controller release];
}

- (IBAction) showAbout {
	
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:controller animated:YES completion:nil];
	
	[controller release];	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
