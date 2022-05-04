//
//  main.m
//  PTQuiz
//
//  Created by Paul Freshney on 19/04/2010.
//  Copyright freshney.org 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "settings.h"
#import "devicedetect.h"

DeviceDetect *fdeviceDetect;

settings *ptqSettings;

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// =========================================================================================	
    
    fdeviceDetect = [[DeviceDetect alloc] init];
    
	ptqSettings  = [[settings alloc] init];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	ptqSettings.sGameType = [prefs integerForKey:@"sgametype"];
	
	if (ptqSettings.sGameType == 0)
	{
		ptqSettings.sGameType = 1;
	}

	ptqSettings.sNumberOfQuestions = [prefs integerForKey:@"snumberofquestions"];
	
	if (ptqSettings.sNumberOfQuestions == 0)
	{
		ptqSettings.sNumberOfQuestions = 2;
	}
	
    
    ptqSettings.answerData = [[NSString alloc] init];
	
	// =========================================================================================		
	
    int retVal = UIApplicationMain(argc, argv, nil, nil);
	
	// =========================================================================================		

    [ptqSettings.answerData release];
    
	[ptqSettings release];
	
    [pool release];
    return retVal;
}
