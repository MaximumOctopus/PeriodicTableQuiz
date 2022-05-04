//
//  quiz.h
//  PTQuiz
//
//  Created by Paul Freshney on 18/09/2011.
//  Copyright 2011 freshney.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <sqlite3.h>

@interface quiz : NSObject <NSWindowDelegate> {

	// ==================================================================================================
	// == Game Selection Scree ==========================================================================
	// ==================================================================================================
	
	NSArray *myButtons;
	
	sqlite3 *db;	
	
	// ==================================================================================================
	// == Game Selection Scree ==========================================================================
	// ==================================================================================================
	
	IBOutlet NSButton *difficultyEasy, *difficultyHard;
	IBOutlet NSTabView *tabView;
	
	// ==================================================================================================
	// == In-Game Screen ================================================================================
	// ==================================================================================================
	
	IBOutlet NSButton *quit, *nextQuestion, *getHint;
	IBOutlet NSButton *bAnswer1, *bAnswer2, *bAnswer3, *bAnswer4, *bAnswer5;
	
	IBOutlet NSTextField *navBarLabel, *labelQuestion;
		
	IBOutlet NSImageView *questionImage;
	
	// ==================================================================================================
	// == Game Over Screen ==============================================================================
	// ==================================================================================================

	IBOutlet NSImageView *trophyImage;
	IBOutlet NSTextField *finishText;
}

- (IBAction)newQuiz:(id)sender;
- (IBAction)changeDifficulty:(id)sender;

- (void)setupGame:(int)xGameLength;
- (IBAction) getNextQuestion:(id)sender;
- (void)setAnswer;
- (IBAction) hint:(id)sender;
- (IBAction) answerClick:(id)sender;

- (void) endGame;

- (IBAction) backToMenuClick:(id)sender;

@end