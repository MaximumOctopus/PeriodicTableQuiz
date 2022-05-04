//
//  FlipsideViewController.m
//  SquareWordz3
//
//  Created by Paul Freshney on 05/11/2010.
//  Copyright freshney.org. All rights reserved.
//

#import "AnswersViewController.h"
#import "settings.h"

extern settings *ptqSettings;

@implementation AnswersViewController

@synthesize delegate;

- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    answerList.text = ptqSettings.answerData;
}


- (IBAction)done {

	[self.delegate answersViewControllerDidFinish:self];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	
    [super dealloc];
}


@end
