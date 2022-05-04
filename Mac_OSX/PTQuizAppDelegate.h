//
//  PTQuizAppDelegate.h
//  PTQuiz
//
//  Created by Paul Freshney on 18/09/2011.
//  Copyright 2011 freshney.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PTQuizAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
