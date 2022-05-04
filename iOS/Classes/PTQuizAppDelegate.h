//
//  PTQuizAppDelegate.h
//  PTQuiz
//
//  Created by Paul Freshney on 19/04/2010.
//  Copyright freshney.org 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface PTQuizAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

