//
//  FlipsideViewController.m
//  SquareWordz3
//
//  Created by Paul Freshney on 05/11/2010.
//  Copyright freshney.org. All rights reserved.
//

#import "AboutViewController.h"
#import "devicedetect.h"

extern DeviceDetect *fdeviceDetect;

@implementation AboutViewController

@synthesize delegate;

- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
    
    //UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        NSLog(@"uLFNO w:%f h:%f", screenWidth, screenHeight);
        
        switch ([fdeviceDetect getDevice:screenWidth fromHeight:screenHeight])
        {
            case deviceIPhone4:
            {
                [background setImage:[UIImage imageNamed:@"about.png"]];
                
                break;
            }
    
            case deviceIPhone5:
            {
                [background setImage:[UIImage imageNamed:@"about-568h@2x.png"]];
                
                break;
            }
                
            case deviceIPhone6:
            {
                [background setImage:[UIImage imageNamed:@"about-667h@2x.png"]];
                
                break;
            }
                
            case deviceIPhone6plus:
            {
                [background setImage:[UIImage imageNamed:@"about-736h@3x.png"]];
                
                break;
            }
        }
    }
}

- (IBAction)done {

	[self.delegate aboutViewControllerDidFinish:self];
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
