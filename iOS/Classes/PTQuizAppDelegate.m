//
//  PTQuizAppDelegate.m
//  PTQuiz
//
//  Created by Paul Freshney on 19/04/2010.
//  Copyright freshney.org 2010. All rights reserved.
//

#import "PTQuizAppDelegate.h"
#import "MainViewController.h"

@implementation PTQuizAppDelegate


@synthesize window;
@synthesize mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window setRootViewController:mainViewController];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
